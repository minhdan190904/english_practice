import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/custom_colors.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../utils/l10n.dart';

import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/selection_area_with_search.dart';
import '../settings/bloc/settings_bloc.dart';
import 'bloc/vocabulary_bloc.dart';
import 'widgets/phonetic.dart';

class WordDetailsScreen extends StatefulWidget {
  final Word word;

  const WordDetailsScreen({super.key, required this.word});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;


    // Read locale to decide which definition language to show
    final locale =
        context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final showVietnamese = locale == 'vi';

    return SelectionAreaWithSearch(
      child: BasePage(
        title: 'Word Details',
        actions: [
          if (widget.word.status != WordStatus.mastered)
            TextButton(
              onPressed: () => _onMastered(context),
              child: Text(
                'Mastered',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Word ────────────────────────────────────────────────
              Text(
                widget.word.word,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ── Part of Speech ───────────────────────────────────────
              Text(
                "A. Class: ${widget.word.pos}",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // ── Phonetic ─────────────────────────────────────────────
              Text(
                "B. Phonetic",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Phonetic(
                      phonetic: widget.word.phonetic,
                      phoneticText: widget.word.phoneticText,
                      backgroundColor: CustomColors.green,
                    ),
                    const SizedBox(height: 8),
                    Phonetic(
                      phonetic: widget.word.phoneticAm,
                      phoneticText: widget.word.phoneticAmText,
                      backgroundColor: CustomColors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              BannerAdWidget(
                paddingVertical: 8,
                paddingHorizontal: 16,
              ),

              // ── Definition ───────────────────────────────────────────
              Text(
                "C. Definition",
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              ...List.generate(widget.word.senses.length, (index) {
                final sense = widget.word.senses[index];

                final shortMeaning = showVietnamese && sense.shortMeaningVi.isNotEmpty
                    ? sense.shortMeaningVi
                    : null;
                final displayDef =
                    (showVietnamese && sense.definitionVi.isNotEmpty)
                        ? sense.definitionVi
                        : sense.definition;

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Short meaning badge (VI only)
                      if (shortMeaning != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${index + 1}. $shortMeaning',
                            style: textTheme.labelMedium?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Full definition
                        Text(
                          displayDef,
                          style: textTheme.bodyMedium,
                        ),
                      ] else
                        Text(
                          '${index + 1}. $displayDef',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (sense.examples.isNotEmpty) ...[
                        Text(L10n.tr(context, 'examples')),
                        const SizedBox(height: 8),
                        ...List.generate(
                          sense.examples.length,
                          (i) {
                            final example = sense.examples[i];
                            return Text(
                              '${i + 1}.${example.cf.isNotEmpty ? ' (${example.cf})' : ''} ${example.x}',
                              style: textTheme.bodyMedium,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _onMastered(BuildContext context) {
    context
        .read<VocabularyBloc>()
        .add(VocabularyEvent.changeStatus(widget.word, WordStatus.mastered));
    Navigator.of(context).pop();
  }
}
