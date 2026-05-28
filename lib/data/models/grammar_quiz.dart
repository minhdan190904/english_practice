/// Grammar quiz data model.
/// Contains quiz questions for a grammar topic.
class GrammarQuiz {
  final int topicId;
  final List<QuizQuestion> questions;

  const GrammarQuiz({required this.topicId, required this.questions});

  factory GrammarQuiz.fromJson(Map<String, dynamic> json) {
    return GrammarQuiz(
      topicId: json['topicId'] as int,
      questions: (json['questions'] as List)
          .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// A single quiz question supporting 4 types:
/// fill_in_blank, multiple_choice, sentence_correction, word_order
class QuizQuestion {
  final int id;
  final String type;
  final String? question;
  final String? sentence;
  final List<String> options;
  final List<String> words;
  final int correctAnswer;
  final List<int> correctOrder;
  final String? correctedSentence;
  final String? correctSentence;
  final String? explanation;

  const QuizQuestion({
    required this.id,
    required this.type,
    this.question,
    this.sentence,
    this.options = const [],
    this.words = const [],
    required this.correctAnswer,
    this.correctOrder = const [],
    this.correctedSentence,
    this.correctSentence,
    this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as int,
      type: json['type'] as String,
      question: json['question'] as String?,
      sentence: json['sentence'] as String?,
      options: (json['options'] as List?)?.map((e) => e as String).toList() ?? [],
      words: (json['words'] as List?)?.map((e) => e as String).toList() ?? [],
      correctAnswer: (json['correctAnswer'] as int?) ?? -1,
      correctOrder: (json['correctOrder'] as List?)?.map((e) => e as int).toList() ?? [],
      correctedSentence: json['correctedSentence'] as String?,
      correctSentence: json['correctSentence'] as String?,
      explanation: json['explanation'] as String?,
    );
  }
}
