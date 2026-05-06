class SamplePassageResponse {
  final String title;
  final String passage;
  final List<SelectedWord> selectedWords;
  final String category;
  final String level;
  final int wordCount;

  SamplePassageResponse({
    required this.title,
    required this.passage,
    required this.selectedWords,
    required this.category,
    required this.level,
    required this.wordCount,
  });

  factory SamplePassageResponse.fromJson(Map<String, dynamic> json) {
    return SamplePassageResponse(
      title: json['title'] ?? '',
      passage: json['passage'] ?? '',
      selectedWords: (json['selectedWords'] as List?)
              ?.map((e) => SelectedWord.fromJson(e))
              .toList() ??
          [],
      category: json['category'] ?? '',
      level: json['level'] ?? '',
      wordCount: json['wordCount'] ?? 0,
    );
  }
}

class SelectedWord {
  final String word;
  final String level;
  final String category;
  final String? pos;
  final String? definition;
  final String? example;
  final String? phoneticText;
  final String? phoneticAmText;

  SelectedWord({
    required this.word,
    required this.level,
    required this.category,
    this.pos,
    this.definition,
    this.example,
    this.phoneticText,
    this.phoneticAmText,
  });

  factory SelectedWord.fromJson(Map<String, dynamic> json) {
    return SelectedWord(
      word: json['word'] ?? '',
      level: json['level'] ?? '',
      category: json['category'] ?? '',
      pos: json['pos'],
      definition: json['definition'],
      example: json['example'],
      phoneticText: json['phoneticText'],
      phoneticAmText: json['phoneticAmText'],
    );
  }
}
