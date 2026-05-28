import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../configs/di.dart';
import '../../../data/repositories/ai_repository.dart';

class GrammarAiScreen extends StatefulWidget {
  final String grammarTopic;
  final int lessonId;

  const GrammarAiScreen({
    super.key,
    required this.grammarTopic,
    required this.lessonId,
  });

  @override
  State<GrammarAiScreen> createState() => _GrammarAiScreenState();
}

class _GrammarAiScreenState extends State<GrammarAiScreen> {
  final _controller = TextEditingController();
  final _aiRepo = DI().sl<AiRepository>();

  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  // For quiz
  final Map<int, int?> _selectedAnswers = {};
  final Map<int, bool?> _answeredCorrectly = {};

  // History of generated examples
  final List<_HistoryEntry> _history = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final interest = _controller.text.trim();
    if (interest.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
      _selectedAnswers.clear();
      _answeredCorrectly.clear();
    });

    try {
      final result = await _aiRepo.generateGrammarExamples(
        grammarTopic: widget.grammarTopic,
        userInterest: interest,
      );
      if (mounted) {
        setState(() {
          _result = result;
          _isLoading = false;
          _history.insert(0, _HistoryEntry(interest: interest, result: result));
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _selectAnswer(int questionIndex, int optionIndex, int correctAnswer) {
    if (_answeredCorrectly[questionIndex] != null) return; // already answered
    setState(() {
      _selectedAnswers[questionIndex] = optionIndex;
      _answeredCorrectly[questionIndex] = optionIndex == correctAnswer;
    });
  }

  void _loadFromHistory(_HistoryEntry entry) {
    setState(() {
      _result = entry.result;
      _controller.text = entry.interest;
      _selectedAnswers.clear();
      _answeredCorrectly.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'AI Examples',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Grammar topic header
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withOpacity(0.15), cs.primary.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: cs.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.grammarTopic,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Nhập chủ đề yêu thích để AI tạo ví dụ',
                        style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'VD: Iron Man, Bóng đá, K-pop...',
                      hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.4)),
                      filled: true,
                      fillColor: isDark ? cs.surfaceContainerHighest : cs.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      prefixIcon: Icon(Icons.interests, color: cs.primary.withOpacity(0.6)),
                    ),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _generate(),
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _isLoading ? null : _generate,
                    child: Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      child: _isLoading
                          ? LoadingAnimationWidget.staggeredDotsWave(color: cs.onPrimary, size: 24)
                          : Icon(Icons.send_rounded, color: cs.onPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoadingAnimationWidget.fourRotatingDots(color: cs.primary, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          'Đang tạo ví dụ...',
                          style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: cs.error, size: 48),
                              const SizedBox(height: 12),
                              Text('Đã xảy ra lỗi', style: TextStyle(color: cs.error, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(_error!, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      )
                    : _result != null
                        ? _buildResult(cs, isDark)
                        : _history.isEmpty
                            ? _buildEmptyState(cs)
                            : _buildHistoryList(cs, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lightbulb_outline, size: 64, color: cs.primary.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Nhập chủ đề yêu thích của bạn',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: cs.onSurface.withOpacity(0.7)),
            ),
            const SizedBox(height: 8),
            Text(
              'AI sẽ tạo ví dụ và câu hỏi về\n"${widget.grammarTopic}" theo chủ đề của bạn!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(ColorScheme cs, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isDark ? cs.surfaceContainerHighest : cs.surfaceContainerLow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Icons.history, color: cs.primary),
            title: Text(entry.interest, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text('${(entry.result['examples'] as List?)?.length ?? 0} ví dụ • ${(entry.result['questions'] as List?)?.length ?? 0} câu hỏi',
                style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.5))),
            trailing: Icon(Icons.chevron_right, color: cs.onSurface.withOpacity(0.3)),
            onTap: () => _loadFromHistory(entry),
          ),
        );
      },
    );
  }

  Widget _buildResult(ColorScheme cs, bool isDark) {
    final examples = (_result!['examples'] as List?) ?? [];
    final questions = (_result!['questions'] as List?) ?? [];
    final tip = _result!['tip'] as String? ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        // Tip
        if (tip.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 10),
                Expanded(child: Text(tip, style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.8)))),
              ],
            ),
          ),

        // Examples section
        _sectionHeader(cs, Icons.format_quote, 'Ví dụ', Colors.blue),
        ...examples.asMap().entries.map((entry) {
          final i = entry.key;
          final ex = Map<String, dynamic>.from(entry.value);
          return _buildExampleCard(cs, isDark, i, ex);
        }),

        const SizedBox(height: 16),

        // Quiz section
        _sectionHeader(cs, Icons.quiz, 'Câu hỏi', Colors.deepPurple),
        ...questions.asMap().entries.map((entry) {
          final i = entry.key;
          final q = Map<String, dynamic>.from(entry.value);
          return _buildQuestionCard(cs, isDark, i, q);
        }),

        // History button
        if (_history.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextButton.icon(
              onPressed: () => setState(() => _result = null),
              icon: Icon(Icons.history, color: cs.primary),
              label: Text('Xem lịch sử (${_history.length})', style: TextStyle(color: cs.primary)),
            ),
          ),
      ],
    );
  }

  Widget _sectionHeader(ColorScheme cs, IconData icon, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: cs.onSurface)),
        ],
      ),
    );
  }

  Widget _buildExampleCard(ColorScheme cs, bool isDark, int index, Map<String, dynamic> ex) {
    final en = ex['en'] as String? ?? '';
    final vi = ex['vi'] as String? ?? '';
    final highlight = ex['highlight'] as String? ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: isDark ? cs.surfaceContainerHighest : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blue.withOpacity(0.15),
                  child: Text('${index + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _highlightText(en, highlight, cs),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 38),
              child: Text(
                vi,
                style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.55), fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightText(String text, String highlight, ColorScheme cs) {
    if (highlight.isEmpty || !text.toLowerCase().contains(highlight.toLowerCase())) {
      return Text(text, style: TextStyle(fontSize: 15, color: cs.onSurface));
    }

    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();
    final start = lowerText.indexOf(lowerHighlight);
    final end = start + highlight.length;

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 15, color: cs.onSurface),
        children: [
          TextSpan(text: text.substring(0, start)),
          TextSpan(
            text: text.substring(start, end),
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: cs.primary.withOpacity(0.4),
            ),
          ),
          TextSpan(text: text.substring(end)),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ColorScheme cs, bool isDark, int index, Map<String, dynamic> q) {
    final question = q['question'] as String? ?? '';
    final options = List<String>.from(q['options'] ?? []);
    final correctAnswer = q['correctAnswer'] as int? ?? 0;
    final explanation = q['explanation'] as String? ?? '';

    final selected = _selectedAnswers[index];
    final isAnswered = _answeredCorrectly[index] != null;
    final isCorrect = _answeredCorrectly[index] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? cs.surfaceContainerHighest : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.deepPurple.withOpacity(0.15),
                  child: Text('Q${index + 1}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(question, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: cs.onSurface)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...options.asMap().entries.map((entry) {
              final optIdx = entry.key;
              final optText = entry.value;
              final isSelected = selected == optIdx;
              final isCorrectOpt = optIdx == correctAnswer;

              Color bgColor;
              Color borderColor;
              Color textColor;

              if (!isAnswered) {
                bgColor = isSelected ? cs.primary.withOpacity(0.08) : Colors.transparent;
                borderColor = isSelected ? cs.primary : cs.onSurface.withOpacity(0.12);
                textColor = cs.onSurface;
              } else {
                if (isCorrectOpt) {
                  bgColor = Colors.green.withOpacity(0.1);
                  borderColor = Colors.green;
                  textColor = isDark ? Colors.green.shade300 : Colors.green.shade700;
                } else if (isSelected && !isCorrectOpt) {
                  bgColor = Colors.red.withOpacity(0.1);
                  borderColor = Colors.red;
                  textColor = isDark ? Colors.red.shade300 : Colors.red.shade700;
                } else {
                  bgColor = Colors.transparent;
                  borderColor = cs.onSurface.withOpacity(0.08);
                  textColor = cs.onSurface.withOpacity(0.5);
                }
              }

              return GestureDetector(
                onTap: () => _selectAnswer(index, optIdx, correctAnswer),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: isAnswered && isCorrectOpt ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${String.fromCharCode(65 + optIdx)}.',
                        style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(optText, style: TextStyle(color: textColor, fontSize: 14))),
                      if (isAnswered && isCorrectOpt) Icon(Icons.check_circle, color: Colors.green, size: 18),
                      if (isAnswered && isSelected && !isCorrectOpt) Icon(Icons.cancel, color: Colors.red, size: 18),
                    ],
                  ),
                ),
              );
            }),

            // Explanation
            if (isAnswered)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isCorrect ? Colors.green : Colors.orange).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isCorrect ? '✅' : '💡', style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        explanation,
                        style: TextStyle(fontSize: 13, color: cs.onSurface.withOpacity(0.75)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryEntry {
  final String interest;
  final Map<String, dynamic> result;

  _HistoryEntry({required this.interest, required this.result});
}
