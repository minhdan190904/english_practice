import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_practice/utils/app_snack_bar.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/lesson_bloc.dart';
import 'widget/home_item.dart';
import '../../../utils/l10n.dart';

import '../../../data/models/grammar_data.dart';
import '../settings/bloc/settings_bloc.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<SettingsBloc>().state.settingsSnapshot.locale;
    final sourceCategories = locale == 'vi' ? grammarCategoriesVi : grammarCategoriesEn;

    final queriedCategories = query.isNotEmpty
        ? sourceCategories.where((element) {
            return element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.description.toLowerCase().contains(query.toLowerCase());
          }).toList()
        : sourceCategories;

    return BlocConsumer<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state.message != null) {
          AppSnackBar.showSuccess(context, state.message!);
        }

        if (state.error != null) {
          AppSnackBar.showError(context, state.error!);
        }
      },
      builder: (context, state) {
        final categories = queriedCategories.map((category) {
          final total = category.lessons.length;
          final progress = category.lessons.where((element) => state.markedLessons[element.id] ?? false).length;
          return category.copyWith(progress: progress, total: total);
        }).toList();
        return BasePage(
          title: L10n.tr(context, 'grammar'),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: HomeItem(
                      category: categories[index],
                    ),
                  ),
                  if (index == 1)
                    BannerAdWidget(
                      paddingVertical: 16,
                      paddingHorizontal: 16,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
