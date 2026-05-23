import 'package:flutter/material.dart';

import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/saved_lesson.dart';
import '../../../utils/l10n.dart';
import '../../commons/base_page.dart';
import 'ai_lesson_detail_screen.dart';
import 'new_ai_lesson_screen.dart';

class AiLessonScreen extends StatefulWidget {
  const AiLessonScreen({super.key});

  @override
  State<AiLessonScreen> createState() => _AiLessonScreenState();
}

class _AiLessonScreenState extends State<AiLessonScreen> {
  late Future<List<SavedLesson>> _lessonsFuture;
  final SavedLessonsRepository _repo = SavedLessonsRepository();

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    _lessonsFuture = _repo.getAll();
  }

  void _refresh() {
    setState(() => _loadLessons());
  }

  Future<void> _deleteLesson(String id) async {
    await _repo.delete(id);
    _refresh();
  }

  void _openDetail(SavedLesson lesson) {
    final selectedWords = lesson.words
        .map((w) => SelectedWord(
              word: w.word,
              level: w.level,
              category: w.category,
              pos: w.pos,
              definition: w.definition,
              example: w.example,
              phoneticText: w.phoneticText,
              phoneticAmText: w.phoneticAmText,
            ))
        .toList();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AiLessonDetailScreen(
              title: lesson.title,
              passage: lesson.passage,
              selectedWords: selectedWords,
            ),
          ),
        )
        .then((_) => _refresh());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BasePage(
        title: L10n.tr(context, 'ai_lessons'),
        child: FutureBuilder<List<SavedLesson>>(
          future: _lessonsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final lessons = snapshot.data ?? [];

            if (lessons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.smart_toy_outlined,
                        size: 80, color: colorScheme.primary.withAlpha(80)),
                    const SizedBox(height: 16),
                    Text(
                      L10n.tr(context, 'no_ai_lessons'),
                      style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(120)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.tr(context, 'create_lesson_desc'),
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  return _LessonCard(
                    lesson: lesson,
                    onTap: () => _openDetail(lesson),
                    onDelete: () => _deleteLesson(lesson.id),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                    builder: (_) => const NewAiLessonScreen()),
              )
              .then((_) => _refresh());
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final SavedLesson lesson;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _LessonCard({
    required this.lesson,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      lesson.title,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        size: 20, color: Colors.grey[400]),
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                lesson.passagePreview,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withAlpha(180),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.menu_book_rounded,
                            size: 14, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.wordCount} words',
                          style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface.withAlpha(180)),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: Colors.grey[400]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
