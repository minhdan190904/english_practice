import 'sentence_pair.dart';

class SamplePassageResponse {
  final String title;
  final String passage;
  final String? passageVi;
  final List<SelectedWord> selectedWords;
  final String category;
  final String level;
  final int wordCount;
  final String? imageBase64;
  final List<SentencePair>? sentences;

  SamplePassageResponse({
    required this.title,
    required this.passage,
    this.passageVi,
    required this.selectedWords,
    required this.category,
    required this.level,
    required this.wordCount,
    this.imageBase64,
    this.sentences,
  });

  factory SamplePassageResponse.fromJson(Map<String, dynamic> json) {
    List<SentencePair>? sentencesList;
    if (json['sentences'] != null) {
      sentencesList = (json['sentences'] as List)
          .map((e) => SentencePair.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return SamplePassageResponse(
      title: json['title'] ?? '',
      passage: json['passage'] ?? '',
      passageVi: json['passageVi'],
      selectedWords: (json['selectedWords'] as List?)
              ?.map((e) => SelectedWord.fromJson(e))
              .toList() ??
          [],
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      wordCount: json['wordCount'] ?? 0,
      imageBase64: json['imageBase64'],
      sentences: sentencesList,
    );
  }
}

class SelectedWord {
  final String word;
  final String level;
  final String category;
  final String? pos;
  final String? definition;
  final String? definitionVi;
  final String? shortMeaningVi;
  final String? example;
  final String? phoneticText;
  final String? phoneticAmText;
  final String? phoneticUrl;
  final String? phoneticAmUrl;

  SelectedWord({
    required this.word,
    required this.level,
    required this.category,
    this.pos,
    this.definition,
    this.definitionVi,
    this.shortMeaningVi,
    this.example,
    this.phoneticText,
    this.phoneticAmText,
    this.phoneticUrl,
    this.phoneticAmUrl,
  });

  factory SelectedWord.fromJson(Map<String, dynamic> json) {
    return SelectedWord(
      word: json['word'] ?? '',
      level: json['level'] ?? '',
      category: json['category'] ?? '',
      pos: json['pos'],
      definition: json['definition'],
      definitionVi: json['definitionVi'],
      shortMeaningVi: json['shortMeaningVi'],
      example: json['example'],
      phoneticText: json['phoneticText'],
      phoneticAmText: json['phoneticAmText'],
      phoneticUrl: json['phoneticUrl'],
      phoneticAmUrl: json['phoneticAmUrl'],
    );
  }
}
