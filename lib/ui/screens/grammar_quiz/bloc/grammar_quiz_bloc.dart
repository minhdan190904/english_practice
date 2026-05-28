import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/grammar_quiz.dart';
import '../../../../data/repositories/grammar_quiz_repository.dart';

part 'grammar_quiz_event.dart';
part 'grammar_quiz_state.dart';

class GrammarQuizBloc extends Bloc<GrammarQuizEvent, GrammarQuizState> {
  final GrammarQuizRepository _repository;

  GrammarQuizBloc({required GrammarQuizRepository repository})
      : _repository = repository,
        super(const GrammarQuizState()) {
    on<LoadQuizEvent>(_onLoadQuiz);
    on<SelectAnswerEvent>(_onSelectAnswer);
    on<SelectWordOrderEvent>(_onSelectWordOrder);
    on<SubmitAnswerEvent>(_onSubmitAnswer);
    on<NextQuestionEvent>(_onNextQuestion);
    on<CompleteQuizEvent>(_onCompleteQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuizEvent event, Emitter<GrammarQuizState> emit) async {
    emit(state.copyWith(status: GrammarQuizStatus.loading, topicId: event.topicId));

    final quiz = await _repository.getQuiz(event.topicId);
    if (quiz == null || quiz.questions.isEmpty) {
      emit(state.copyWith(
        status: GrammarQuizStatus.error,
        errorMessage: 'Không thể tải bài tập. Vui lòng thử lại.',
      ));
      return;
    }

    // Shuffle questions and take max 10
    final questions = List<QuizQuestion>.from(quiz.questions)..shuffle();
    final selected = questions.take(10).toList();

    emit(GrammarQuizState(
      status: GrammarQuizStatus.loaded,
      questions: selected,
      currentIndex: 0,
      selectedAnswer: -1,
      selectedWordOrder: const [],
      isAnswered: false,
      isCorrect: false,
      correctCount: 0,
      totalAnswered: 0,
      topicId: event.topicId,
    ));
  }

  Future<void> _onSelectAnswer(SelectAnswerEvent event, Emitter<GrammarQuizState> emit) async {
    if (state.isAnswered) return;
    emit(state.copyWith(selectedAnswer: event.answerIndex));
  }

  Future<void> _onSelectWordOrder(SelectWordOrderEvent event, Emitter<GrammarQuizState> emit) async {
    if (state.isAnswered) return;
    emit(state.copyWith(selectedWordOrder: event.selectedOrder));
  }

  Future<void> _onSubmitAnswer(SubmitAnswerEvent event, Emitter<GrammarQuizState> emit) async {
    if (state.isAnswered) return;

    final question = state.questions[state.currentIndex];
    bool isCorrect;

    if (question.type == 'word_order') {
      isCorrect = _listEquals(state.selectedWordOrder, question.correctOrder);
    } else {
      isCorrect = state.selectedAnswer == question.correctAnswer;
    }

    emit(state.copyWith(
      status: GrammarQuizStatus.answered,
      isAnswered: true,
      isCorrect: isCorrect,
      correctCount: isCorrect ? state.correctCount + 1 : state.correctCount,
      totalAnswered: state.totalAnswered + 1,
    ));
  }

  Future<void> _onNextQuestion(NextQuestionEvent event, Emitter<GrammarQuizState> emit) async {
    if (state.currentIndex >= state.questions.length - 1) {
      add(const CompleteQuizEvent());
      return;
    }

    emit(state.copyWith(
      status: GrammarQuizStatus.loaded,
      currentIndex: state.currentIndex + 1,
      selectedAnswer: -1,
      selectedWordOrder: const [],
      isAnswered: false,
      isCorrect: false,
    ));
  }

  Future<void> _onCompleteQuiz(CompleteQuizEvent event, Emitter<GrammarQuizState> emit) async {
    emit(state.copyWith(status: GrammarQuizStatus.completed));

    if (state.topicId != null) {
      await _repository.markCompleted(state.topicId!);
    }
  }

  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
