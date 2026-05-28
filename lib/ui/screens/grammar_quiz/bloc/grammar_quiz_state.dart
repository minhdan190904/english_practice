part of 'grammar_quiz_bloc.dart';

enum GrammarQuizStatus {
  loading,
  loaded,
  answering,
  answered,
  completed,
  error,
}

class GrammarQuizState extends Equatable {
  final GrammarQuizStatus status;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int selectedAnswer;
  final List<int> selectedWordOrder;
  final bool isAnswered;
  final bool isCorrect;
  final int correctCount;
  final int totalAnswered;
  final int? topicId;
  final String? errorMessage;

  const GrammarQuizState({
    this.status = GrammarQuizStatus.loading,
    this.questions = const [],
    this.currentIndex = 0,
    this.selectedAnswer = -1,
    this.selectedWordOrder = const [],
    this.isAnswered = false,
    this.isCorrect = false,
    this.correctCount = 0,
    this.totalAnswered = 0,
    this.topicId,
    this.errorMessage,
  });

  GrammarQuizState copyWith({
    GrammarQuizStatus? status,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? selectedAnswer,
    List<int>? selectedWordOrder,
    bool? isAnswered,
    bool? isCorrect,
    int? correctCount,
    int? totalAnswered,
    int? topicId,
    String? errorMessage,
  }) {
    return GrammarQuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      selectedWordOrder: selectedWordOrder ?? this.selectedWordOrder,
      isAnswered: isAnswered ?? this.isAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      correctCount: correctCount ?? this.correctCount,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      topicId: topicId ?? this.topicId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        questions,
        currentIndex,
        selectedAnswer,
        selectedWordOrder,
        isAnswered,
        isCorrect,
        correctCount,
        totalAnswered,
        topicId,
        errorMessage,
      ];
}
