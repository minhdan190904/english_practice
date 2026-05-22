import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../commons/base_page.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';

class CategoryWordsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const CategoryWordsScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  @override
  State<CategoryWordsScreen> createState() => _CategoryWordsScreenState();
}

class _CategoryWordsScreenState extends State<CategoryWordsScreen> {
  late Future<List<Word>> _wordsFuture;
  List<Word> _words = [];

  @override
  void initState() {
    super.initState();
    final vocabularyBloc = context.read<VocabularyBloc>();
    _wordsFuture = GetIt.instance<AiRepository>().getCategoryWords(widget.categoryId).then((words) {
      // Sync status from local VocabularyBloc if any
      final localWords = vocabularyBloc.state.words;
      final localWordsMap = {for (var w in localWords) w.word: w.status};
      
      if (mounted) {
        setState(() {
          _words = words.map((w) {
            if (localWordsMap.containsKey(w.word)) {
              return w.copyWith(status: localWordsMap[w.word]!);
            }
            return w;
          }).toList();
        });
      }
      return words;
    });
  }

  void _onWordStatusChanged(int index, WordStatus newStatus) {
    setState(() {
      _words[index] = _words[index].copyWith(status: newStatus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.categoryTitle,
      child: FutureBuilder<List<Word>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load words'));
          }
          if (_words.isEmpty) {
            return const Center(child: Text('No words found in this category.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: _words.length,
            itemBuilder: (context, index) {
              final word = _words[index];
              return VocabularyItem(
                word: word,
                viewOnly: false,
                onMastered: () {
                  final newStatus = word.status == WordStatus.mastered ? WordStatus.unknown : WordStatus.mastered;
                  _onWordStatusChanged(index, newStatus);
                },
                onStar: () {
                  final newStatus = word.status == WordStatus.star ? WordStatus.unknown : WordStatus.star;
                  _onWordStatusChanged(index, newStatus);
                },
              );
            },
          );
        },
      ),
    );
  }
}
