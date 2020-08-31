import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:numbers_trivia/core/error/failures.dart';

import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTriviaUseCase getConcreteNumberTriviaUseCase;
  final GetRandomNumberTriviaUseCase getRandomNumberTriviaUseCase;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required this.getConcreteNumberTriviaUseCase,
    @required this.getRandomNumberTriviaUseCase,
    @required this.inputConverter,
  })  : assert(getConcreteNumberTriviaUseCase != null),
        assert(getRandomNumberTriviaUseCase != null),
        assert(inputConverter != null),
        super(EmptyFieldState());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
      // fold() function accepts two higher-order functions for:
      //-faiure (left side)
      //-success result (right side)
      //, so it covers success and failure case and forces us to cover them both.
      yield* inputEither.fold(
        (failure) async* {
          yield ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE);
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
        (integer) async* {
          yield LoadingState();
          final result = await getConcreteNumberTriviaUseCase.execute(NumberParams(number: integer));
          yield* _getResultOfTriviaRequest(result);
        },
      );
    } else if (event is GetTriviaForRandomNumberEvent) {
      yield LoadingState();
      final result = await getRandomNumberTriviaUseCase.execute(NoParams());
      yield* _getResultOfTriviaRequest(result);
    }
  }

  Stream<NumberTriviaState> _getResultOfTriviaRequest(Either<Failure, NumberTrivia> result) async* {
    yield result.fold(
        (failure) => ErrorState(errorMessage: _mapFailureToMessage(failure)), (trivia) => LoadedState(result: trivia));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
