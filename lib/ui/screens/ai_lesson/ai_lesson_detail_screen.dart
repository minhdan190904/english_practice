import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import '../../../configs/di.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/models/word.dart';
import '../../../data/models/sense.dart';
import '../../../data/models/example.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../review/flash_card_screen.dart';
import '../settings/bloc/settings_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';

class AiLessonDetailScreen extends StatefulWidget {
  final String title;
  final String passage;
  final String? passageVi;
  final List<SelectedWord> selectedWords;

  const AiLessonDetailScreen({
    super.key,
    required this.title,
    required this.passage,
    this.passageVi,
    required this.selectedWords,
  });

  @override
  State<AiLessonDetailScreen> createState() => _AiLessonDetailScreenState();
}

class _AiLessonDetailScreenState extends State<AiLessonDetailScreen> {
  bool _showFull = false;
  bool _isVi = false;
  final _player = DI().sl<AudioPlayer>();

  // ── Play audio from URL ────────────────────────────────────────────────
  Future<void> _playAudio(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      await _player.setUrl(url);
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

  // ── Build highlighted + tappable passage ───────────────────────────────
  Widget _buildHighlightedPassage(BuildContext context) {
    final theme = Theme.of(context);
    // Map word → SelectedWord for quick lookup
    final wordMap = <String, SelectedWord>{};
    for (final w in widget.selectedWords) {
      wordMap[w.word.toLowerCase()] = w;
    }
    final highlightSet = wordMap.keys.toSet();

    final rawWords = widget.passage.split(RegExp(r'(\s+)'));
    final spans = <InlineSpan>[];

    for (final token in rawWords) {
      if (token.trim().isEmpty) {
        spans.add(TextSpan(text: token));
        continue;
      }
      final match = RegExp(r"^([^a-zA-Z']*)([a-zA-Z']+)([^a-zA-Z']*)$").firstMatch(token);
      if (match != null) {
        final pre = match.group(1) ?? '';
        final word = match.group(2) ?? '';
        final post = match.group(3) ?? '';
        final isHighlighted = highlightSet.contains(word.toLowerCase());
        if (isHighlighted) {
          if (pre.isNotEmpty) spans.add(TextSpan(text: pre));
          final selectedWord = wordMap[word.toLowerCase()]!;
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

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DI().sl<VocabularyBloc>()),
            BlocProvider(create: (_) => DI().sl<IapBloc>()),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => Navigator.pop(context),
          )
        ],
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
                      if (widget.passageVi != null && widget.passageVi!.isNotEmpty)
                        GestureDetector(
                          onTap: () => setState(() => _isVi = !_isVi),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _isVi ? '🇻🇳 VI' : '🇬🇧 EN',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      OutlinedButton.icon(
                        onPressed: () {},
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

            // Tap hint
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

            // Passage card with tappable highlights
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
                  AnimatedCrossFade(
                    firstChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isVi
                            ? Text(widget.passageVi ?? '',
                                style: TextStyle(
                                  height: 1.6,
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                ))
                            : _buildHighlightedPassage(context),
                        if (isLong && !_showFull) ...[
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => setState(() => _showFull = true),
                            child: Text(L10n.tr(context, 'show_more'),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              )),
                          ),
                        ],
                      ],
                    ),
                    secondChild: _isVi
                        ? Text(widget.passageVi ?? '',
                            style: TextStyle(
                              height: 1.6,
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ))
                        : _buildHighlightedPassage(context),
                    crossFadeState: (_showFull || !isLong)
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
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

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: GestureDetector(
                      onTap: () => _playAudio(word.phoneticUrl ?? word.phoneticAmUrl),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withAlpha(80),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.volume_up_rounded,
                          color: colorScheme.primary, size: 20),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(word.word,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        // Badge ngắn trong vocab list — ưu tiên shortMeaningVi
                        if (showVi && ((word.shortMeaningVi?.isNotEmpty ?? false) || (word.definitionVi?.isNotEmpty ?? false)))
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              word.shortMeaningVi?.isNotEmpty == true ? word.shortMeaningVi! : word.definitionVi!,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (displayDef.isNotEmpty)
                          Text('${L10n.tr(context, 'meaning_prefix')}$displayDef',
                            style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                        if (word.phoneticText != null)
                          Row(
                            children: [
                              Text('${L10n.tr(context, 'pronunciation_prefix')}${word.phoneticText}',
                                style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12)),
                              const Spacer(),
                              if (word.phoneticUrl?.isNotEmpty ?? false)
                                _SmallAudioBtn(
                                  label: 'UK',
                                  color: Colors.green,
                                  onTap: () => _playAudio(word.phoneticUrl),
                                ),
                              if (word.phoneticAmUrl?.isNotEmpty ?? false) ...[
                                const SizedBox(width: 6),
                                _SmallAudioBtn(
                                  label: 'US',
                                  color: Colors.red,
                                  onTap: () => _playAudio(word.phoneticAmUrl),
                                ),
                              ],
                            ],
                          ),
                        if (word.example != null)
                          Text(word.example!,
                            style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic, fontSize: 12)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          widget.selectedWords.removeAt(i);
                        });
                      },
                    ),
                    onTap: () => _showWordMeaning(context, word),
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
