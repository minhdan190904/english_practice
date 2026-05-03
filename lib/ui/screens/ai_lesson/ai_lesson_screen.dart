import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'new_ai_lesson_screen.dart';

class AiLessonScreen extends StatelessWidget {
  const AiLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Lessons', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('No AI lessons yet.', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Tap the + button to create a new lesson.', style: textTheme.bodyMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewAiLessonScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
