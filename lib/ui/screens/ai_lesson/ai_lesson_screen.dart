import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/ai_repository.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import 'category_words_screen.dart';
import 'new_ai_lesson_screen.dart';
import '../../../utils/l10n.dart';

class AiLessonScreen extends StatefulWidget {
  const AiLessonScreen({super.key});

  @override
  State<AiLessonScreen> createState() => _AiLessonScreenState();
}

class _AiLessonScreenState extends State<AiLessonScreen> {
  late Future<List<Map<String, dynamic>>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = GetIt.instance<AiRepository>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BasePage(
      title: L10n.tr(context, 'ai_lessons'),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load categories', style: TextStyle(color: colorScheme.error)),
                  );
                }
                final categories = snapshot.data ?? [];
                if (categories.isEmpty) {
                  return Center(
                    child: Text(L10n.tr(context, 'no_ai_lessons')),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    final String categoryName = item['category'] ?? '';
                    final int count = item['count'] ?? 0;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.category_rounded, color: colorScheme.primary),
                        ),
                        title: Text(
                          categoryName.toUpperCase(),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text('$count words', style: textTheme.bodySmall),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CategoryWordsScreen(
                                categoryId: categoryName,
                                categoryTitle: categoryName.toUpperCase(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: RoundedButton(
              borderRadius: 16,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewAiLessonScreen()),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: colorScheme.onPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    L10n.tr(context, 'new_lesson'),
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
