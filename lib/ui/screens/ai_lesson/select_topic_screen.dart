import '../../../../utils/l10n.dart';
import 'package:flutter/material.dart';
import '../../../data/models/sample_passage_response.dart';
import '../../../data/repositories/ai_repository.dart';
import '../../../configs/di.dart';

class SelectTopicScreen extends StatefulWidget {
  final String level;

  const SelectTopicScreen({super.key, required this.level});

  @override
  State<SelectTopicScreen> createState() => _SelectTopicScreenState();
}

class _SelectTopicScreenState extends State<SelectTopicScreen> {
  String _selectedCategoryId = 'technology';
  bool _isLoading = false;

  final List<_CategoryInfo> _categories = [
    _CategoryInfo("technology", "Technology", "💻", "Computers, internet, software, gadgets", Colors.blue),
    _CategoryInfo("science", "Science", "🔬", "Physics, biology, chemistry, discoveries", Colors.teal),
    _CategoryInfo("business", "Business", "💼", "Finance, marketing, management, entrepreneurship", Colors.indigo),
    _CategoryInfo("travel", "Travel", "✈️", "Tourism, cultures, destinations, experiences", Colors.lightBlue),
    _CategoryInfo("work", "Work", "🏢", "Jobs, offices, meetings, careers", Colors.blueGrey),
    _CategoryInfo("daily", "Daily Life", "☀️", "Everyday activities, habits, routines", Colors.orange),
    _CategoryInfo("people", "People", "👥", "Friends, personalities, relationships", Colors.deepOrange),
    _CategoryInfo("family", "Family", "👨‍👩‍👧", "Parents, children, relatives, home life", Colors.pink),
    _CategoryInfo("home", "Home", "🏠", "Rooms, furniture, housework", Colors.brown),
    _CategoryInfo("food", "Food", "🍽️", "Meals, cooking, restaurants, drinks", Colors.redAccent),
    _CategoryInfo("education", "Education", "🎓", "School, study, teachers, exams", Colors.purple),
    _CategoryInfo("health", "Health", "🏥", "Body, medicine, exercise, wellbeing", Colors.red),
    _CategoryInfo("sports", "Sports", "⚽", "Games, teams, training, competitions", Colors.green),
    _CategoryInfo("culture", "Culture", "🎭", "Art, music, traditions, festivals", Colors.deepPurple),
    _CategoryInfo("society", "Society", "🌍", "Community, rules, social issues", Colors.cyan),
    _CategoryInfo("nature", "Nature", "🌿", "Animals, plants, weather, landscapes", Colors.lightGreen),
    _CategoryInfo("environment", "Environment", "♻️", "Climate, pollution, protection, recycling", Colors.green),
    _CategoryInfo("transport", "Transport", "🚗", "Cars, buses, trains, airports", Colors.blueAccent)
  ];

  Future<void> _generateSample() async {
    setState(() => _isLoading = true);
    try {
      final aiRepository = DI().sl<AiRepository>();
      final result = await aiRepository.generateSamplePassage(
        category: _selectedCategoryId,
        level: widget.level,
      );
      if (mounted) {
        // Return full result so caller can get both passage text and words
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(L10n.tr(context, 'could_not_generate_sample'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.tr(context, 'select_topic'), style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a topic for AI to generate a sample passage',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'AI will create an English passage based on your selected topic',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategoryId == cat.id;
                final cardColor = cat.color;
                
                return InkWell(
                  onTap: () {
                    setState(() => _selectedCategoryId = cat.id);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? cardColor.withAlpha(40) : theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? cardColor : Colors.grey.withAlpha(50),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [] : [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(cat.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? cardColor : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cat.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: isSelected ? cardColor.withAlpha(200) : Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: cardColor)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _generateSample,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(L10n.tr(context, 'generate_sample'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryInfo {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final Color color;

  const _CategoryInfo(this.id, this.title, this.emoji, this.description, this.color);
}
