import 'package:flutter/material.dart';
import '../../../data/models/lesson_result.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../configs/di.dart';
import '../../commons/rounded_button.dart';
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

  // Words coming from the last Sample generation
  List<SelectedWord> _sampleWords = [];

  int get _wordCount {
    final t = _textController.text.trim();
    if (t.isEmpty) return 0;
    return t.split(RegExp(r'\s+')).length;
  }

  Future<void> _openLevelPicker() async {
    final picked = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectLevelScreen(currentLevel: _selectedLevelCode),
      ),
    );
    if (picked != null && mounted) {
      final labels = {
        'A1': 'A1 - Beginner',
        'A2': 'A2 - Elementary',
        'B1': 'B1 - Intermediate',
        'B2': 'B2 - Upper-Intermediate',
        'C1': 'C1 - Advanced',
        'C2': 'C2 - Proficiency',
      };
      setState(() {
        _selectedLevelCode = picked;
        _selectedLevelLabel = labels[picked] ?? picked;
      });
    }
  }

  Future<void> _generateLesson() async {
    final customText = _textController.text.trim();
    if (customText.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final aiRepository = DI().sl<AiRepository>();

      final result = await aiRepository.generateLesson(
        customText: customText,
        level: _selectedLevelCode,
      );

      // If we have sampleWords from the sample generation, use those.
      // Otherwise create minimal SelectedWord list from vocabulary in result.
      final wordsForDetail = _sampleWords.isNotEmpty
          ? _sampleWords
          : result.vocabulary
              .map((v) => SelectedWord(
                    word: v.word,
                    level: _selectedLevelCode,
                    category: '',
                    definition: v.meaning,
                    example: v.example,
                    phoneticText: v.pronunciation,
                  ))
              .toList();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AiLessonDetailScreen(
              title: result.title,
              passage: result.passage,
              selectedWords: wordsForDetail,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating lesson: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_rounded, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text('New Lesson',
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
                          Text("Here's your current English level.",
                            style: textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _openLevelPicker,
                      child: Text('Change', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600)),
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
                      Text('Input text to learn',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      const Icon(Icons.info_outline_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push<SamplePassageResponse>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SelectTopicScreen(level: _selectedLevelCode),
                      ),
                    );
                    if (result != null && result.passage.trim().isNotEmpty && mounted) {
                      setState(() {
                        _textController.text = result.passage;
                        _sampleWords = result.selectedWords;
                      });
                    }
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: const Text('Sample'),
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
              onChanged: (_) => setState(() => _sampleWords = []),
              decoration: InputDecoration(
                hintText: "Enter or paste English text to learn vocabulary.\nExample: Why can't dogs eat chocolate?",
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
                        ? const SizedBox(
                            height: 24, width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Create Lesson with AI',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
