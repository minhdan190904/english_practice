import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../../utils/l10n.dart';
import '../../../commons/dialogs/user_definition_dialog.dart';
import '../../../commons/svg_button.dart';
import '../../settings/bloc/settings_bloc.dart';
import '../bloc/vocabulary_bloc.dart';
import 'phonetic.dart';
import 'pos_badge.dart';

class VocabularyItem extends StatelessWidget {
  final Word word;
  final bool viewOnly;
  final bool showReviewButton;
  final VoidCallback? onMastered;
  final VoidCallback? onStar;
  final VoidCallback? onReminder;

  const VocabularyItem({
    super.key,
    required this.word,
    this.showReviewButton = true,
    this.viewOnly = false,
    this.onMastered,
    this.onStar,
    this.onReminder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final locale = context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final showVi = locale == 'vi';
    final pos = word.pos.split(', ').where((p) => p.isNotEmpty).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusStyle = _StatusStyle.from(word.status, colorScheme, isDark);

    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: () => _openWordDetails(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.03),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Container(
              decoration: BoxDecoration(
                color: statusStyle.background,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                  // ── Left accent strip ──
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: statusStyle.stripGradient,
                      ),
                    ),
                  ),
                  // ── Content ──
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Word + star + POS
                          _buildHeader(context, textTheme, colorScheme, pos, statusStyle),
                          const SizedBox(height: 5),

                          // Row 2: Phonetics
                          _buildPhonetics(context, colorScheme),

                          // Row 3: Definition
                          if (word.status != WordStatus.mastered && (word.senses.isNotEmpty || word.userDefinition != null)) ...[
                            const SizedBox(height: 6),
                            _buildDefinition(textTheme, colorScheme, showVi),
                          ],

                          // Row 4: Status chip + edit
                          if (showReviewButton) ...[
                            const SizedBox(height: 8),
                            _buildBottomRow(context, textTheme, colorScheme, statusStyle),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Row 1: Word title + star toggle + POS badges
  // ────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context, TextTheme textTheme, ColorScheme colorScheme, List<String> pos, _StatusStyle style) {
    return Row(
      children: [
        // Word title
        Expanded(
          child: Text(
            word.word,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: style.textColor,
              decoration: word.status == WordStatus.mastered ? TextDecoration.lineThrough : null,
              decorationColor: style.textColor.withValues(alpha: 0.3),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Star toggle button (inline, always visible)
        if (showReviewButton && word.status != WordStatus.mastered)
          _buildStarButton(context, colorScheme),
        if (showReviewButton && word.status != WordStatus.mastered)
          const SizedBox(width: 8),
        // POS badges
        Wrap(
          spacing: 4,
          children: pos.map((p) => PosBadge(pos: p)).toList(),
        ),
      ],
    );
  }

  Widget _buildStarButton(BuildContext context, ColorScheme colorScheme) {
    final isStarred = word.status == WordStatus.studying;
    return GestureDetector(
      onTap: () => _toggleStar(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isStarred ? Colors.amber.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 22,
          color: isStarred ? Colors.amber.shade600 : colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Row 2: Phonetics (compact with colored speaker icons)
  // ────────────────────────────────────────────────────────────
  Widget _buildPhonetics(BuildContext context, ColorScheme colorScheme) {
    if (word.phoneticText.isEmpty && word.phoneticAmText.isEmpty) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        if (word.phoneticText.isNotEmpty)
          _PhoneticChip(
            phonetic: word.phonetic,
            phoneticText: word.phoneticText,
            label: '🇬🇧',
            accentColor: const Color(0xFF3D9F50),
          ),
        if (word.phoneticText.isNotEmpty && word.phoneticAmText.isNotEmpty)
          const SizedBox(width: 10),
        if (word.phoneticAmText.isNotEmpty)
          _PhoneticChip(
            phonetic: word.phoneticAm,
            phoneticText: word.phoneticAmText,
            label: '🇺🇸',
            accentColor: const Color(0xFF9F3D3D),
          ),
      ],
    );
  }

  // ────────────────────────────────────────────────────────────
  // Row 3: Definition (rich text)
  // ────────────────────────────────────────────────────────────
  Widget _buildDefinition(TextTheme textTheme, ColorScheme colorScheme, bool showVi) {
    String text;
    bool isEdited = false;

    if (word.userDefinition != null) {
      text = word.userDefinition!;
      isEdited = true;
    } else if (showVi && word.senses.first.shortMeaningVi.isNotEmpty) {
      text = word.senses.first.shortMeaningVi;
    } else if (showVi && word.senses.first.definitionVi.isNotEmpty) {
      text = word.senses.first.definitionVi;
    } else {
      text = word.senses.first.definition;
    }

    return RichText(
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withValues(alpha: 0.65),
          height: 1.35,
        ),
        children: [
          TextSpan(text: text),
          if (isEdited)
            TextSpan(
              text: ' ✏️',
              style: TextStyle(fontSize: 11, color: colorScheme.primary.withValues(alpha: 0.5)),
            ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────────────────
  // Row 4: Status chip (left) + edit button (right)
  // ────────────────────────────────────────────────────────────
  Widget _buildBottomRow(BuildContext context, TextTheme textTheme, ColorScheme colorScheme, _StatusStyle style) {
    return Row(
      children: [
        // Status chip
        _buildStatusChip(context, textTheme, style),
        const Spacer(),
        // Edit / Undo button
        if (word.status == WordStatus.mastered)
          _buildUndoButton(context, textTheme, colorScheme)
        else
          SvgButton(
            svg: Assets.svgEdit,
            size: 14,
            padding: const EdgeInsets.all(6),
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.06),
            color: colorScheme.onSurface.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(8),
            onPressed: () => _showEditWordDialog(context),
          ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, TextTheme textTheme, _StatusStyle style) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: style.chipBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: style.chipBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(style.chipIcon, size: 13, color: style.chipIconColor),
          const SizedBox(width: 4),
          Text(
            style.chipLabel(context),
            style: textTheme.labelSmall?.copyWith(
              color: style.chipTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUndoButton(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => _masteredWord(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.undo_rounded, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.35)),
            const SizedBox(width: 3),
            Text(
              'Undo',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Callbacks ──────────────────────────────────────────────

  void _toggleStar(BuildContext context) {
    onStar?.call();
    if (viewOnly) return;
    if (word.status == WordStatus.studying) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.unknown));
    } else if (word.status != WordStatus.mastered) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.studying));
    }
  }

  void _masteredWord(BuildContext context) {
    onMastered?.call();
    if (viewOnly) return;
    if (word.status == WordStatus.mastered) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.unknown));
      return;
    }
    context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(word, WordStatus.mastered));
  }

  void _openWordDetails(BuildContext context) {
    if (viewOnly) return;
    context.push(RoutePaths.wordDetails, extra: {'word': word});
  }

  void _showEditWordDialog(BuildContext context) {
    if (viewOnly) return;
    showDialog(
      context: context,
      builder: (_) => UserDefinitionDialog(
        word: word.word,
        alreadyDefined: word.userDefinition != null,
        onSave: (definition) => _onSaveDefinition(context, definition),
      ),
    );
  }

  void _onSaveDefinition(BuildContext context, String? definition) {
    if (definition != null && definition.isEmpty) return;
    context.read<VocabularyBloc>().add(VocabularyEvent.editDefinition(word, definition));
  }
}

// ──────────────────────────────────────────────────────────────
// Phonetic chip — flag + text + speaker icon, tappable
// ──────────────────────────────────────────────────────────────
class _PhoneticChip extends StatefulWidget {
  final String phonetic;
  final String phoneticText;
  final String label;
  final Color accentColor;

  const _PhoneticChip({
    required this.phonetic,
    required this.phoneticText,
    required this.label,
    required this.accentColor,
  });

  @override
  State<_PhoneticChip> createState() => _PhoneticChipState();
}

class _PhoneticChipState extends State<_PhoneticChip> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Phonetic.playSound(widget.phonetic),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.accentColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.accentColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              widget.phoneticText,
              style: TextStyle(
                fontSize: 12.5,
                color: colorScheme.onSurface.withValues(alpha: 0.65),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.volume_up_rounded,
              size: 15,
              color: widget.accentColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Status style configuration per WordStatus
// ──────────────────────────────────────────────────────────────
class _StatusStyle {
  final Color background;
  final List<Color> stripGradient;
  final Color textColor;
  final Color chipBackground;
  final Color chipBorder;
  final IconData chipIcon;
  final Color chipIconColor;
  final Color chipTextColor;
  final String Function(BuildContext) chipLabel;

  const _StatusStyle({
    required this.background,
    required this.stripGradient,
    required this.textColor,
    required this.chipBackground,
    required this.chipBorder,
    required this.chipIcon,
    required this.chipIconColor,
    required this.chipTextColor,
    required this.chipLabel,
  });

  factory _StatusStyle.from(WordStatus status, ColorScheme colorScheme, bool isDark) {
    switch (status) {
      case WordStatus.unknown:
        return _StatusStyle(
          background: isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF5F7FA),
          stripGradient: [
            colorScheme.primary.withValues(alpha: 0.25),
            colorScheme.primary.withValues(alpha: 0.08),
          ],
          textColor: colorScheme.onSurface,
          chipBackground: Colors.transparent,
          chipBorder: colorScheme.onSurface.withValues(alpha: 0.12),
          chipIcon: Icons.fiber_new_rounded,
          chipIconColor: colorScheme.onSurface.withValues(alpha: 0.35),
          chipTextColor: colorScheme.onSurface.withValues(alpha: 0.45),
          chipLabel: (ctx) => L10n.tr(ctx, 'new'),
        );

      case WordStatus.studying:
        return _StatusStyle(
          background: isDark ? const Color(0xFF2D2510) : const Color(0xFFFFF8E1),
          stripGradient: [Colors.amber.shade500, Colors.orange.shade400],
          textColor: isDark ? Colors.amber.shade200 : const Color(0xFF5D4037),
          chipBackground: Colors.amber.withValues(alpha: 0.12),
          chipBorder: Colors.amber.shade300.withValues(alpha: 0.4),
          chipIcon: Icons.star_rounded,
          chipIconColor: Colors.amber.shade600,
          chipTextColor: Colors.amber.shade800,
          chipLabel: (ctx) => L10n.tr(ctx, 'studying'),
        );

      case WordStatus.mastered:
        return _StatusStyle(
          background: isDark ? const Color(0xFF1B2E1B) : const Color(0xFFE8F5E9),
          stripGradient: [Colors.green.shade500, Colors.teal.shade400],
          textColor: isDark ? Colors.green.shade200 : Colors.green.shade900,
          chipBackground: Colors.green.withValues(alpha: 0.12),
          chipBorder: Colors.green.shade300.withValues(alpha: 0.4),
          chipIcon: Icons.check_circle_rounded,
          chipIconColor: Colors.green.shade600,
          chipTextColor: Colors.green.shade700,
          chipLabel: (ctx) => L10n.tr(ctx, 'mastered'),
        );
    }
  }
}
