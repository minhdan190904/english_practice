import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/lesson_result.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../configs/di.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';

class NewAiLessonScreen extends StatefulWidget {
  const NewAiLessonScreen({super.key});

  @override
  State<NewAiLessonScreen> createState() => _NewAiLessonScreenState();
}

class _NewAiLessonScreenState extends State<NewAiLessonScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedLevel = 'B1 - Intermediate';
  String _selectedTopic = 'Science';
  bool _isLoading = false;

  final List<String> _topics = [
    'Technology',
    'Science',
    'Business',
    'Travel',
    'Health',
    'Environment',
    'Arts & Entertainment',
    'Sports',
  ];

  Future<void> _generateLesson() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customText = _textController.text.trim();
      final aiRepository = DI().sl<AiRepository>();
      
      final result = await aiRepository.generateLesson(
        topic: customText.isEmpty ? _selectedTopic : null,
        customText: customText.isNotEmpty ? customText : null,
        level: _selectedLevel,
      );

      if (mounted) {
        // TODO: Navigate to LessonDetailScreen to show the result
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success! Generated lesson: ${result.title}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('New AI Lesson'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                    child: Text(
                      _selectedLevel,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Show level picker
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Input text to learn',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: "Enter or paste English text to learn vocabulary. Example: Why can't dogs eat chocolate?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR GENERATE BY TOPIC', style: textTheme.bodySmall),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Select Topic',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _topics.map((topic) {
                final isSelected = _selectedTopic == topic;
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedTopic = topic;
                        _textController.clear();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            RoundedButton(
              onPressed: _isLoading ? null : _generateLesson,
              borderRadius: 16,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Create Lesson with AI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
