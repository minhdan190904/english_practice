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
    _LevelInfo('A1', 'Beginner', 'Can understand very basic phrases and expressions. Limited vocabulary.', Colors.green),
    _LevelInfo('A2', 'Elementary', 'Can communicate in simple situations about familiar topics. Basic vocabulary and grammar.', Colors.teal),
    _LevelInfo('B1', 'Intermediate', 'Can deal with most travel and personal situations. Can describe experiences and events.', Colors.blue),
    _LevelInfo('B2', 'Upper-Intermediate', 'Can understand main ideas of complex text. Can interact fluently with native speakers.', Colors.indigo),
    _LevelInfo('C1', 'Advanced', 'Can express ideas fluently and spontaneously. Flexible use of language for social, academic purposes.', Colors.deepPurple),
    _LevelInfo('C2', 'Proficiency', 'Can understand virtually everything heard or read. Can express themselves spontaneously and precisely.', Colors.purple),
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
        title: const Text('Select Your Level', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Your English Level',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Choose the level that best describes your English proficiency.',
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
                child: const Text('Confirm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
