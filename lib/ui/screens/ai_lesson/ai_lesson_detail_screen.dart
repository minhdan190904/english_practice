import 'dart:convert';
import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get_it/get_it.dart';
import '../../../configs/di.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/word.dart';
import '../../../data/models/sense.dart';
import '../../../data/models/example.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../review/flash_card_screen.dart';
import '../settings/bloc/settings_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';

class AiLessonDetailScreen extends StatefulWidget {
  final String title;
  final String passage;
  final String? passageVi;
  final List<SelectedWord> selectedWords;
  final String? imageBase64;

  const AiLessonDetailScreen({
    super.key,
    required this.title,
    required this.passage,
    this.passageVi,
    required this.selectedWords,
    this.imageBase64,
  });

  @override
  State<AiLessonDetailScreen> createState() => _AiLessonDetailScreenState();
}

class _AiLessonDetailScreenState extends State<AiLessonDetailScreen> {
  bool _showFull = false;
  bool _isVi = false;
  final _player = DI().sl<AudioPlayer>();
  final Map<String, LockCachingAudioSource> _audioCache = {};

  // Cached highlighted passage to avoid re-parsing on every setState
  Widget? _cachedPassageWidget;
  // Cached word map for quick lookup
  late final Map<String, SelectedWord> _wordMap;
  late final Set<String> _highlightSet;

  @override
  void initState() {
    super.initState();
    _preloadAudio();
    // Pre-compute word map once
    _wordMap = <String, SelectedWord>{};
    for (final w in widget.selectedWords) {
      _wordMap[w.word.toLowerCase()] = w;
    }
    _highlightSet = _wordMap.keys.toSet();
  }

  void _preloadAudio() {
    for (final word in widget.selectedWords) {
      if (word.phoneticUrl?.isNotEmpty ?? false) {
        final url = word.phoneticUrl!;
        if (!_audioCache.containsKey(url)) {
          _audioCache[url] = LockCachingAudioSource(Uri.parse(url))..request();
        }
      }
      if (word.phoneticAmUrl?.isNotEmpty ?? false) {
        final url = word.phoneticAmUrl!;
        if (!_audioCache.containsKey(url)) {
          _audioCache[url] = LockCachingAudioSource(Uri.parse(url))..request();
        }
      }
    }
  }

  // ── Report dialog ──────────────────────────────────────────────────────────
  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ReportSheet(
        title: widget.title,
        onSuccess: () {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Báo cáo đã được gửi. Cảm ơn bạn!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  // ── Play audio from URL ────────────────────────────────────────────────
  Future<void> _playAudio(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      if (!_audioCache.containsKey(url)) {
        _audioCache[url] = LockCachingAudioSource(Uri.parse(url));
      }
      await _player.setAudioSource(_audioCache[url]!);
      await _player.play();
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  // ── Show word meaning bottom sheet ─────────────────────────────────────
  void _showWordMeaning(BuildContext context, SelectedWord word) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = context.read<SettingsBloc>().state.settingsSnapshot.locale;
    final showVi = locale == 'vi';

    final displayDef = (showVi && (word.definitionVi?.isNotEmpty ?? false))
        ? word.definitionVi!
        : word.definition ?? '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, -4)),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha(50),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Word + phonetic + audio
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      if (word.phoneticText?.isNotEmpty ?? false)
                        Text(
                          word.phoneticText!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha(160),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                // Audio buttons
                if (word.phoneticUrl?.isNotEmpty ?? false)
                  _AudioBtn(
                    label: 'UK',
                    color: Colors.green,
                    onTap: () => _playAudio(word.phoneticUrl),
                  ),
                const SizedBox(width: 8),
                if (word.phoneticAmUrl?.isNotEmpty ?? false)
                  _AudioBtn(
                    label: 'US',
                    color: Colors.red,
                    onTap: () => _playAudio(word.phoneticAmUrl),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // POS badge
            if (word.pos?.isNotEmpty ?? false)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  word.pos!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Short VI meaning badge — ưu tiên shortMeaningVi, fallback definitionVi
            if (showVi && ((word.shortMeaningVi?.isNotEmpty ?? false) || (word.definitionVi?.isNotEmpty ?? false)))
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  word.shortMeaningVi?.isNotEmpty == true ? word.shortMeaningVi! : word.definitionVi!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            if (showVi && ((word.shortMeaningVi?.isNotEmpty ?? false) || (word.definitionVi?.isNotEmpty ?? false))) const SizedBox(height: 8),
            // Definition
            if (displayDef.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE8FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  displayDef,
                  style: const TextStyle(
                    fontSize: 15, color: Color(0xFF1A3A7A), height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            // Example
            if (word.example?.isNotEmpty ?? false)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      L10n.tr(context, 'examples'),
                      style: TextStyle(
                        fontSize: 12, color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      word.example!,
                      style: TextStyle(
                        fontSize: 14, color: Colors.green[800],
                        fontStyle: FontStyle.italic, height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Build highlighted + tappable passage (cached) ──────────────────────
  Widget _getHighlightedPassage(BuildContext context) {
    // Return cached widget if available — avoids re-parsing regex on every setState
    if (_cachedPassageWidget != null) return _cachedPassageWidget!;
    _cachedPassageWidget = _buildHighlightedPassage(context);
    return _cachedPassageWidget!;
  }

  Widget _buildHighlightedPassage(BuildContext context) {
    final theme = Theme.of(context);
    // Use pre-computed word map from initState
    final wordTokenRegex = RegExp(r"^([^a-zA-Z']*)([a-zA-Z']+)([^a-zA-Z']*)$");

    final rawPassage = widget.passage.replaceAll('**', '').replaceAll('*', '');
    final rawWords = rawPassage.split(RegExp(r'(\s+)'));
    final spans = <InlineSpan>[];

    for (final token in rawWords) {
      if (token.trim().isEmpty) {
        spans.add(TextSpan(text: token));
        continue;
      }
      final match = wordTokenRegex.firstMatch(token);
      if (match != null) {
        final pre = match.group(1) ?? '';
        final word = match.group(2) ?? '';
        final post = match.group(3) ?? '';
        final isHighlighted = _highlightSet.contains(word.toLowerCase());
        if (isHighlighted) {
          if (pre.isNotEmpty) spans.add(TextSpan(text: pre));
          final selectedWord = _wordMap[word.toLowerCase()]!;
          spans.add(WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => _showWordMeaning(context, selectedWord),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE68A),
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
                child: Text(
                  word,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.7,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    backgroundColor: const Color(0xFFFDE68A),
                  ),
                ),
              ),
            ),
          ));
          if (post.isNotEmpty) spans.add(TextSpan(text: post));
        } else {
          spans.add(TextSpan(text: token));
        }
      } else {
        spans.add(TextSpan(text: token));
      }
      spans.add(const TextSpan(text: ' '));
    }

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.7, color: Colors.black87),
        children: spans,
      ),
    );
  }

  void _practiceNow() {
    final locale = context.read<SettingsBloc>().state.settingsSnapshot.locale;
    final showVi = locale == 'vi';

    final words = widget.selectedWords.asMap().entries.map((entry) {
      final i = entry.key;
      final w = entry.value;
      return Word(
        word: w.word,
        pos: w.pos ?? '',
        phonetic: w.phoneticUrl ?? '',
        phoneticText: w.phoneticText ?? '',
        phoneticAm: w.phoneticAmUrl ?? '',
        phoneticAmText: w.phoneticAmText ?? '',
        senses: [
          Sense(
            definition: w.definition ?? '',
            definitionVi: w.definitionVi ?? '',
            shortMeaningVi: showVi ? (w.shortMeaningVi ?? '') : '',
            examples: w.example != null ? [Example(cf: '', x: w.example!)] : [],
          ),
        ],
        index: i,
      );
    }).toList();

    // Capture bloc references BEFORE pushing (they come from the ancestor tree)
    final settingsBloc = context.read<SettingsBloc>();

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DI().sl<VocabularyBloc>()),
            BlocProvider(create: (_) => DI().sl<IapBloc>()),
            // Re-provide SettingsBloc so _BackCard's context.watch works
            BlocProvider<SettingsBloc>.value(value: settingsBloc),
          ],
          child: FlashCardScreen(words: words, title: widget.title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final showVi = locale == 'vi';
    final wordCount = widget.passage.trim().split(RegExp(r'\s+')).length;
    final isLong = widget.passage.length > 400;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(L10n.tr(context, 'created_today'),
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                      const SizedBox(width: 16),
                      Icon(Icons.text_fields_rounded, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text('$wordCount words',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () => _showReportDialog(context),
                        icon: const Icon(Icons.flag_outlined, size: 14),
                        label: Text(L10n.tr(context, 'report')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: const TextStyle(fontSize: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── AI-generated illustration ──
            if (widget.imageBase64 != null && widget.imageBase64!.isNotEmpty)
              _LessonImage(base64: widget.imageBase64!),
            if (widget.imageBase64 != null && widget.imageBase64!.isNotEmpty)
              const SizedBox(height: 16),

            // Language toggle bar (only show when Vietnamese translation is available)
            if (widget.passageVi != null && widget.passageVi!.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colorScheme.outlineVariant.withAlpha(80)),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isVi = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !_isVi ? colorScheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: !_isVi
                                ? [BoxShadow(color: colorScheme.primary.withAlpha(60), blurRadius: 8, offset: const Offset(0, 2))]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Nguyên bản',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: !_isVi ? Colors.white : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isVi = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _isVi ? colorScheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _isVi
                                ? [BoxShadow(color: colorScheme.primary.withAlpha(60), blurRadius: 8, offset: const Offset(0, 2))]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dịch',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _isVi ? Colors.white : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Tap hint (only show in English mode)
            if (!_isVi)
              Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 14, color: colorScheme.primary.withAlpha(160)),
                  const SizedBox(width: 6),
                  Text(
                    showVi
                        ? 'Nhấn vào từ được tô vàng để xem nghĩa'
                        : 'Tap highlighted words to see meaning',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary.withAlpha(160),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            if (!_isVi) const SizedBox(height: 8),

            // Passage card with tappable highlights + expand/collapse
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clipped passage with gradient fade when collapsed
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 320),
                    curve: Curves.easeInOut,
                    constraints: BoxConstraints(
                      maxHeight: _showFull ? 9999.0 : 140,
                    ),
                    child: ClipRect(
                      child: Stack(
                        children: [
                          _isVi
                              ? Text(
                                  (widget.passageVi ?? '').replaceAll('**', '').replaceAll('*', ''),
                                  style: TextStyle(height: 1.6, fontSize: 16, color: Colors.grey.shade800),
                                )
                              : _getHighlightedPassage(context),
                          // Gradient fade at bottom when collapsed
                          if (!_showFull)
                            Positioned(
                              left: 0, right: 0, bottom: 0,
                              height: 48,
                              child: IgnorePointer(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.white.withAlpha(0), Colors.white],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Expand / Collapse button
                  GestureDetector(
                    onTap: () => setState(() => _showFull = !_showFull),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _showFull
                              ? (showVi ? 'Thu gọn' : 'Show less')
                              : (showVi ? 'Xem thêm' : 'Show more'),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedRotation(
                          turns: _showFull ? 0.5 : 0,
                          duration: const Duration(milliseconds: 320),
                          child: Icon(Icons.keyboard_arrow_down_rounded,
                              size: 18, color: theme.colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Practice Now button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, Colors.blueAccent, Colors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _practiceNow,
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.style, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(L10n.tr(context, 'practice_now'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Vocabulary list
            Text(L10n.tr(context, 'vocabulary_list'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.selectedWords.length,
                separatorBuilder: (_, _a) => const Divider(height: 1, indent: 64),
                itemBuilder: (context, i) {
                  final word = widget.selectedWords[i];
                  final displayDef = (showVi && (word.definitionVi?.isNotEmpty ?? false))
                      ? word.definitionVi!
                      : word.definition ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: InkWell(
                      onTap: () => _showWordMeaning(context, word),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Row 1: Word + short badge + delete ──────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Audio icon
                              GestureDetector(
                                onTap: () => _playAudio(word.phoneticUrl ?? word.phoneticAmUrl),
                                child: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer.withAlpha(100),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.volume_up_rounded,
                                    color: colorScheme.primary, size: 18),
                                ),
                              ),
                              const SizedBox(width: 10),
                              // Word
                              Text(word.word,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                              const Spacer(),
                              // Delete
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded,
                                  color: Colors.redAccent, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => setState(() => widget.selectedWords.removeAt(i)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // ── Short meaning badge (below word row) ────────
                          if (showVi && ((word.shortMeaningVi?.isNotEmpty ?? false) || (word.definitionVi?.isNotEmpty ?? false)))
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withAlpha(180),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '🇻🇳 ',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Flexible(
                                    child: Text(
                                      word.shortMeaningVi?.isNotEmpty == true
                                          ? word.shortMeaningVi!
                                          : word.definitionVi!,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          // ── Row 2: Meaning ──────────────────────────────
                          if (displayDef.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 56,
                                  margin: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    showVi ? 'Nghĩa:' : 'Meaning:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(displayDef,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade800,
                                      height: 1.4,
                                    )),
                                ),
                              ],
                            ),
                          // ── Row 3: Phonetic + audio buttons ────────────
                          if (word.phoneticText?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 56,
                                  child: Text(
                                    showVi ? 'Phát âm:' : 'IPA:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                  ),
                                ),
                                Text(
                                  '/${word.phoneticText}/',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (word.phoneticUrl?.isNotEmpty ?? false)
                                  _SmallAudioBtn(
                                    label: 'UK',
                                    color: Colors.green,
                                    onTap: () => _playAudio(word.phoneticUrl),
                                  ),
                                if (word.phoneticAmUrl?.isNotEmpty ?? false) ...[
                                  const SizedBox(width: 4),
                                  _SmallAudioBtn(
                                    label: 'US',
                                    color: Colors.red,
                                    onTap: () => _playAudio(word.phoneticAmUrl),
                                  ),
                                ],
                              ],
                            ),
                          ],
                          // ── Row 4: Example ─────────────────────────────
                          if (word.example?.isNotEmpty ?? false) ...[
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 56,
                                  margin: const EdgeInsets.only(top: 1),
                                  child: Text(
                                    showVi ? 'Ví dụ:' : 'Example:',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(word.example!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    )),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── AI-generated lesson illustration ──────────────────────────────────────
class _LessonImage extends StatefulWidget {
  final String base64;
  const _LessonImage({required this.base64});

  @override
  State<_LessonImage> createState() => _LessonImageState();
}

class _LessonImageState extends State<_LessonImage> {
  double _opacity = 0.0;
  // Cache decoded bytes — base64Decode is expensive and should not run on every build
  late final _imageBytes = base64Decode(widget.base64);

  @override
  void initState() {
    super.initState();
    // Short delay then fade in for a polished entrance
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: _opacity,
      curve: Curves.easeOut,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // The image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.memory(
                _imageBytes,
                width: double.infinity,
                fit: BoxFit.cover,
                // Prevent re-decoding when widget rebuilds
                gaplessPlayback: true,
              ),
            ),
            // Subtle bottom gradient overlay for polish
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(60)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Small audio button widget ──────────────────────────────────────────────
class _AudioBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AudioBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          border: Border.all(color: color.withAlpha(120)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volume_up_rounded, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ── Smaller audio button for subtitle row ─────────────────────────────────────
class _SmallAudioBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SmallAudioBtn({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          border: Border.all(color: color.withAlpha(100)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volume_up_rounded, size: 12, color: color),
            const SizedBox(width: 3),
            Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// ── Report Sheet ──────────────────────────────────────────────────────────────
class _ReportSheet extends StatefulWidget {
  final String title;
  final VoidCallback onSuccess;

  const _ReportSheet({required this.title, required this.onSuccess});

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  // No GlobalKey, no Form — manual validation only
  final _reasonController = TextEditingController();
  String _selectedType = 'passage';
  String? _errorText;
  bool _sending = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() => _errorText = 'Vui lòng mô tả vấn đề');
      return;
    }
    setState(() { _sending = true; _errorText = null; });
    try {
      await GetIt.instance<AiRepository>().submitReport(
        type: _selectedType,
        content: widget.title,
        reason: reason,
      );
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi gửi báo cáo: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha(50),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('🚨 Báo cáo nội dung',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Giúp chúng tôi cải thiện chất lượng nội dung',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
            const SizedBox(height: 16),
            Text('Loại báo cáo', style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final t in [
                  ('passage', '📝 Đoạn văn'),
                  ('word', '🔤 Từ vựng'),
                  ('translation', '🇻🇳 Bản dịch'),
                  ('other', '❔ Khác'),
                ])
                  ChoiceChip(
                    label: Text(t.$2),
                    selected: _selectedType == t.$1,
                    onSelected: (_) => setState(() => _selectedType = t.$1),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text('Mô tả vấn đề', style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              onChanged: (_) { if (_errorText != null) setState(() => _errorText = null); },
              decoration: InputDecoration(
                hintText: 'Ví dụ: Bản dịch tiếng Việt không chính xác...',
                errorText: _errorText,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(80),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sending ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _sending
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Gửi báo cáo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
