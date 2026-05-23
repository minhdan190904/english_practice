import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../navigation/app_router.dart';
import '../../../utils/global_values.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widgets/flashcard_app_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  FlashCard Screen
// ─────────────────────────────────────────────────────────────────────────────
class FlashCardScreen extends StatefulWidget {
  final List<Word> words;
  final String? title;

  const FlashCardScreen({super.key, required this.words, this.title});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  // ── word list state ──────────────────────────────────────────────────────
  late List<Word> _remainingWords;
  late List<Word> _dontKnowWords;
  int _currentIndex = 0;
  int _totalWords = 0;

  // ── flip animation ───────────────────────────────────────────────────────
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFrontVisible = true; // tracks which face is showing
  bool _isAnimating = false;

  bool get _isFlipped => !_isFrontVisible;

  @override
  void initState() {
    super.initState();
    _remainingWords = List.from(widget.words);
    _dontKnowWords = [];
    _totalWords = widget.words.length;

    // AnimationController drives 0.0 → 1.0 (= 0° → 180°)
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );

    // Swap the visible face exactly at the halfway point (card is edge-on)
    _flipController.addListener(() {
      final val = _flipController.value;
      if (val >= 0.5 && _isFrontVisible) {
        setState(() => _isFrontVisible = false);
      } else if (val < 0.5 && !_isFrontVisible) {
        setState(() => _isFrontVisible = true);
      }
    });

    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _isAnimating = false;
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────
  int get _completedCount => _totalWords - _remainingWords.length;
  double get _progress =>
      _totalWords == 0 ? 0 : (_completedCount / _totalWords);
  Word get _currentWord => _remainingWords[_currentIndex];

  void _flipCard() {
    if (_isAnimating) return;
    _isAnimating = true;
    if (_flipController.isDismissed) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  /// Reset card to front face (for moving to next word)
  void _resetToFront({bool animate = false}) {
    if (animate) {
      if (!_flipController.isDismissed) _flipController.reverse();
    } else {
      _flipController.reset();
      setState(() => _isFrontVisible = true);
    }
  }

  void _onNext() {
    if (_currentIndex < _remainingWords.length - 1) {
      _resetToFront();
      setState(() => _currentIndex++);
    }
  }

  void _onIKnow() {
    if (!_isFlipped) {
      _flipCard();
      return;
    }
    context.read<VocabularyBloc>().add(
          VocabularyEvent.changeStatus(_currentWord, WordStatus.mastered),
        );
    _resetToFront();
    setState(() {
      _remainingWords.removeAt(_currentIndex);
      if (_remainingWords.isEmpty) {
        _onAllDone();
        return;
      }
      if (_currentIndex >= _remainingWords.length) {
        _currentIndex = _remainingWords.length - 1;
      }
    });
  }

  void _onDontKnow() {
    if (!_isFlipped) {
      _flipCard();
      return;
    }
    _resetToFront();
    setState(() {
      final word = _remainingWords.removeAt(_currentIndex);
      _dontKnowWords.add(word);
      _remainingWords.add(word); // re-queue at end
      if (_currentIndex >= _remainingWords.length) {
        _currentIndex = _remainingWords.length - 1;
      }
    });
  }

  void _onAllDone() {
    if (!GlobalValues.isShowInAppReview) {
      InAppReview.instance.requestReview();
      GlobalValues.isShowInAppReview = true;
    } else if (!GlobalValues.isShowFlashCardAppDialog) {
      GlobalValues.isShowFlashCardAppDialog = true;
      showDialog(context: context, builder: (_) => FlashcardAppDialog());
    }
    if (context.canPop()) {
      Navigator.of(context).pop();
    } else {
      context.go(RoutePaths.vocabulary);
    }
  }

  // ── build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_remainingWords.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bgColor = colorScheme.primary;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (!GlobalValues.isShowFlashCardAppDialog) {
          GlobalValues.isShowFlashCardAppDialog = true;
          showDialog(context: context, builder: (_) => FlashcardAppDialog());
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.title ?? 'Flashcards',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // ── Progress ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${_currentIndex + 1} of ${_remainingWords.length}',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white.withAlpha(60),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Flip Card ─────────────────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                child: _FlipCard(
                  animation: _flipAnimation,
                  isFrontVisible: _isFrontVisible,
                  frontChild: _FrontCard(word: _currentWord),
                  backChild: _BackCard(word: _currentWord),
                ),
              ),
            ),

            // ── Bottom Bar ────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isFlipped
                  ? _KnowButtons(
                      key: const ValueKey('know'),
                      onDontKnow: _onDontKnow,
                      onIKnow: _onIKnow,
                    )
                  : _TapHintBar(
                      key: const ValueKey('hint'),
                      onNext: _currentIndex < _remainingWords.length - 1
                          ? _onNext
                          : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _FlipCard  — The core 3D flip widget
//
//  Pattern (industry standard):
//    • One AnimationController 0..1 drives rotation 0..π
//    • AnimatedBuilder rebuilds only the Transform (no full tree rebuild)
//    • Back child is PRE-ROTATED by π so it appears correct after the flip
//    • setEntry(3,2,0.001) adds real 3D perspective depth
// ─────────────────────────────────────────────────────────────────────────────
class _FlipCard extends StatelessWidget {
  final Animation<double> animation;
  final bool isFrontVisible;
  final Widget frontChild;
  final Widget backChild;

  const _FlipCard({
    required this.animation,
    required this.isFrontVisible,
    required this.frontChild,
    required this.backChild,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        // animation.value goes 0 → 1  (i.e. 0° → 180°)
        final angle = animation.value * pi;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateY(angle);

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: isFrontVisible
              ? frontChild
              // Pre-rotate the back face by π so after the overall π rotation
              // the text is upright (not mirrored).
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: backChild,
                ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Front Card
// ─────────────────────────────────────────────────────────────────────────────
class _FrontCard extends StatelessWidget {
  final Word word;

  const _FrontCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.quiz_outlined,
                  size: 36, color: colorScheme.primary.withAlpha(160)),
            ),
            const SizedBox(height: 24),
            // Word
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                word.word,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // Phonetic pill
            if (word.phoneticText.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: colorScheme.primary.withAlpha(40), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volume_up_rounded,
                        size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      word.phoneticText,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_rounded,
                    size: 16, color: Colors.grey[400]),
                const SizedBox(width: 6),
                Text(
                  'Tap to reveal meaning',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Back Card
// ─────────────────────────────────────────────────────────────────────────────
class _BackCard extends StatelessWidget {
  final Word word;

  const _BackCard({required this.word});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final definition =
        word.userDefinition ?? word.senses.firstOrNull?.definition ?? '';
    final example =
        word.senses.firstOrNull?.examples.firstOrNull?.x ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💡', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 16),
              // Word
              Text(
                word.word,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Definition
              if (definition.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    definition,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF1A3A7A),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (example.isNotEmpty) ...[
                const SizedBox(height: 12),
                // Example
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Example:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        example,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[800],
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Bottom bars
// ─────────────────────────────────────────────────────────────────────────────
class _TapHintBar extends StatelessWidget {
  final VoidCallback? onNext;

  const _TapHintBar({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app_rounded, color: Colors.white70, size: 22),
              const SizedBox(height: 4),
              const Text('Tap card to flip',
                  style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
          if (onNext != null)
            GestureDetector(
              onTap: onNext,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white70, size: 22),
                  SizedBox(height: 4),
                  Text('Next',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _KnowButtons extends StatelessWidget {
  final VoidCallback onDontKnow;
  final VoidCallback onIKnow;

  const _KnowButtons({
    super.key,
    required this.onDontKnow,
    required this.onIKnow,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onDontKnow,
              icon: const Text('✕', style: TextStyle(fontSize: 16)),
              label: const Text("Don't Know",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE53935),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onIKnow,
              icon: const Text('✓', style: TextStyle(fontSize: 16)),
              label: const Text("I Know",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
