import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedLesson {
  final String id;
  final String title;
  final String passage;
  final List<SavedWord> words;
  final DateTime createdAt;

  SavedLesson({
    required this.id,
    required this.title,
    required this.passage,
    required this.words,
    required this.createdAt,
  });

  int get wordCount => words.length;

  String get passagePreview {
    if (passage.length <= 90) return passage;
    return '${passage.substring(0, 90)}...';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'passage': passage,
        'words': words.map((w) => w.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavedLesson.fromJson(Map<String, dynamic> json) => SavedLesson(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        passage: json['passage'] ?? '',
        words: (json['words'] as List? ?? [])
            .map((w) => SavedWord.fromJson(w))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      );
}

class SavedWord {
  final String word;
  final String? definition;
  final String? example;
  final String? phoneticText;
  final String? phoneticAmText;
  final String? pos;
  final String level;
  final String category;

  SavedWord({
    required this.word,
    this.definition,
    this.example,
    this.phoneticText,
    this.phoneticAmText,
    this.pos,
    required this.level,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'definition': definition,
        'example': example,
        'phoneticText': phoneticText,
        'phoneticAmText': phoneticAmText,
        'pos': pos,
        'level': level,
        'category': category,
      };

  factory SavedWord.fromJson(Map<String, dynamic> json) => SavedWord(
        word: json['word'] ?? '',
        definition: json['definition'],
        example: json['example'],
        phoneticText: json['phoneticText'],
        phoneticAmText: json['phoneticAmText'],
        pos: json['pos'],
        level: json['level'] ?? '',
        category: json['category'] ?? '',
      );
}

class SavedLessonsRepository {
  static const String _key = 'saved_ai_lessons_v2';

  Future<List<SavedLesson>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      final lessons = list.map((e) => SavedLesson.fromJson(e)).toList();
      lessons.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return lessons;
    } catch (_) {
      return [];
    }
  }

  Future<void> save(SavedLesson lesson) async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = await getAll();
    lessons.removeWhere((l) => l.id == lesson.id);
    lessons.insert(0, lesson);
    final toSave = lessons.take(50).toList();
    await prefs.setString(_key, jsonEncode(toSave.map((l) => l.toJson()).toList()));
  }

  Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = await getAll();
    lessons.removeWhere((l) => l.id == id);
    await prefs.setString(_key, jsonEncode(lessons.map((l) => l.toJson()).toList()));
  }
}
