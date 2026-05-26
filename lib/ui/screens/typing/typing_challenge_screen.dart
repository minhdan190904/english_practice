import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/word.dart';
import '../../../utils/l10n.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../../screens/settings/bloc/settings_bloc.dart';
import 'widgets/hint_display.dart';
import 'widgets/star_rating.dart';
import 'widgets/typing_result_screen.dart';

class TypingChallengeScreen extends StatefulWidget {
  final List<Word> words;
  final String? title;

  const TypingChallengeScreen({
    super.key,
    required this.words,
    this.title,
  });

  @override
  State<TypingChallengeScreen> createState() => _TypingChallengeScreenState();
}

class _TypingChallengeScreenState extends State<TypingChallengeScreen>
    with SingleTickerProviderStateMixin {
  late final List<Word> _words;
  int _currentIndex = 0;
  int _hintLevel = 0;
  int _maxStars = 3;
  int _earnedStars = 0;
  int _attempt = 0;
  bool? _isCorrect;
  bool _isShaking = false;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<TypingResult> _results = [];

  // Shake animation
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  Word get _currentWord => _words[_currentIndex];
  String get _answer => _currentWord.word.toLowerCase().trim();

  @override
  void initState() {
    super.initState();
    _words = List.from(widget.words)..shuffle();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset();
        if (mounted) setState(() => _isShaking = false);
      }
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _getDefinition() {
    final locale =
        context.read<SettingsBloc>().state.settingsSnapshot.locale;
    if (_currentWord.senses.isEmpty) return '';
    final sense = _currentWord.senses.first;
    if (locale == 'vi' && sense.definitionVi.isNotEmpty) {
      return sense.definitionVi;
    }
    return sense.definition;
  }

  String _getShortMeaning() {
    if (_currentWord.senses.isEmpty) return '';
    return _currentWord.senses.first.shortMeaningVi;
  }

  void _onHintPressed() {
    if (_hintLevel >= 3) return;
    setState(() {
      _hintLevel++;
      _maxStars = max(0, 3 - _hintLevel);
      if (_hintLevel >= 3) {
        // Reveal full word — auto skip with 0 stars
        _recordResult(false, 0);
        _advanceAfterDelay(1500);
      }
    });
  }

  void _onSkipPressed() {
    setState(() {
      _isCorrect = false;
      _earnedStars = 0;
    });
    _recordResult(false, 0);
    _advanceAfterDelay(1200);
  }

  void _onSubmitted(String value) {
    final input = value.toLowerCase().trim();
    if (input.isEmpty) return;

    if (input == _answer) {
      // Correct!
      final stars = _attempt == 0 ? _maxStars : max(0, _maxStars - 1);
      setState(() {
        _isCorrect = true;
        _earnedStars = stars;
      });
      HapticFeedback.mediumImpact();
      _recordResult(true, stars);
      _advanceAfterDelay(1200);
    } else {
      // Wrong
      _attempt++;
      if (_attempt >= 2) {
        // Second attempt failed — show correct answer
        setState(() {
          _isCorrect = false;
          _earnedStars = 0;
        });
        _recordResult(false, 0);
        _advanceAfterDelay(1500);
      } else {
        // First attempt failed — let retry
        setState(() => _isShaking = true);
        _shakeController.forward();
        HapticFeedback.heavyImpact();
        _textController.clear();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) _focusNode.requestFocus();
        });
      }
    }
  }

  void _recordResult(bool correct, int stars) {
    _results.add(TypingResult(
      word: _currentWord,
      correct: correct,
      stars: stars,
    ));
    context.read<VocabularyBloc>().add(
      VocabularyEvent.recordSrsReview(
        wordIndex: _currentWord.index,
        correct: correct,
      ),
    );
  }

  void _advanceAfterDelay(int ms) {
    Future.delayed(Duration(milliseconds: ms), () {
      if (!mounted) return;
      if (_currentIndex >= _words.length - 1) {
        // All done — show results
        _showResults();
      } else {
        setState(() {
          _currentIndex++;
          _hintLevel = 0;
          _maxStars = 3;
          _earnedStars = 0;
          _attempt = 0;
          _isCorrect = null;
          _isShaking = false;
          _textController.clear();
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) _focusNode.requestFocus();
        });
      }
    });
  }

  void _showResults() {
    final totalStars = _results.fold<int>(0, (sum, r) => sum + r.stars);
    final correctCount = _results.where((r) => r.correct).length;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TypingResultScreen(
          total: _words.length,
          totalStars: totalStars,
          maxPossibleStars: _words.length * 3,
          correctCount: correctCount,
          results: _results,
          onPracticeAgain: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => TypingChallengeScreen(
                  words: widget.words,
                  title: widget.title,
                ),
              ),
            );
          },
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final progress = ((_currentIndex + 1) / _words.length).clamp(0.0, 1.0);
    final bgColor = colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title ?? '⌨️ Typing Challenge',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Progress bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentIndex + 1} / ${_words.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Main card ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  final dx = _isShaking
                      ? sin(_shakeAnimation.value * pi * 6) * 10
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(dx, 0),
                    child: child,
                  );
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.3, 0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: _buildCard(context, colorScheme, textTheme),
                ),
              ),
            ),
          ),

          // ── Bottom buttons ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                // Hint button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCorrect != null ? null : _onHintPressed,
                    icon: const Icon(Icons.lightbulb_outline,
                        color: Colors.white, size: 20),
                    label: Text(
                      '${L10n.tr(context, 'hint')} (${3 - _hintLevel})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Skip button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCorrect != null ? null : _onSkipPressed,
                    icon: const Icon(Icons.skip_next,
                        color: Colors.white, size: 20),
                    label: Text(
                      L10n.tr(context, 'skip'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final definition = _getDefinition();
    final shortMeaning = _getShortMeaning();
    final locale =
        context.read<SettingsBloc>().state.settingsSnapshot.locale;

    Color cardBg = Colors.white;
    if (_isCorrect == true) cardBg = const Color(0xFFE8F5E9);
    if (_isCorrect == false) cardBg = const Color(0xFFFFEBEE);

    return AnimatedContainer(
      key: ValueKey(_currentIndex),
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // POS badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _currentWord.pos.isNotEmpty ? _currentWord.pos : '—',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Definition
          Text(
            definition,
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.black87,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Vietnamese meaning (if vi locale)
          if (locale == 'vi' && shortMeaning.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '🇻🇳 $shortMeaning',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],

          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 20),

          // Hint display
          HintDisplay(word: _answer, hintLevel: _hintLevel),

          const SizedBox(height: 20),

          // Text input
          if (_isCorrect == null)
            SizedBox(
              width: min(_answer.length * 28.0 + 40, 320),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                autofocus: true,
                textAlign: TextAlign.center,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                enableSuggestions: false,
                style: textTheme.headlineSmall?.copyWith(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: _attempt > 0 ? Colors.red : Colors.black87,
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(_answer.length),
                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z'-]")),
                ],
                decoration: InputDecoration(
                  hintText: '...',
                  hintStyle: TextStyle(color: Colors.grey.shade300),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                ),
                onSubmitted: _onSubmitted,
              ),
            ),

          // Correct/wrong feedback
          if (_isCorrect == true) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                Text(
                  _currentWord.word,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
          if (_isCorrect == false) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.close, color: Colors.red, size: 28),
                const SizedBox(width: 8),
                Text(
                  _currentWord.word,
                  style: textTheme.headlineSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),

          // Star rating
          StarRating(maxStars: 3, earnedStars: _earnedStars),
        ],
      ),
    );
  }
}
