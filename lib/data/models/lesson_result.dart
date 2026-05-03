class GeneratedVocab {
  final String word;
  final String meaning;
  final String pronunciation;
  final String example;

  GeneratedVocab({
    required this.word,
    required this.meaning,
    required this.pronunciation,
    required this.example,
  });

  factory GeneratedVocab.fromJson(Map<String, dynamic> json) {
    return GeneratedVocab(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      pronunciation: json['pronunciation'] ?? '',
      example: json['example'] ?? '',
    );
  }
}

class LessonResult {
  final String title;
  final String passage;
  final List<GeneratedVocab> vocabulary;

  LessonResult({
    required this.title,
    required this.passage,
    required this.vocabulary,
  });

  factory LessonResult.fromJson(Map<String, dynamic> json) {
    var list = json['vocabulary'] as List? ?? [];
    List<GeneratedVocab> vocabList = list.map((i) => GeneratedVocab.fromJson(i)).toList();

    return LessonResult(
      title: json['title'] ?? '',
      passage: json['passage'] ?? '',
      vocabulary: vocabList,
    );
  }
}
