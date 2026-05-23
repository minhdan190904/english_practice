class GeneratedVocab {
  final String word;
  final String meaning;
  final String? meaningVi;
  final String pronunciation;
  final String? phoneticUrl;
  final String? phoneticAmUrl;
  final String example;

  GeneratedVocab({
    required this.word,
    required this.meaning,
    this.meaningVi,
    required this.pronunciation,
    this.phoneticUrl,
    this.phoneticAmUrl,
    required this.example,
  });

  factory GeneratedVocab.fromJson(Map<String, dynamic> json) {
    return GeneratedVocab(
      word: json['word'] ?? '',
      meaning: json['meaning'] ?? '',
      meaningVi: json['meaningVi'],
      pronunciation: json['pronunciation'] ?? '',
      phoneticUrl: json['phoneticUrl'],
      phoneticAmUrl: json['phoneticAmUrl'],
      example: json['example'] ?? '',
    );
  }
}

class LessonResult {
  final String title;
  final String passage;
  final String? passageVi;
  final List<GeneratedVocab> vocabulary;

  LessonResult({
    required this.title,
    required this.passage,
    this.passageVi,
    required this.vocabulary,
  });

  factory LessonResult.fromJson(Map<String, dynamic> json) {
    var list = json['vocabulary'] as List? ?? [];
    List<GeneratedVocab> vocabList = list.map((i) => GeneratedVocab.fromJson(i)).toList();

    return LessonResult(
      title: json['title'] ?? '',
      passage: json['passage'] ?? '',
      passageVi: json['passageVi'],
      vocabulary: vocabList,
    );
  }
}
