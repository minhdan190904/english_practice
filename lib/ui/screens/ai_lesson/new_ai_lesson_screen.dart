import '../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/saved_lesson.dart';
import '../../../data/repositories/ai_repository.dart';
import 'ai_lesson_detail_screen.dart';
import 'select_level_screen.dart';
import 'select_topic_screen.dart';

class NewAiLessonScreen extends StatefulWidget {
  const NewAiLessonScreen({super.key});

  @override
  State<NewAiLessonScreen> createState() => _NewAiLessonScreenState();
}

class _NewAiLessonScreenState extends State<NewAiLessonScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLevelCode = 'B1';
  String _selectedLevelLabel = 'B1 - Intermediate';
  bool _isLoading = false;
  String _loadingMessage = '';

  int get _wordCount {
    final t = _textController.text.trim();
    if (t.isEmpty) return 0;
    return t.split(RegExp(r'\s+')).length;
  }

  Future<void> _openLevelPicker() async {
    final picked = await Navigator.of(context, rootNavigator: true).push<String>(
      MaterialPageRoute(
        builder: (_) => SelectLevelScreen(currentLevel: _selectedLevelCode),
      ),
    );
    if (picked != null && mounted) {
      final labels = {
        'A1': 'A1 - Mới bắt đầu',
        'A2': 'A2 - Sơ cấp',
        'B1': 'B1 - Trung cấp',
        'B2': 'B2 - Trung cao cấp',
        'C1': 'C1 - Cao cấp',
        'C2': 'C2 - Thành thạo',
      };
      setState(() {
        _selectedLevelCode = picked;
        _selectedLevelLabel = labels[picked] ?? picked;
      });
    }
  }

  /// Get words the user has already learned from past lessons (local storage)
  Future<List<String>> _getLearnedWords() async {
    try {
      final lessons = await SavedLessonsRepository().getAll();
      return lessons
          .expand((l) => l.words)
          .map((w) => w.word.toLowerCase().trim())
          .toSet()
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _generateLesson() async {
    final inputText = _textController.text.trim();
    if (inputText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Đang tạo đoạn văn...';
    });

    try {
      final aiRepository = GetIt.instance<AiRepository>();

      // Collect learned words to avoid repeating them
      final learnedWords = await _getLearnedWords();

      setState(() => _loadingMessage = 'Đang phân tích từ vựng...');

      // Single API call: generate passage + detect new vocab
      final result = await aiRepository.generateLessonFromInput(
        inputText: inputText,
        level: _selectedLevelCode,
        learnedWords: learnedWords,
      );

      final wordsForDetail = result.vocabulary
          .map((v) => SelectedWord(
                word: v.word,
                level: _selectedLevelCode,
                category: '',
                definition: v.meaning,
                definitionVi: v.meaningVi,
                example: v.example,
                phoneticText: v.pronunciation,
                phoneticUrl: v.phoneticUrl,
                phoneticAmUrl: v.phoneticAmUrl,
              ))
          .toList();

      // Auto-save lesson to local storage
      final lesson = SavedLesson(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result.title,
        passage: result.passage,
        passageVi: result.passageVi,
        words: wordsForDetail
            .map((w) => SavedWord(
                  word: w.word,
                  definition: w.definition,
                  definitionVi: w.definitionVi,
                  shortMeaningVi: w.shortMeaningVi,
                  example: w.example,
                  phoneticText: w.phoneticText,
                  phoneticAmText: w.phoneticAmText,
                  phoneticUrl: w.phoneticUrl,
                  phoneticAmUrl: w.phoneticAmUrl,
                  pos: w.pos,
                  level: w.level,
                  category: w.category,
                ))
            .toList(),
        createdAt: DateTime.now(),
        imageBase64: result.imageBase64,
      );
      await SavedLessonsRepository().save(lesson);

      if (mounted) {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => AiLessonDetailScreen(
              title: result.title,
              passage: result.passage,
              passageVi: result.passageVi,
              selectedWords: wordsForDetail,
              imageBase64: result.imageBase64,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${L10n.tr(context, 'error_generating_lesson')}$e')),
        );
      }
    } finally {
      if (mounted) setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(L10n.tr(context, 'new_lesson'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
                fontSize: 20,
              )),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level card
            InkWell(
              onTap: _openLevelPicker,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(50),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_selectedLevelLabel,
                            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          Text(L10n.tr(context, 'current_english_level'),
                            style: textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _openLevelPicker,
                      child: Text(L10n.tr(context, 'change'), style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Input label + Sample button
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(L10n.tr(context, 'input_text_to_learn'),
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // SelectTopicScreen now handles the full flow:
                    // sample-passage → generate-lesson → navigate to AiLessonDetailScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectTopicScreen(level: _selectedLevelCode),
                      ),
                    );
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: Text(L10n.tr(context, 'sample')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Text input
            TextField(
              controller: _textController,
              maxLines: 8,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Nhập chủ đề, từ khóa hoặc đoạn văn để học...\nVD: tại sao chó không ăn được sôcôla? / \"Dogs can't eat chocolate because...\"",
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Word count: $_wordCount/300 (1000 words with Pro)',
              style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
            ),
            const SizedBox(height: 28),

            // Generate button (Gradient)
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: _isLoading || _wordCount == 0
                      ? [Colors.grey.shade400, Colors.grey.shade400]
                      : [colorScheme.primary, Colors.blueAccent, Colors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: _isLoading || _wordCount == 0
                    ? []
                    : [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(80),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading || _wordCount == 0 ? null : _generateLesson,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: _isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                              const SizedBox(width: 10),
                              Text(
                                _loadingMessage.isNotEmpty ? _loadingMessage : '...',
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(L10n.tr(context, 'create_lesson_with_ai'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            ],
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'AI will generate a personalized lesson based on your level.\nUpgrade to Pro for faster speed and improved lesson quality.',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
