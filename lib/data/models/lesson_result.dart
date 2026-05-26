import 'sentence_pair.dart';

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
  final String? imageBase64;
  final List<SentencePair>? sentences;

  LessonResult({
    required this.title,
    required this.passage,
    this.passageVi,
    required this.vocabulary,
    this.imageBase64,
    this.sentences,
  });

  factory LessonResult.fromJson(Map<String, dynamic> json) {
    var list = json['vocabulary'] as List? ?? [];
    List<GeneratedVocab> vocabList = list.map((i) => GeneratedVocab.fromJson(i)).toList();

    List<SentencePair>? sentencesList;
    if (json['sentences'] != null) {
      sentencesList = (json['sentences'] as List)
          .map((e) => SentencePair.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return LessonResult(
      title: json['title'] ?? '',
      passage: json['passage'] ?? '',
      passageVi: json['passageVi'],
      vocabulary: vocabList,
      imageBase64: json['imageBase64'],
      sentences: sentencesList,
    );
  }
}
