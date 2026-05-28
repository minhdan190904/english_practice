import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/models/lesson.dart';

import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/selection_area_with_search.dart';
import '../settings/bloc/settings_bloc.dart';
import 'bloc/lesson_bloc.dart';
import '../../../navigation/app_router.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  String? data;
  late ScrollController _scrollController;

  /// Khi true: user đang xem bản tiếng Việt trong lesson này (override locale)
  /// Khi false: xem bản tiếng Anh
  bool? _localOverrideVi;

  /// Đường dẫn file tiếng Việt: đổi `grammar/` → `grammar_vi/`
  String get _viPath =>
      widget.lesson.path.replaceFirst('assets/md/grammar/', 'assets/md/grammar_vi/');

  bool _hasViVersion(String locale) =>
      widget.lesson.path.contains('assets/md/grammar/');

  @override
  Widget build(BuildContext context) {
    final title = widget.lesson.title;

    final colorScheme = Theme.of(context).colorScheme;
    final globalLocale = context.watch<SettingsBloc>().state.settingsSnapshot.locale;

    // Xác định ngôn ngữ đang hiển thị:
    // 1. Nếu user đã bấm toggle trong lesson này → dùng override
    // 2. Nếu chưa → dùng locale global từ Settings
    final isVi = _localOverrideVi ?? (globalLocale == 'vi');
    final hasVi = _hasViVersion(globalLocale);

    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (canPop, result) {},
          child: Column(
            children: [
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  floatingActionButton: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: 'ai_examples',
                        onPressed: () {
                          context.push(
                            RoutePaths.grammarAi,
                            extra: {
                              'grammarTopic': widget.lesson.title,
                              'lessonId': widget.lesson.id,
                            },
                          );
                        },
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text(
                          'AI Examples',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton.extended(
                        heroTag: 'quiz',
                        onPressed: () {
                          context.push(
                            RoutePaths.grammarQuiz,
                            extra: {
                              'topicId': widget.lesson.id,
                              'topicTitle': widget.lesson.title,
                            },
                          );
                        },
                        icon: const Icon(Icons.quiz_outlined, size: 20),
                        label: const Text(
                          'Làm bài tập',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  body: BasePage(
                    title: title,
                    actions: [
                      // Toggle EN/VI — chỉ hiện khi bài học có bản tiếng Việt
                      if (hasVi)
                        GestureDetector(
                          onTap: () => _toggleLanguage(isVi),
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isVi ? '🇻🇳 VI' : '🇬🇧 EN',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      Checkbox(
                        value: state.markedLessons[widget.lesson.id] ?? false,
                        onChanged: (value) {
                          _onMarkAsRead(value);
                        },
                      )
                    ],
                    child: data == null
                        ? Center(child: LoadingAnimationWidget.fourRotatingDots(color: colorScheme.primary, size: 40))
                        : SelectionAreaWithSearch(
                            child: Builder(builder: (ctx) {
                              final theme = Theme.of(ctx);
                              final cs = theme.colorScheme;
                              final isDark = theme.brightness == Brightness.dark;
                              final base = MarkdownStyleSheet.fromTheme(theme);

                              // Code block
                              final codeBlockBg = isDark
                                  ? cs.surfaceContainerHighest
                                  : cs.surfaceContainerLow;

                              // Blockquote — the blue description box at top of grammar lessons
                              final blockquoteBg = isDark
                                  ? cs.primaryContainer.withAlpha(80)
                                  : cs.primaryContainer;
                              final blockquoteTextColor = isDark
                                  ? cs.onSurface
                                  : cs.onPrimaryContainer;

                              // Table
                              final tableHeadBg = isDark
                                  ? cs.surfaceContainerHighest
                                  : cs.surfaceContainerLow;
                              final tableBorderColor = isDark
                                  ? cs.outline.withAlpha(100)
                                  : cs.outlineVariant;

                              return Markdown(
                                data: data!,
                                controller: _scrollController,
                                softLineBreak: true,
                                styleSheet: base.copyWith(
                                  // Code
                                  code: base.code?.copyWith(
                                    backgroundColor: codeBlockBg,
                                    color: cs.onSurface,
                                  ),
                                  codeblockDecoration: BoxDecoration(
                                    color: codeBlockBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Blockquote
                                  blockquoteDecoration: BoxDecoration(
                                    color: blockquoteBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border(
                                      left: BorderSide(
                                        color: cs.primary,
                                        width: 4,
                                      ),
                                    ),
                                  ),
                                  blockquote: base.blockquote?.copyWith(
                                    color: blockquoteTextColor,
                                  ),
                                  // Table
                                  tableHead: base.tableHead?.copyWith(
                                    color: cs.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  tableBody: base.tableBody?.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  tableHeadAlign: TextAlign.left,
                                  tableBorder: TableBorder.all(
                                    color: tableBorderColor,
                                    width: 1,
                                  ),
                                  tableColumnWidth: const FlexColumnWidth(),
                                  tableCellsPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  // Body text
                                  p: base.p?.copyWith(color: cs.onSurface),
                                  h1: base.h1?.copyWith(color: cs.onSurface),
                                  h2: base.h2?.copyWith(color: cs.onSurface),
                                  h3: base.h3?.copyWith(color: cs.onSurface),
                                  h4: base.h4?.copyWith(color: cs.onSurface),
                                  strong: base.strong?.copyWith(color: cs.onSurface),
                                  em: base.em?.copyWith(color: cs.onSurface),
                                  listBullet: base.listBullet?.copyWith(color: cs.onSurface),
                                ),
                              );
                            }),
                          ),
                  ),
                ),
              ),
              const BannerAdWidget(),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Toggle ngôn ngữ trong lesson hiện tại (không thay đổi setting global)
  void _toggleLanguage(bool currentlyVi) {
    setState(() {
      _localOverrideVi = !currentlyVi;
      data = null; // reset để hiện loading
    });
    _loadContent(forceVi: !currentlyVi);
  }

  /// Load file markdown theo ngôn ngữ hiện tại
  Future<void> _loadContent({bool? forceVi}) async {
    final globalLocale = context.read<SettingsBloc>().state.settingsSnapshot.locale;
    final shouldLoadVi = forceVi ?? (_localOverrideVi ?? (globalLocale == 'vi'));
    final hasVi = _hasViVersion(globalLocale);

    String path = widget.lesson.path;
    if (shouldLoadVi && hasVi) {
      path = _viPath;
    }

    try {
      final content = await rootBundle.loadString(path);
      if (mounted) {
        setState(() { data = content; });
      }
    } catch (_) {
      // Fallback về bản tiếng Anh nếu file VI chưa có
      try {
        final content = await rootBundle.loadString(widget.lesson.path);
        if (mounted) {
          setState(() { data = content; });
        }
      } catch (e) {
        if (mounted) {
          setState(() { data = '> Không tải được nội dung bài học.'; });
        }
      }
    }
  }

  void _onMarkAsRead(bool? value) {
    if (value == null) return;
    context.read<LessonBloc>().add(LessonEvent.markLesson(id: widget.lesson.id, isMarked: value));
  }

}
