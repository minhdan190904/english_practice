import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/di.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/word.dart';
import '../../../data/models/sense.dart';
import '../../../data/models/example.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/rounded_button.dart';
import '../review/flash_card_screen.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';

class AiLessonDetailScreen extends StatefulWidget {
  final String title;
  final String passage;
  final List<SelectedWord> selectedWords;

  const AiLessonDetailScreen({
    super.key,
    required this.title,
    required this.passage,
    required this.selectedWords,
  });

  @override
  State<AiLessonDetailScreen> createState() => _AiLessonDetailScreenState();
}

class _AiLessonDetailScreenState extends State<AiLessonDetailScreen> {
  bool _showFull = false;

  /// Build highlighted RichText from passage
  Widget _buildHighlightedPassage(BuildContext context) {
    final theme = Theme.of(context);
    final highlightSet = widget.selectedWords
        .map((w) => w.word.toLowerCase())
        .toSet();

    // Split keeping punctuation attached to words using a simple approach
    final rawWords = widget.passage.split(RegExp(r'(\s+)'));
    final spans = <TextSpan>[];

    for (final token in rawWords) {
      if (token.trim().isEmpty) {
        spans.add(TextSpan(text: token));
        continue;
      }
      // Strip leading/trailing punctuation to find the core word
      final match = RegExp(r"^([^a-zA-Z']*)([a-zA-Z']+)([^a-zA-Z']*)$").firstMatch(token);
      if (match != null) {
        final pre = match.group(1) ?? '';
        final word = match.group(2) ?? '';
        final post = match.group(3) ?? '';
        final isHighlighted = highlightSet.contains(word.toLowerCase());
        if (isHighlighted) {
          if (pre.isNotEmpty) spans.add(TextSpan(text: pre));
          spans.add(TextSpan(
            text: word,
            style: TextStyle(
              backgroundColor: const Color(0xFFFDE68A),
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ));
          if (post.isNotEmpty) spans.add(TextSpan(text: post));
        } else {
          spans.add(TextSpan(text: token));
        }
      } else {
        spans.add(TextSpan(text: token));
      }
      spans.add(const TextSpan(text: ' '));
    }

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.7, color: Colors.black87),
        children: spans,
      ),
    );
  }

  void _practiceNow() {
    // Convert SelectedWord list to Word list for FlashCardScreen
    final words = widget.selectedWords.asMap().entries.map((entry) {
      final i = entry.key;
      final w = entry.value;
      return Word(
        word: w.word,
        pos: w.pos ?? '',
        phonetic: '',
        phoneticText: w.phoneticText ?? '',
        phoneticAm: '',
        phoneticAmText: w.phoneticAmText ?? '',
        senses: [
          Sense(
            definition: w.definition ?? '',
            examples: w.example != null ? [Example(cf: '', x: w.example!)] : [],
          ),
        ],
        index: i,
      );
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DI().sl<VocabularyBloc>()),
            BlocProvider(create: (_) => DI().sl<IapBloc>()),
          ],
          child: FlashCardScreen(words: words, title: widget.title),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wordCount = widget.passage.trim().split(RegExp(r'\s+')).length;
    final isLong = widget.passage.length > 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(L10n.tr(context, 'created_today'),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                      const SizedBox(width: 16),
                      Icon(Icons.text_fields_rounded, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('$wordCount words',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.flag_outlined, size: 14),
                        label: Text(L10n.tr(context, 'report')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Passage card with highlight
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHighlightedPassage(context),
                        if (isLong && !_showFull) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => _showFull = true),
                            child: Text(L10n.tr(context, 'show_more'),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              )),
                          ),
                        ],
                      ],
                    ),
                    secondChild: _buildHighlightedPassage(context),
                    crossFadeState: (_showFull || !isLong)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Practice Now button (Gradient)
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, Colors.blueAccent, Colors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _practiceNow,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.style, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(L10n.tr(context, 'practice_now'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Vocabulary list
            Text(L10n.tr(context, 'vocabulary_list'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.selectedWords.length,
                separatorBuilder: (_, __) => const Divider(height: 1, indent: 64),
                itemBuilder: (context, i) {
                  final word = widget.selectedWords[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withAlpha(80),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.volume_up_rounded,
                        color: theme.colorScheme.primary, size: 20),
                    ),
                    title: Text(word.word,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (word.definition != null)
                          Text('${L10n.tr(context, 'meaning_prefix')}${word.definition}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                        if (word.phoneticText != null)
                          Text('${L10n.tr(context, 'pronunciation_prefix')}${word.phoneticText}',
                            style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12)),
                        if (word.example != null)
                          Text(word.example!,
                            style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.selectedWords.removeAt(i);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
