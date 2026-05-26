import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/di.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../utils/achievement_checker.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widgets/quiz_question_card.dart';
import 'widgets/quiz_result_screen.dart';

/// Quiz session data
class QuizQuestion {
  final Word word;
  final QuizType type;
  final List<String> options; // 4 choices
  final String correctAnswer;

  QuizQuestion({
    required this.word,
    required this.type,
    required this.options,
    required this.correctAnswer,
  });
}

enum QuizType { meaning, word, fillIn, listening }

class QuizScreen extends StatefulWidget {
  final List<Word> studyWords;
  static const int questionsPerSession = 10;

  const QuizScreen({super.key, required this.studyWords});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<QuizQuestion> _questions = [];
  int _current = 0;
  int _correct = 0;
  final List<bool> _results = [];
  bool _answered = false;
  String? _selectedAnswer;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _buildQuestions();
      _isInit = true;
    }
  }

  void _buildQuestions() {
    final allWords = context.read<VocabularyBloc>().state.words;
    if (allWords.isEmpty || widget.studyWords.isEmpty) {
      setState(() {
        _questions = [];
      });
      return;
    }
    
    final rng = Random();

    // Pool: 70% starred, 30% random from all
    final pool = <Word>{...widget.studyWords};
    final extras = allWords.where((w) => w.status != WordStatus.mastered && !pool.contains(w)).toList()..shuffle(rng);
    pool.addAll(extras.take(max(0, QuizScreen.questionsPerSession - pool.length)));
    final wordList = pool.toList()..shuffle(rng);
    final selected = wordList.take(QuizScreen.questionsPerSession).toList();

    _questions = [];
    for (int i = 0; i < selected.length; i++) {
      final word = selected[i];
      final typeIndex = i % 3;
      final type = [QuizType.meaning, QuizType.word, QuizType.fillIn][typeIndex];
      _questions.add(_buildQuestion(word, type, allWords));
    }
    setState(() {});
  }

  QuizQuestion _buildQuestion(Word word, QuizType type, List<Word> allWords) {
    final rng = Random();

    // Get distractors: same POS, different word
    final samePos = allWords
        .where((w) => w.pos == word.pos && w.word != word.word && w.senses.isNotEmpty)
        .toList()
      ..shuffle(rng);
    final distractors = samePos.take(3).toList();
    // Pad with any words if not enough same-POS
    if (distractors.length < 3) {
      final others = allWords.where((w) => w.word != word.word && w.senses.isNotEmpty && !distractors.contains(w)).toList()..shuffle(rng);
      distractors.addAll(others.take(3 - distractors.length));
    }

    switch (type) {
      case QuizType.meaning:
        // Show word → pick correct meaning
        final correct = word.senses.isNotEmpty ? word.senses.first.definition : word.word;
        final wrongOptions = distractors.map((w) => w.senses.isNotEmpty ? w.senses.first.definition : w.word).toList();
        final options = [correct, ...wrongOptions.take(3)]..shuffle(rng);
        return QuizQuestion(word: word, type: type, options: options, correctAnswer: correct);

      case QuizType.word:
        // Show meaning → pick correct word
        final correct = word.word;
        final wrongOptions = distractors.map((w) => w.word).toList();
        final options = [correct, ...wrongOptions.take(3)]..shuffle(rng);
        return QuizQuestion(word: word, type: type, options: options, correctAnswer: correct);

      case QuizType.fillIn:
        // Show sentence with blank → pick correct word
        final correct = word.word;
        final example = word.senses.isNotEmpty && word.senses.first.examples.isNotEmpty
            ? word.senses.first.examples.first.x
            : 'She tried to ___ the situation.';
        final wrongOptions = distractors.map((w) => w.word).toList();
        final options = [correct, ...wrongOptions.take(3)]..shuffle(rng);
        // Replace word in example with blank
        final sentence = example.replaceAll(RegExp(word.word, caseSensitive: false), '______');
        return QuizQuestion(
          word: word.copyWith(userDefinition: sentence), // abuse userDefinition to store sentence
          type: type,
          options: options,
          correctAnswer: correct,
        );

      case QuizType.listening:
        final correct = word.word;
        final wrongOptions = distractors.map((w) => w.word).toList();
        final options = [correct, ...wrongOptions.take(3)]..shuffle(rng);
        return QuizQuestion(word: word, type: type, options: options, correctAnswer: correct);
    }
  }

  void _onAnswer(String answer) {
    if (_answered) return;
    final isCorrect = answer == _questions[_current].correctAnswer;
    final currentWord = _questions[_current].word;
    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      if (isCorrect) _correct++;
      _results.add(isCorrect);
    });
    context.read<VocabularyBloc>().add(
      VocabularyEvent.recordSrsReview(
        wordIndex: currentWord.index,
        correct: isCorrect,
      ),
    );
  }

  void _onNext() {
    if (_current >= _questions.length - 1) {
      // Check for perfect quiz achievement
      if (_correct == _questions.length && _questions.length >= 5) {
        final achievementChecker = DI().sl<AchievementChecker>();
        achievementChecker.checkPerfectQuiz();
      }
      // Show result
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            total: _questions.length,
            correct: _correct,
            questions: _questions,
            results: _results,
          ),
        ),
      );
      return;
    }
    setState(() {
      _current++;
      _answered = false;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('Not enough words to quiz. Star some words first!')),
      );
    }
    final colorScheme = Theme.of(context).colorScheme;
    final q = _questions[_current];
    final progress = (_current + 1) / _questions.length;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${_current + 1}/${_questions.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_correct',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: QuizQuestionCard(
                key: ValueKey(_current),
                question: q,
                selectedAnswer: _selectedAnswer,
                answered: _answered,
                onAnswer: _onAnswer,
              ),
            ),
          ),
          if (_answered)
            _buildNextButton(colorScheme),
        ],
      ),
    );
  }

  Widget _buildNextButton(ColorScheme colorScheme) {
    final isCorrect = _selectedAnswer == _questions[_current].correctAnswer;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        border: Border(top: BorderSide(
          color: isCorrect ? Colors.green.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3),
          width: 1,
        )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct! 🎉' : 'Correct answer:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isCorrect ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (!isCorrect) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _questions[_current].correctAnswer,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isCorrect ? Colors.green : colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _onNext,
              child: Text(
                _current >= _questions.length - 1 ? 'See Results 🏆' : 'Next →',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
