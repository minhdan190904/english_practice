import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../commons/rounded_button.dart';
import '../../commons/selection_area_with_search.dart';
import '../vocabulary/widgets/vocabulary_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  bool _isReviewing = false;
  int _currentPage = 0;

  // Entrance animation
  late final AnimationController _enterController;
  late final Animation<double> _enterFade;
  late final Animation<Offset> _enterSlide;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _enterFade = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOut,
    );
    _enterSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    ));

    _enterController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _enterFade,
          child: SlideTransition(
            position: _enterSlide,
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8),
                    child: TextButton(
                      onPressed: _onSkip,
                      child: Text(
                        L10n.tr(context, 'skip'),
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() => _currentPage = page);
                    },
                    children: [
                      _buildWelcomePage(colorScheme, textTheme),
                      _buildVocabPage(colorScheme, textTheme),
                      _buildGrammarPage(colorScheme, textTheme),
                      _buildReviewPage(colorScheme, textTheme),
                    ],
                  ),
                ),

                // Bottom section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    children: [
                      // Page indicator
                      SmoothPageIndicator(
                        controller: _pageController,
                        count: 4,
                        effect: ExpandingDotsEffect(
                          dotColor: colorScheme.primary.withValues(alpha: 0.2),
                          activeDotColor: colorScheme.primary,
                          dotHeight: 8,
                          dotWidth: 8,
                          expansionFactor: 3,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Next/Get Started button
                      RoundedButton(
                        borderRadius: 16,
                        onPressed: _onNext,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _currentPage == 3
                                ? L10n.tr(context, 'start_learning')
                                : L10n.tr(context, 'next'),
                            key: ValueKey(_currentPage == 3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Page 1: Welcome ─────────────────────────────────────────

  Widget _buildWelcomePage(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              Assets.pngLauncher,
              width: 140,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to English Handbook!',
            style: textTheme.headlineSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'The best way to learn English vocabulary.\nWe\'re glad to have you here!',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Page 2: Vocabulary ────────────────────────────────────────

  Widget _buildVocabPage(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon instead of heavy widget
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          VocabularyItem(
            word: Words.sampleWord,
            onMastered: () {},
            onStar: () {},
            viewOnly: true,
          ),
          const SizedBox(height: 24),
          Text(
            'View definitions and start learning!',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on any word to view its definition and start learning it.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Page 3: Grammar (lightweight, no flutter_markdown) ───────

  Widget _buildGrammarPage(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.school_rounded,
              size: 40,
              color: colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 24),
          // Lightweight grammar preview (replaces heavy Markdown widget)
          SelectionAreaWithSearch(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📝 Adjectives',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(text: 'An '),
                        TextSpan(
                          text: 'adjective',
                          style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                        const TextSpan(
                          text: ' is a word that describes a noun by providing more information about its quality, size, color, or shape.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Grammar lessons',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Learn grammar with structured lessons.\nLong press on any text to translate!',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── Page 4: Review & Flashcards ────────────────────────────────

  Widget _buildReviewPage(ColorScheme colorScheme, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.star_rounded,
              size: 44,
              color: Colors.amber.shade600,
            ),
          ),
          const SizedBox(height: 24),
          VocabularyItem(
            word: Words.sampleWord.copyWith(
              status: _isReviewing ? WordStatus.studying : WordStatus.unknown,
            ),
            onMastered: () {},
            onStar: () {
              setState(() => _isReviewing = !_isReviewing);
            },
            viewOnly: true,
          ),
          const SizedBox(height: 24),
          Text(
            'Review and Flashcards',
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Star words to add to your review list.\nLearn with flashcards and practice exercises!',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Try it button
          AnimatedOpacity(
            opacity: _isReviewing ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: RoundedButton(
              borderRadius: 16,
              backgroundColor: colorScheme.tertiary,
              isDisabled: !_isReviewing,
              onPressed: _isReviewing
                  ? () {
                      context.go(RoutePaths.flashcards, extra: {
                        'words': [Words.sampleWord, Words.helloWord]
                      });
                    }
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(L10n.tr(context, 'start_learning')),
                ],
              ),
            ),
          ),
          if (!_isReviewing) ...[
            const SizedBox(height: 8),
            Text(
              '👆 Try pressing the star button above!',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary.withValues(alpha: 0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onNext() {
    if (_currentPage == 3) {
      context.go(RoutePaths.vocabulary);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onSkip() {
    context.go(RoutePaths.vocabulary);
  }
}
