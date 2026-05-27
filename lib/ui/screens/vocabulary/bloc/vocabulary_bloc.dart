import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/word.dart';
import '../../../../data/models/word_status.dart';
import '../../../../data/repositories/oxford_words_repository.dart';
import '../../../../data/repositories/progress_repository.dart';
import '../../../../data/repositories/srs_repository.dart';
import '../../../../utils/achievement_checker.dart';

part 'vocabulary_event.dart';

part 'vocabulary_state.dart';

part 'generated/vocabulary_bloc.freezed.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final OxfordWordsRepository _oxfordWordsRepository;
  final ProgressRepository _progressRepository;
  final SrsRepository _srsRepository;
  final AchievementChecker _achievementChecker;

  VocabularyBloc({
    required OxfordWordsRepository oxfordWordsRepository,
    required ProgressRepository progressRepository,
    required SrsRepository srsRepository,
    required AchievementChecker achievementChecker,
  })  : _oxfordWordsRepository = oxfordWordsRepository,
        _progressRepository = progressRepository,
        _srsRepository = srsRepository,
        _achievementChecker = achievementChecker,
        super(const VocabularyState()) {
    on<VocabularyEvent>((event, emit) async {
      await event.map(
        getAllOxfordWords: (event) => _onGetAllOxfordWords(event, emit),
        changeStatus: (event) => _onChangeStatus(event, emit),
        editDefinition: (event) => _onEditDefinition(event, emit),
        addWordRandomly: (event) => _onAddWordRandomly(event, emit),
        recordSrsReview: (event) => _onRecordSrsReview(event, emit),
      );
    });
  }

  _onGetAllOxfordWords(_GetAllOxfordWords event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: getAllOxfordWords');
    if (state.words.isNotEmpty) {
      debugPrint('VocabularyBloc: words is not empty - skip');
      return;
    }
    final words = _oxfordWordsRepository.getAllOxfordWords();
    
    // Auto-migrate existing studying words into SRS if they aren't already there
    for (final word in words) {
      if (word.status == WordStatus.studying) {
        _srsRepository.scheduleWord(word.index);
      }
    }
    
    debugPrint('VocabularyBloc: getAllOxfordWords - success - words ${words.length}');
    emit(state.copyWith(words: words));
  }

  /// Force reload words from Hive — used after server sync updates Hive statuses.
  /// This is a public method (not an event) to avoid regenerating freezed code.
  void refreshWordsFromHive() {
    debugPrint('VocabularyBloc: refreshWordsFromHive');
    final words = _oxfordWordsRepository.getAllOxfordWords();
    
    // Auto-migrate studying words into SRS
    for (final word in words) {
      if (word.status == WordStatus.studying) {
        _srsRepository.scheduleWord(word.index);
      }
    }
    
    debugPrint('VocabularyBloc: refreshWordsFromHive - ${words.length} words reloaded');
    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(words: words));
  }

  _onChangeStatus(_ChangeStatus event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: changeStatus - word ${event.word.status} - status ${event.status}');
    final newWord = event.word.copyWith(status: event.status);
    final words = state.words.map((word) {
      if (word.word == event.word.word) {
        return newWord;
      }
      return word;
    }).toList();
    _oxfordWordsRepository.saveWord(newWord);
    
    // SRS Syncing + push status to backend
    if (event.status == WordStatus.studying) {
      _srsRepository.scheduleWord(event.word.index);
      _srsRepository.pushWordStatus(event.word.index, event.status.toApiString());
    } else if (event.status == WordStatus.unknown) {
      _srsRepository.removeWord(event.word.index);
      _srsRepository.pushWordStatus(event.word.index, event.status.toApiString());
    } else if (event.status == WordStatus.mastered) {
      _srsRepository.removeWord(event.word.index);
      _srsRepository.pushWordStatus(event.word.index, event.status.toApiString());
    }

    emit(state.copyWith(words: words));
    
    // Achievement checks
    _achievementChecker.checkVocabAchievements(words);
    
    if (event.status == WordStatus.mastered && event.word.status != WordStatus.mastered) {
      _progressRepository.logSession(
        timeSpentSeconds: 0,
        wordsLearned: 1,
        lessonsCompleted: 0,
      );
    }
  }

  _onEditDefinition(_EditDefinition event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: editDefinition - word ${event.word.word} - newDefinition ${event.newDefinition}');
    final word = event.word;
    final newWord = Word(
      status: word.status,
      word: word.word,
      senses: word.senses,
      phoneticAm: word.phoneticAm,
      phoneticText: word.phoneticText,
      phonetic: word.phonetic,
      pos: word.pos,
      index: word.index,
      phoneticAmText: word.phoneticAmText,
      userDefinition: event.newDefinition,
    );
    final words = state.words.map((word) {
      if (word.word == event.word.word) {
        return newWord;
      }
      return word;
    }).toList();
    _oxfordWordsRepository.saveWord(newWord);
    emit(state.copyWith(words: words));
  }

  _onAddWordRandomly(_AddWordRandomly event, Emitter<VocabularyState> emit) {
    debugPrint('VocabularyBloc: addWordRandomly');
    final unknownWords = state.words.where((word) => word.status == WordStatus.unknown).toList()..shuffle();
    final randomWords = unknownWords.take(10);
    for (final word in randomWords) {
      final newWord = word.copyWith(status: WordStatus.studying);
      _oxfordWordsRepository.saveWord(newWord);
      _srsRepository.scheduleWord(word.index);
    }
    emit(state.copyWith(words: state.words.map((word) {
      if (randomWords.contains(word)) {
        return word.copyWith(status: WordStatus.studying);
      }
      return word;
    }).toList()));
  }

  Future<void> _onRecordSrsReview(_RecordSrsReview event, Emitter<VocabularyState> emit) async {
    _srsRepository.recordReview(event.wordIndex, event.correct);

    // Auto-mastery check: if 4+ consecutive correct AND interval >= 7 days
    final srsData = _srsRepository.get(event.wordIndex);
    if (srsData != null && srsData.repetitions >= 4 && srsData.interval >= 7) {
      // Find the word and auto-master it
      final words = state.words.map((w) {
        if (w.index == event.wordIndex) {
          final mastered = w.copyWith(status: WordStatus.mastered);
          _oxfordWordsRepository.saveWord(mastered);
          _srsRepository.removeWord(w.index);
          _srsRepository.pushWordStatus(w.index, WordStatus.mastered.toApiString());
          _progressRepository.logSession(timeSpentSeconds: 0, wordsLearned: 1, lessonsCompleted: 0);
          _achievementChecker.checkVocabAchievements(state.words);
          return mastered;
        }
        return w;
      }).toList();
      emit(state.copyWith(words: words));
    }
  }
}
