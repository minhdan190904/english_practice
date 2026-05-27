import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../configs/di.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widgets/practice_completion_screen.dart';

// ─── Practice Question Model ─────────────────────────────────────────────────

enum PracticeQuestionType {
  definitionMultipleChoice, // Show definition → pick word from 4
  definitionTyping, // Show definition → type word
  audioMultipleChoice, // Play audio → pick word from 4
}

class PracticeQuestion {
  final Word correctWord;
  final PracticeQuestionType type;
  final List<String> options; // 4 shuffled options (for MC types)
  final String correctAnswer; // the word text
  final String? exampleWithBlank; // example sentence with word replaced by _____
  final String? definition; // definition text to show
  final String? definitionVi; // Vietnamese definition
  final String? shortMeaningVi; // Short Vietnamese meaning

  PracticeQuestion({
    required this.correctWord,
    required this.type,
    required this.options,
    required this.correctAnswer,
    this.exampleWithBlank,
    this.definition,
    this.definitionVi,
    this.shortMeaningVi,
  });
}

// ─── Practice Screen ─────────────────────────────────────────────────────────

class PracticeScreen extends StatefulWidget {
  final List<Word> words;
  final String? title;

  const PracticeScreen({
    super.key,
    required this.words,
    this.title,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen>
    with SingleTickerProviderStateMixin {
  late List<Word> _pool;
  late List<Word> _allWords;
  PracticeQuestion? _currentQuestion;
  bool _answered = false;
  String? _selectedAnswer;
  bool? _isCorrect;
  int _wordPointer = 0;
  bool _isInit = false;
  bool _showCompletion = false;

  final TextEditingController _typingController = TextEditingController();
  final FocusNode _typingFocusNode = FocusNode();

  // Track which question types each word has seen (by word index)
  final Map<int, Set<PracticeQuestionType>> _questionHistory = {};

  // Audio player
  final AudioPlayer _player = DI().sl<AudioPlayer>();
  static final Map<String, LockCachingAudioSource> _audioCache = {};

  final _rng = Random();

  // Animation
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Filter out already-mastered words from pool
    _pool = widget.words
        .where((w) => w.status != WordStatus.mastered)
        .toList();
    _pool.shuffle(_rng);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _allWords = context.read<VocabularyBloc>().state.words;
      if (_allWords.isEmpty) {
        _allWords = List<Word>.from(widget.words);
      }
      _generateNextQuestion();
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _typingController.dispose();
    _typingFocusNode.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // ─── Audio ───────────────────────────────────────────────────────────────

  void _playAudio(String url) async {
    if (url.isEmpty) return;
    try {
      if (!_audioCache.containsKey(url)) {
        _audioCache[url] = LockCachingAudioSource(Uri.parse(url));
      }
      await _player.setAudioSource(_audioCache[url]!);
      await _player.play();
    } catch (_) {}
  }

  String _getAudioUrl(Word word) {
    // Prefer UK, fallback to US
    if (word.phonetic.isNotEmpty) return word.phonetic;
    if (word.phoneticAm.isNotEmpty) return word.phoneticAm;
    return '';
  }

  // ─── Question Generation ─────────────────────────────────────────────────

  void _generateNextQuestion() {
    if (_pool.isEmpty) {
      if (mounted) {
        setState(() {
          _showCompletion = true;
          _currentQuestion = null;
        });
      }
      return;
    }

    // Rotate through pool
    if (_wordPointer >= _pool.length) _wordPointer = 0;
    final word = _pool[_wordPointer];
    _wordPointer = (_wordPointer + 1) % max(1, _pool.length);

    // Pick a question type this word hasn't seen yet
    final seen = _questionHistory[word.index] ?? <PracticeQuestionType>{};
    final available = PracticeQuestionType.values
        .where((t) => !seen.contains(t))
        .toList();

    PracticeQuestionType type;
    if (available.isEmpty) {
      // Reset history for this word
      _questionHistory[word.index] = <PracticeQuestionType>{};
      type = PracticeQuestionType.values[_rng.nextInt(PracticeQuestionType.values.length)];
    } else {
      type = available[_rng.nextInt(available.length)];
    }

    // For audio type, check if word has audio; if not, fallback to definition MC
    if (type == PracticeQuestionType.audioMultipleChoice &&
        _getAudioUrl(word).isEmpty) {
      type = PracticeQuestionType.definitionMultipleChoice;
    }

    // Record usage
    _questionHistory.putIfAbsent(word.index, () => <PracticeQuestionType>{});
    _questionHistory[word.index]!.add(type);

    // Build question
    final question = _buildQuestion(word, type);

    _slideController.reset();
    _slideController.forward();

    if (mounted) {
      setState(() {
        _currentQuestion = question;
        _answered = false;
        _selectedAnswer = null;
        _isCorrect = null;
        _typingController.clear();
      });
    }

    // Auto-play audio for audio questions
    if (type == PracticeQuestionType.audioMultipleChoice) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) _playAudio(_getAudioUrl(word));
      });
    }
  }

  PracticeQuestion _buildQuestion(Word word, PracticeQuestionType type) {
    // Get distractors: same POS
    final samePos = _allWords
        .where((w) =>
            w.word != word.word &&
            w.senses.isNotEmpty &&
            _posMatches(w.pos, word.pos))
        .toList()
      ..shuffle(_rng);

    final distractors = samePos.take(3).toList();

    // Pad with any words if not enough same-POS
    if (distractors.length < 3) {
      final others = _allWords
          .where((w) =>
              w.word != word.word &&
              w.senses.isNotEmpty &&
              !distractors.contains(w))
          .toList()
        ..shuffle(_rng);
      distractors.addAll(others.take(3 - distractors.length));
    }

    final correctAnswer = word.word;
    final options = <String>[
      correctAnswer,
      ...distractors.take(3).map((w) => w.word),
    ]..shuffle(_rng);

    // Definition & example
    String? definition;
    String? definitionVi;
    String? shortMeaningVi;
    String? exampleWithBlank;

    if (word.senses.isNotEmpty) {
      final sense = word.senses.first;
      definition = sense.definition;
      definitionVi = sense.definitionVi;
      shortMeaningVi = sense.shortMeaningVi;

      // Find an example and create a blank
      for (final s in word.senses) {
        for (final ex in s.examples) {
          if (ex.x.isNotEmpty) {
            exampleWithBlank = _createBlank(ex.x, word.word);
            if (exampleWithBlank != ex.x) break; // Replacement succeeded
          }
        }
        if (exampleWithBlank != null &&
            exampleWithBlank.contains('_____')) {
          break;
        }
      }
    }

    return PracticeQuestion(
      correctWord: word,
      type: type,
      options: options,
      correctAnswer: correctAnswer,
      exampleWithBlank: exampleWithBlank,
      definition: definition,
      definitionVi: definitionVi,
      shortMeaningVi: shortMeaningVi,
    );
  }

  bool _posMatches(String pos1, String pos2) {
    if (pos1.isEmpty || pos2.isEmpty) return false;
    final set1 = pos1.toLowerCase().split(RegExp(r'[,/\s]+')).toSet();
    final set2 = pos2.toLowerCase().split(RegExp(r'[,/\s]+')).toSet();
    return set1.intersection(set2).isNotEmpty;
  }

  String _createBlank(String sentence, String word) {
    // Try exact word first, then common variations
    final escaped = RegExp.escape(word);
    // Match word and common suffixes (ing, ed, s, es, er, est, ly, tion, etc.)
    final pattern = RegExp(
      '\\b$escaped(?:ing|ed|s|es|er|est|ly|tion|ment|ness|ful|less|able|ible)?\\b',
      caseSensitive: false,
    );
    final result = sentence.replaceAll(pattern, '_____');
    if (result != sentence) return result;

    // Fallback: simple case-insensitive replace
    return sentence.replaceAll(
      RegExp(escaped, caseSensitive: false),
      '_____',
    );
  }

  // ─── Answer Handling ─────────────────────────────────────────────────────

  void _onMCAnswer(String answer) {
    if (_answered) return;
    final isCorrect =
        answer.toLowerCase() == _currentQuestion!.correctAnswer.toLowerCase();
    HapticFeedback.mediumImpact();

    setState(() {
      _answered = true;
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });

    // Record SRS review
    context.read<VocabularyBloc>().add(
          VocabularyEvent.recordSrsReview(
            wordIndex: _currentQuestion!.correctWord.index,
            correct: isCorrect,
          ),
        );
  }

  void _onTypingSubmit(String value) {
    if (_answered) return;
    final input = value.trim();
    if (input.isEmpty) return;

    final isCorrect = input.toLowerCase() ==
        _currentQuestion!.correctAnswer.toLowerCase();
    HapticFeedback.mediumImpact();

    setState(() {
      _answered = true;
      _selectedAnswer = input;
      _isCorrect = isCorrect;
    });

    context.read<VocabularyBloc>().add(
          VocabularyEvent.recordSrsReview(
            wordIndex: _currentQuestion!.correctWord.index,
            correct: isCorrect,
          ),
        );
  }

  void _onNext() {
    // If wrong, word stays in pool for later
    // If correct, word stays in pool too (user must explicitly master it)
    _generateNextQuestion();

    // Request focus for typing questions
    if (_currentQuestion?.type == PracticeQuestionType.definitionTyping) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) _typingFocusNode.requestFocus();
      });
    }
  }

  void _onMastered() {
    if (_currentQuestion == null) return;
    final word = _currentQuestion!.correctWord;

    // Remove from pool
    _pool.removeWhere((w) => w.word == word.word);
    if (_wordPointer > 0) _wordPointer--;

    // Dispatch status change
    context.read<VocabularyBloc>().add(
          VocabularyEvent.changeStatus(word, WordStatus.mastered),
        );

    HapticFeedback.lightImpact();
    _generateNextQuestion();
  }

  // ─── Build UI ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_showCompletion) {
      return const PracticeCompletionScreen();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_currentQuestion == null || _pool.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: const Center(
          child: Text('Không đủ từ vựng để luyện tập.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme, textTheme),
      body: Column(
        children: [
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _slideController,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuestionCard(colorScheme, textTheme),
                      const SizedBox(height: 20),
                      _buildAnswerArea(colorScheme, textTheme),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_answered) _buildFeedbackBar(colorScheme, textTheme),
          _buildMasteryButton(colorScheme, textTheme),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      ColorScheme colorScheme, TextTheme textTheme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      title: Text(
        widget.title ?? 'Practice',
        style: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.library_books_outlined,
                  size: 16, color: colorScheme.onPrimaryContainer),
              const SizedBox(width: 4),
              Text(
                'Còn ${_pool.length} từ',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Question Card ───────────────────────────────────────────────────────

  Widget _buildQuestionCard(ColorScheme colorScheme, TextTheme textTheme) {
    final q = _currentQuestion!;
    return Container(
      key: ValueKey('${q.correctWord.index}_${q.type.index}'),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withAlpha(80),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionTypeHeader(q.type, colorScheme, textTheme),
          const SizedBox(height: 16),
          _buildQuestionContent(q, colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeHeader(
      PracticeQuestionType type, ColorScheme colorScheme, TextTheme textTheme) {
    final (icon, label, gradient) = switch (type) {
      PracticeQuestionType.definitionMultipleChoice => (
          Icons.menu_book_rounded,
          'Nghĩa → Từ',
          [colorScheme.primary, colorScheme.primary.withAlpha(180)],
        ),
      PracticeQuestionType.definitionTyping => (
          Icons.keyboard_rounded,
          'Nghĩa → Gõ từ',
          [Colors.teal, Colors.teal.withAlpha(180)],
        ),
      PracticeQuestionType.audioMultipleChoice => (
          Icons.headphones_rounded,
          'Nghe → Chọn từ',
          [Colors.deepPurple, Colors.deepPurple.withAlpha(180)],
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(
      PracticeQuestion q, ColorScheme colorScheme, TextTheme textTheme) {
    switch (q.type) {
      case PracticeQuestionType.definitionMultipleChoice:
      case PracticeQuestionType.definitionTyping:
        return _buildDefinitionContent(q, colorScheme, textTheme);
      case PracticeQuestionType.audioMultipleChoice:
        return _buildAudioContent(q, colorScheme, textTheme);
    }
  }

  Widget _buildDefinitionContent(
      PracticeQuestion q, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // POS badge
        if (q.correctWord.pos.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withAlpha(120),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              q.correctWord.pos,
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),

        // Definition
        if (q.definition?.isNotEmpty == true)
          Text(
            q.definition!,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withAlpha(200),
              height: 1.5,
            ),
          ),

        // Vietnamese definition
        if (q.shortMeaningVi?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '🇻🇳 ${q.shortMeaningVi}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ] else if (q.definitionVi?.isNotEmpty == true) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '🇻🇳 ${q.definitionVi}',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],

        // Example with blank
        if (q.exampleWithBlank?.isNotEmpty == true &&
            q.exampleWithBlank!.contains('_____')) ...[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withAlpha(30)),
            ),
            child: _buildExampleWithBlank(
                q.exampleWithBlank!, colorScheme, textTheme),
          ),
        ],
      ],
    );
  }

  Widget _buildExampleWithBlank(
      String text, ColorScheme colorScheme, TextTheme textTheme) {
    final parts = text.split('_____');
    final spans = <InlineSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: textTheme.bodyMedium?.copyWith(
            fontStyle: FontStyle.italic,
            color: colorScheme.onSurface.withAlpha(160),
            height: 1.5,
          ),
        ));
      }
      if (i < parts.length - 1) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(6),
              border: Border(
                bottom: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
            child: Text(
              '  ?  ',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
        ));
      }
    }
    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildAudioContent(
      PracticeQuestion q, ColorScheme colorScheme, TextTheme textTheme) {
    final audioUrl = _getAudioUrl(q.correctWord);
    return Column(
      children: [
        const SizedBox(height: 8),
        // Large audio play button
        Center(
          child: GestureDetector(
            onTap: () => _playAudio(audioUrl),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withAlpha(60),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.volume_up_rounded,
                  color: Colors.white, size: 44),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Nghe và chọn từ đúng',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withAlpha(140),
          ),
        ),
        const SizedBox(height: 8),
        // Replay button
        TextButton.icon(
          onPressed: () => _playAudio(audioUrl),
          icon: const Icon(Icons.replay_rounded, size: 18),
          label: const Text('Nghe lại'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
        ),
        // Phonetic text hint
        if (q.correctWord.phoneticText.isNotEmpty && _answered)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '/${q.correctWord.phoneticText}/',
              style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurface.withAlpha(120),
              ),
            ),
          ),
      ],
    );
  }

  // ─── Answer Area ─────────────────────────────────────────────────────────

  Widget _buildAnswerArea(ColorScheme colorScheme, TextTheme textTheme) {
    final q = _currentQuestion!;
    if (q.type == PracticeQuestionType.definitionTyping) {
      return _buildTypingAnswer(colorScheme, textTheme);
    }
    return _buildMCAnswer(q.options, colorScheme, textTheme);
  }

  Widget _buildMCAnswer(
      List<String> options, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: options.map((option) {
        final isSelected = _selectedAnswer == option;
        final isCorrectOption =
            option.toLowerCase() == _currentQuestion!.correctAnswer.toLowerCase();

        Color bgColor = colorScheme.surface;
        Color borderColor = colorScheme.outlineVariant;
        Color textColor = colorScheme.onSurface;
        IconData? trailingIcon;

        if (_answered) {
          if (isCorrectOption) {
            bgColor = Colors.green.withAlpha(20);
            borderColor = Colors.green;
            textColor = Colors.green.shade800;
            trailingIcon = Icons.check_circle;
          } else if (isSelected && !isCorrectOption) {
            bgColor = Colors.red.withAlpha(20);
            borderColor = Colors.red;
            textColor = Colors.red.shade800;
            trailingIcon = Icons.cancel;
          }
        } else if (isSelected) {
          bgColor = colorScheme.primary.withAlpha(15);
          borderColor = colorScheme.primary;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _answered ? null : () => _onMCAnswer(option),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: textTheme.bodyLarge?.copyWith(
                          color: textColor,
                          fontWeight: isSelected || (_answered && isCorrectOption)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (trailingIcon != null)
                      Icon(
                        trailingIcon,
                        color:
                            isCorrectOption ? Colors.green : Colors.red,
                        size: 22,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypingAnswer(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        TextField(
          controller: _typingController,
          focusNode: _typingFocusNode,
          enabled: !_answered,
          autofocus: true,
          textCapitalization: TextCapitalization.none,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.done,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
          decoration: InputDecoration(
            hintText: 'Gõ từ vựng ở đây...',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: _isCorrect == true ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            suffixIcon: !_answered
                ? IconButton(
                    icon: Icon(Icons.send_rounded,
                        color: colorScheme.primary),
                    onPressed: () => _onTypingSubmit(_typingController.text),
                  )
                : Icon(
                    _isCorrect == true ? Icons.check_circle : Icons.cancel,
                    color: _isCorrect == true ? Colors.green : Colors.red,
                  ),
          ),
          onSubmitted: _onTypingSubmit,
        ),
        // Show correct answer if wrong
        if (_answered && _isCorrect == false) ...[
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withAlpha(60)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Đáp án: ',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade700,
                          ),
                        ),
                        TextSpan(
                          text: _currentQuestion!.correctAnswer,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─── Feedback Bar ────────────────────────────────────────────────────────

  Widget _buildFeedbackBar(ColorScheme colorScheme, TextTheme textTheme) {
    final isCorrect = _isCorrect == true;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isCorrect ? Colors.green.withAlpha(20) : Colors.red.withAlpha(20),
        border: Border(
          top: BorderSide(
            color: isCorrect
                ? Colors.green.withAlpha(60)
                : Colors.red.withAlpha(60),
            width: 1,
          ),
        ),
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
                isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng',
                style: textTheme.titleSmall?.copyWith(
                  color: isCorrect ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isCorrect &&
                  _currentQuestion!.type !=
                      PracticeQuestionType.definitionTyping) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _currentQuestion!.correctAnswer,
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.green.shade700,
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
                backgroundColor:
                    isCorrect ? Colors.green : colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _onNext,
              child: const Text(
                'Tiếp theo →',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Mastery Button ──────────────────────────────────────────────────────

  Widget _buildMasteryButton(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withAlpha(40),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: TextButton.icon(
          onPressed: _onMastered,
          icon: const Icon(Icons.keyboard_double_arrow_right_rounded, size: 20),
          label: const Text('Đã biết, loại khỏi danh sách ôn tập'),
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary.withValues(alpha: 0.8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
