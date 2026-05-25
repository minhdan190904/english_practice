import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';

class SelectLevelScreen extends StatefulWidget {
  final String currentLevel;
  const SelectLevelScreen({super.key, required this.currentLevel});

  @override
  State<SelectLevelScreen> createState() => _SelectLevelScreenState();
}

class _SelectLevelScreenState extends State<SelectLevelScreen> {
  late String _selected;

  final List<_LevelInfo> _levels = [
    _LevelInfo('A1', 'Mới bắt đầu (Beginner)', 'Hiểu các cụm từ và cách diễn đạt rất cơ bản. Vốn từ vựng hạn chế.', Colors.green),
    _LevelInfo('A2', 'Sơ cấp (Elementary)', 'Giao tiếp được trong các tình huống đơn giản về chủ đề quen thuộc. Từ vựng và ngữ pháp cơ bản.', Colors.teal),
    _LevelInfo('B1', 'Trung cấp (Intermediate)', 'Xử lý được hầu hết các tình huống khi đi du lịch và đời sống. Có thể miêu tả trải nghiệm và sự kiện.', Colors.blue),
    _LevelInfo('B2', 'Trung cao cấp (Upper-Intermediate)', 'Hiểu được ý chính của các văn bản phức tạp. Có thể giao tiếp trôi chảy với người bản xứ.', Colors.indigo),
    _LevelInfo('C1', 'Cao cấp (Advanced)', 'Diễn đạt ý tưởng trôi chảy và tự nhiên. Sử dụng ngôn ngữ linh hoạt cho mục đích xã hội, học thuật.', Colors.deepPurple),
    _LevelInfo('C2', 'Thành thạo (Proficiency)', 'Hiểu gần như mọi thứ nghe hoặc đọc được. Diễn đạt một cách tự nhiên và chính xác tuyệt đối.', Colors.purple),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.tr(context, 'select_your_level'), style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.tr(context, 'select_your_english_level'),
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(L10n.tr(context, 'choose_level_desc'),
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _levels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final lvl = _levels[i];
                final isSelected = _selected == lvl.code;
                final cardColor = lvl.color;
                return InkWell(
                  onTap: () => setState(() => _selected = lvl.code),
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cardColor.withAlpha(40)
                          : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? cardColor : Colors.grey.withAlpha(50),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 28, height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? cardColor : Colors.grey,
                              width: 2,
                            ),
                            color: isSelected ? cardColor : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${lvl.code} - ${lvl.name}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? cardColor : null,
                                )),
                              const SizedBox(height: 4),
                              Text(lvl.description,
                                style: theme.textTheme.bodySmall?.copyWith(color: isSelected ? cardColor.withAlpha(200) : Colors.grey[600])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(L10n.tr(context, 'confirm'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LevelInfo {
  final String code;
  final String name;
  final String description;
  final Color color;
  const _LevelInfo(this.code, this.name, this.description, this.color);
}
