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
import '../settings/bloc/settings_bloc.dart';
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
  // ── word list ────────────────────────────────────────────────────────────
  late List<Word> _remainingWords;
  late List<Word> _dontKnowWords;
  int _currentIndex = 0;
  int _totalWords = 0;

  // ── flip animation ───────────────────────────────────────────────────────
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFrontVisible = true;
  bool _isFlipAnimating = false;

  // ── slide navigation ─────────────────────────────────────────────────────
  // _slideDirection:  1 = forward/next (new card enters from right)
  //                  -1 = backward/prev (new card enters from left)
  int _slideDirection = 1;
  // _cardKey is incremented each time we navigate to trigger AnimatedSwitcher
  int _cardKey = 0;

  bool get _isFlipped => !_isFrontVisible;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _remainingWords = List.from(widget.words);
    _dontKnowWords = [];
    _totalWords = widget.words.length;

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _flipAnimation = CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    );

    // Swap visible face at the halfway point (card is edge-on → invisible)
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
        _isFlipAnimating = false;
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  // ── computed ─────────────────────────────────────────────────────────────
  int get _completedCount => _totalWords - _remainingWords.length;
  double get _progress =>
      _totalWords == 0 ? 0.0 : _completedCount / _totalWords;
  Word get _currentWord => _remainingWords[_currentIndex];

  // ── flip ─────────────────────────────────────────────────────────────────
  void _flipCard() {
    if (_isFlipAnimating) return;
    _isFlipAnimating = true;
    if (_flipController.isDismissed) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  /// Instantly reset to front face (no animation) before navigating.
  void _resetFlipInstant() {
    _flipController.reset();
    _isFrontVisible = true; // set directly, setState called by caller
  }

  // ── navigation ────────────────────────────────────────────────────────────
  void _onNext() {
    if (_currentIndex >= _remainingWords.length - 1) return;
    _resetFlipInstant();
    setState(() {
      _slideDirection = 1;
      _currentIndex++;
      _cardKey++;
    });
  }

  void _onPrev() {
    if (_currentIndex <= 0) return;
    _resetFlipInstant();
    setState(() {
      _slideDirection = -1;
      _currentIndex--;
      _cardKey++;
    });
  }

  // ── know / don't know ────────────────────────────────────────────────────
  void _onIKnow() {
    if (!_isFlipped) {
      _flipCard();
      return;
    }
    context.read<VocabularyBloc>().add(
          VocabularyEvent.changeStatus(_currentWord, WordStatus.mastered),
        );
    _resetFlipInstant();
    setState(() {
      _slideDirection = 1;
      _remainingWords.removeAt(_currentIndex);
      _cardKey++;
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
    _resetFlipInstant();
    setState(() {
      _slideDirection = 1;
      final word = _remainingWords.removeAt(_currentIndex);
      _dontKnowWords.add(word);
      _remainingWords.add(word); // re-queue at end
      _cardKey++;
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

  // ── build ─────────────────────────────────────────────────────────────────
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
            // ── Progress bar ────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Text(
                    '${_currentIndex + 1} of ${_remainingWords.length}',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
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

            // ── Sliding + Flipping Card ─────────────────────────────────
            Expanded(
              child: GestureDetector(
                onTap: _flipCard,
                // Swipe left = next, swipe right = prev
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) return;
                  if (details.primaryVelocity! < -200) _onNext();
                  if (details.primaryVelocity! > 200) _onPrev();
                },
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  // Custom layoutBuilder to keep both cards in a Stack
                  // so the outgoing card slides out while incoming slides in.
                  layoutBuilder: (currentChild, previousChildren) => Stack(
                    alignment: Alignment.center,
                    children: [
                      ...previousChildren,
                      ?currentChild,
                    ],
                  ),
                  transitionBuilder: (child, animation) {
                    // Determine if this child is the NEW (incoming) card
                    // by comparing its key to the current _cardKey.
                    final isIncoming =
                        child.key == ValueKey('card_$_cardKey');

                    // Incoming card: enters from right (next) or left (prev)
                    // Outgoing card: exits to left (next) or right (prev)
                    final beginOffset = isIncoming
                        ? Offset(_slideDirection.toDouble(), 0)
                        : Offset(-_slideDirection.toDouble(), 0);

                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: beginOffset,
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                          reverseCurve: Curves.easeInCubic,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: _FlipCard(
                    // Key changes → AnimatedSwitcher plays the slide transition
                    key: ValueKey('card_$_cardKey'),
                    animation: _flipAnimation,
                    isFrontVisible: _isFrontVisible,
                    frontChild: _FrontCard(word: _currentWord),
                    backChild: _BackCard(word: _currentWord),
                  ),
                ),
              ),
            ),

            // ── Bottom bar ──────────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isFlipped
                  ? _KnowButtons(
                      key: const ValueKey('know'),
                      onDontKnow: _onDontKnow,
                      onIKnow: _onIKnow,
                    )
                  : _NavBar(
                      key: const ValueKey('nav'),
                      canPrev: _currentIndex > 0,
                      canNext: _currentIndex < _remainingWords.length - 1,
                      onPrev: _onPrev,
                      onNext: _onNext,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _FlipCard  — 3D flip using AnimationController + AnimatedBuilder
//
//  Back card is PRE-ROTATED by π to prevent mirror effect.
//  setEntry(3,2,0.001) adds perspective depth.
// ─────────────────────────────────────────────────────────────────────────────
class _FlipCard extends StatelessWidget {
  final Animation<double> animation;
  final bool isFrontVisible;
  final Widget frontChild;
  final Widget backChild;

  const _FlipCard({
    super.key,
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
        final angle = animation.value * pi; // 0 → π (0° → 180°)
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001) // 3D perspective
          ..rotateY(angle);

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: isFrontVisible
              ? frontChild
              // Pre-rotate back face by π → text stays upright after flip
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
            if (word.phoneticText.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
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
    final colorScheme = Theme.of(context).colorScheme;
    final locale =
        context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final showVi = locale == 'vi';
    final sense = word.senses.firstOrNull;
    // Short meaning (VI) → bold header. Full definition → body text below.
    final shortMeaning = showVi && (sense?.shortMeaningVi.isNotEmpty ?? false)
        ? sense!.shortMeaningVi
        : null;
    // Use VI definition if locale=vi and translation exists, else EN
    final definition = word.userDefinition ??
        (showVi && (sense?.definitionVi.isNotEmpty ?? false)
            ? sense!.definitionVi
            : sense?.definition ?? '');
    final example = sense?.examples.firstOrNull?.x ?? '';

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
              Text(
                word.word,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              // Short meaning badge (VI only)
              if (shortMeaning != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    shortMeaning,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
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
//  _NavBar  — Prev / hint text / Next  (shown when card is front-side)
// ─────────────────────────────────────────────────────────────────────────────
class _NavBar extends StatelessWidget {
  final bool canPrev;
  final bool canNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _NavBar({
    super.key,
    required this.canPrev,
    required this.canNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
      child: Row(
        children: [
          // Previous button
          _NavButton(
            icon: Icons.arrow_back_ios_new_rounded,
            label: 'Prev',
            enabled: canPrev,
            onTap: onPrev,
          ),

          // Centre hint
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.touch_app_rounded,
                    color: Colors.white70, size: 22),
                const SizedBox(height: 4),
                const Text(
                  'Tap card to flip',
                  style:
                      TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          // Next button
          _NavButton(
            icon: Icons.arrow_forward_ios_rounded,
            label: 'Next',
            enabled: canNext,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled ? Colors.white : Colors.white24;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: enabled
              ? Colors.white.withAlpha(30)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(color: color, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  _KnowButtons  — Don't Know / I Know (shown when card is flipped)
// ─────────────────────────────────────────────────────────────────────────────
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
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
