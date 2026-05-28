part of 'grammar_quiz_bloc.dart';

abstract class GrammarQuizEvent extends Equatable {
  const GrammarQuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuizEvent extends GrammarQuizEvent {
  final int topicId;
  const LoadQuizEvent(this.topicId);

  @override
  List<Object?> get props => [topicId];
}

class SelectAnswerEvent extends GrammarQuizEvent {
  final int answerIndex;
  const SelectAnswerEvent(this.answerIndex);

  @override
  List<Object?> get props => [answerIndex];
}

class SelectWordOrderEvent extends GrammarQuizEvent {
  final List<int> selectedOrder;
  const SelectWordOrderEvent(this.selectedOrder);

  @override
  List<Object?> get props => [selectedOrder];
}

class SubmitAnswerEvent extends GrammarQuizEvent {
  const SubmitAnswerEvent();
}

class NextQuestionEvent extends GrammarQuizEvent {
  const NextQuestionEvent();
}

class CompleteQuizEvent extends GrammarQuizEvent {
  const CompleteQuizEvent();
}
