import '../data/models/word.dart';
import '../data/models/word_status.dart';
import '../data/repositories/achievement_repository.dart';
import '../ui/screens/progress/widgets/achievement_popup.dart';
import '../navigation/app_router.dart';

/// Service that checks achievement conditions and triggers unlock popups.
/// Call [check] methods after relevant actions (word status change, streak update, etc.)
class AchievementChecker {
  final AchievementRepository _repository;

  AchievementChecker({required AchievementRepository repository})
      : _repository = repository;

  /// Check all vocabulary-related achievements.
  /// Call after any word status change.
  Future<void> checkVocabAchievements(List<Word> words) async {
    final studyingCount =
        words.where((w) => w.status == WordStatus.studying).length;
    final masteredCount =
        words.where((w) => w.status == WordStatus.mastered).length;

    final newlyUnlocked = <AchievementDef>[];

    // Star-based achievements
    var result = await _repository.updateProgress('first_steps', studyingCount);
    if (result != null) newlyUnlocked.add(result);

    result = await _repository.updateProgress('word_collector', studyingCount);
    if (result != null) newlyUnlocked.add(result);

    // Mastered-based achievements
    result = await _repository.updateProgress('big_brain', masteredCount);
    if (result != null) newlyUnlocked.add(result);

    result = await _repository.updateProgress('scholar', masteredCount);
    if (result != null) newlyUnlocked.add(result);

    result = await _repository.updateProgress('diamond', masteredCount);
    if (result != null) newlyUnlocked.add(result);

    // Show popups for newly unlocked
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      for (final def in newlyUnlocked) {
        await AchievementPopup.show(context, def);
      }
    }
  }

  /// Check streak-related achievements.
  /// Call when streak count changes.
  Future<void> checkStreakAchievements(int streakDays) async {
    final newlyUnlocked = <AchievementDef>[];

    var result = await _repository.updateProgress('on_fire', streakDays);
    if (result != null) newlyUnlocked.add(result);

    result = await _repository.updateProgress('unstoppable', streakDays);
    if (result != null) newlyUnlocked.add(result);

    final context = AppRouter.rootNavigatorKey.currentContext;
    if (context != null && context.mounted) {
      for (final def in newlyUnlocked) {
        await AchievementPopup.show(context, def);
      }
    }
  }

  /// Check grammar-related achievements.
  /// Call when a grammar lesson is marked as read.
  Future<void> checkGrammarAchievements(int completedCount) async {
    final result =
        await _repository.updateProgress('grammar_guru', completedCount);
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (result != null && context != null && context.mounted) {
      await AchievementPopup.show(context, result);
    }
  }

  /// Check AI lesson achievements.
  /// Call when an AI lesson is completed/saved.
  Future<void> checkAiLessonAchievements() async {
    final count = await _repository.recordAiLessonComplete();
    final result = await _repository.updateProgress('bookworm', count);
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (result != null && context != null && context.mounted) {
      await AchievementPopup.show(context, result);
    }

    // Check polyglot (combo: 20 AI lessons + 200 mastered words)
    // This will be checked separately since it requires word data
  }

  /// Check quiz accuracy achievements.
  /// Call after a quiz with 100% accuracy and >= 5 words.
  Future<void> checkPerfectQuiz() async {
    final count = await _repository.recordPerfectQuiz();
    final result = await _repository.updateProgress('sharpshooter', count);
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (result != null && context != null && context.mounted) {
      await AchievementPopup.show(context, result);
    }
  }

  /// Check typing accuracy achievements.
  /// Call after a typing challenge with 100% accuracy and >= 5 words.
  Future<void> checkPerfectTyping() async {
    final count = await _repository.recordPerfectTyping();
    final result = await _repository.updateProgress('speed_typer', count);
    final context = AppRouter.rootNavigatorKey.currentContext;
    if (result != null && context != null && context.mounted) {
      await AchievementPopup.show(context, result);
    }
  }

  /// Check the polyglot (combo) achievement.
  /// Call when either AI lessons or mastered words change.
  Future<void> checkPolyglot(int aiLessonCount, int masteredCount) async {
    final met = aiLessonCount >= 20 && masteredCount >= 200;
    if (met) {
      final result = await _repository.updateProgress('polyglot', 1);
      final context = AppRouter.rootNavigatorKey.currentContext;
      if (result != null && context != null && context.mounted) {
        await AchievementPopup.show(context, result);
      }
    }
  }
}
