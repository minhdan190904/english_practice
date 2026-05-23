import 'dart:io';

void main() {
  final Map<String, String> replacements = {
    "Text('Remove Ads')": "Text(L10n.tr(context, 'remove_ads'))",
    "Text('Premium')": "Text(L10n.tr(context, 'premium'))",
    "Text(\"No Ads\"": "Text(L10n.tr(context, 'no_ads')",
    "Text(\"Enjoy our app without any ads\")": "Text(L10n.tr(context, 'enjoy_no_ads'))",
    "Text(\"Support anywhere\"": "Text(L10n.tr(context, 'support_anywhere')",
    "Text(\"Get support from our team\")": "Text(L10n.tr(context, 'get_support'))",
    "Text(\"Best performance\"": "Text(L10n.tr(context, 'best_performance')",
    "Text(\"Our server will prioritize your requests\")": "Text(L10n.tr(context, 'server_prioritize'))",
    "Text(\"Terms\")": "Text(L10n.tr(context, 'terms'))",
    "Text(\"Restore\")": "Text(L10n.tr(context, 'restore'))",
    "Text(\"Policy\")": "Text(L10n.tr(context, 'policy'))",
    "Text(\"Open settings\")": "Text(L10n.tr(context, 'open_settings_btn'))",
    "Text(\"Not now\")": "Text(L10n.tr(context, 'not_now'))",
    "Text(\"Translate\"": "Text(L10n.tr(context, 'translate')",
    "Text(\"More translations (\${extraTranslations.length})\")": "Text('\${L10n.tr(context, 'more_translations')} (\${extraTranslations.length})')",
    "Text(\"Copied to clipboard\")": "Text(L10n.tr(context, 'copied_to_clipboard'))",
    "Text('Created: Today'": "Text(L10n.tr(context, 'created_today')",
    "Text('Report')": "Text(L10n.tr(context, 'report'))",
    "Text('Show more'": "Text(L10n.tr(context, 'show_more')",
    "Text('Practice Now'": "Text(L10n.tr(context, 'practice_now')",
    "Text('Vocabulary List'": "Text(L10n.tr(context, 'vocabulary_list')",
    "Text('Meaning: \${word.definition}'": "Text('\${L10n.tr(context, 'meaning_prefix')}\${word.definition}'",
    "Text('Pronunciation: \${word.phoneticText}'": "Text('\${L10n.tr(context, 'pronunciation_prefix')}\${word.phoneticText}'",
    "Text('Failed to load categories'": "Text(L10n.tr(context, 'failed_to_load_categories')",
    "Text('Failed to load words')": "Text(L10n.tr(context, 'failed_to_load_words'))",
    "Text('No words found in this category.')": "Text(L10n.tr(context, 'no_words_in_category'))",
    "Text('Error generating lesson: \$e')": "Text('\${L10n.tr(context, 'error_generating_lesson')}\$e')",
    "Text(\"Here's your current English level.\"": "Text(L10n.tr(context, 'current_english_level')",
    "Text('Change'": "Text(L10n.tr(context, 'change')",
    "Text('Input text to learn'": "Text(L10n.tr(context, 'input_text_to_learn')",
    "Text('Sample')": "Text(L10n.tr(context, 'sample'))",
    "Text('Create Lesson with AI'": "Text(L10n.tr(context, 'create_lesson_with_ai')",
    "Text('Select Your Level'": "Text(L10n.tr(context, 'select_your_level')",
    "Text('Select Your English Level'": "Text(L10n.tr(context, 'select_your_english_level')",
    "Text('Choose the level that best describes your English proficiency.'": "Text(L10n.tr(context, 'choose_level_desc')",
    "Text('Confirm'": "Text(L10n.tr(context, 'confirm')",
    "Text('Could not generate sample. Please try again.')": "Text(L10n.tr(context, 'could_not_generate_sample'))",
    "Text('Select Topic'": "Text(L10n.tr(context, 'select_topic')",
    "Text('Generate Sample'": "Text(L10n.tr(context, 'generate_sample')",
    "Text('Start learning')": "Text(L10n.tr(context, 'start_learning'))",
    "Text('Next')": "Text(L10n.tr(context, 'next'))",
    "Text(\"Got it!\")": "Text(L10n.tr(context, 'got_it'))",
    "Text(\"Remind me\")": "Text(L10n.tr(context, 'remind_me'))",
    "Text('Save')": "Text(L10n.tr(context, 'save'))",
    "Text(\"Share your streak to get 1 day free trial\")": "Text(L10n.tr(context, 'share_streak_for_trial'))",
    "Text('Startup Errors')": "Text(L10n.tr(context, 'startup_errors'))",
    "Text('OK')": "Text(L10n.tr(context, 'ok'))",
    "Text(\"Examples:\")": "Text(L10n.tr(context, 'examples'))",
    "Text(\"Word Pos: \")": "Text(L10n.tr(context, 'word_pos'))",
    "Text(\"Letter: \")": "Text(L10n.tr(context, 'letter'))",
    "Text(\"Status : \")": "Text(L10n.tr(context, 'status'))",
  };

  final dir = Directory('c:/english_practice/english_practice_client/lib/ui');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    bool modified = false;

    // First replace all strings
    replacements.forEach((key, value) {
      if (content.contains(key)) {
        content = content.replaceAll(key, value);
        modified = true;
      }
    });

    if (modified) {
      // Fix const modifiers
      content = content.replaceAll("const Text(L10n.tr", "Text(L10n.tr");
      content = content.replaceAll("const Text('\${L10n.tr", "Text('\${L10n.tr");
      
      content = content.replaceAll("const Center(child: Text(L10n.tr", "Center(child: Text(L10n.tr");
      content = content.replaceAll("const SnackBar(content: Text(L10n.tr", "SnackBar(content: Text(L10n.tr");
      content = content.replaceAll("const SnackBar(content: Text('\${L10n.tr", "SnackBar(content: Text('\${L10n.tr");
      content = content.replaceAll('const Padding(padding:', 'Padding(padding:'); // in case padding becomes non-const

      // Add import
      int uiIndex = file.path.indexOf('lib\\ui\\');
      if (uiIndex == -1) uiIndex = file.path.indexOf('lib/ui/');
      if (uiIndex != -1) {
        String relativeFromUi = file.path.substring(uiIndex + 7);
        int depth = relativeFromUi.split(RegExp(r'[/\\]')).length - 1;
        String prefix = depth == 0 ? '../../utils/' : '../' * depth + '../../utils/';
        String importStmt = "import '${prefix}l10n.dart';";
        
        if (!content.contains('l10n.dart')) {
          content = importStmt + '\\n' + content;
        }
      }
      file.writeAsStringSync(content);
      print('Modified: \${file.path}');
    }
  }
}
