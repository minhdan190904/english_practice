import 'dart:io';

void main() {
  final dir = Directory('c:/english_practice/english_practice_client/lib/ui');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    
    // Only process files that use L10n.tr but don't import l10n.dart
    if (content.contains('L10n.tr') && !content.contains('l10n.dart')) {
      String normalizedPath = file.path.replaceAll('\\', '/');
      int uiIndex = normalizedPath.indexOf('lib/ui/');
      if (uiIndex != -1) {
        String relativeFromUi = normalizedPath.substring(uiIndex + 7);
        int depth = relativeFromUi.split('/').length - 1;
        String prefix = depth == 0 ? '../../utils/' : '../' * depth + '../../utils/';
        String importStmt = "import '${prefix}l10n.dart';";
        
        content = importStmt + '\n' + content;
        file.writeAsStringSync(content);
        print('Added import to: \${normalizedPath}');
      }
    }
  }
}
