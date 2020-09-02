import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/delete_fav_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_all_fav_trivias.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/insert_fav_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTriviaUseCase extends Mock implements GetConcreteNumberTriviaUseCase {}

class MockGetRandomNumberTriviaUseCase extends Mock implements GetRandomNumberTriviaUseCase {}

class MockInsertFavoriteTriviaUseCase extends Mock implements InsertFavoriteTriviaUseCase {}

class MockGetAllFavoriteTriviasUseCase extends Mock implements ObserveAllFavoriteTriviasUseCase {}

class MockDeleteFavTriviaUseCase extends Mock implements DeleteFavTriviaUseCase {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTriviaUseCase mockGetConcreteNumberTriviaUseCase;
  MockGetRandomNumberTriviaUseCase mockGetRandomNumberTriviaUseCase;
  MockInsertFavoriteTriviaUseCase mockInsertFavoriteTriviaUseCase;
  MockGetAllFavoriteTriviasUseCase mockGetAllFavoriteTriviasUseCase;
  MockDeleteFavTriviaUseCase mockDeleteFavTriviaUseCase;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    mockInsertFavoriteTriviaUseCase = MockInsertFavoriteTriviaUseCase();
    mockGetAllFavoriteTriviasUseCase = MockGetAllFavoriteTriviasUseCase();
    mockDeleteFavTriviaUseCase = MockDeleteFavTriviaUseCase();

    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: mockGetConcreteNumberTriviaUseCase,
      getRandomNumberTriviaUseCase: mockGetRandomNumberTriviaUseCase,
      insertFavoriteTriviaUseCase: mockInsertFavoriteTriviaUseCase,
      observeAllFavoriteTriviasUseCase: mockGetAllFavoriteTriviasUseCase,
      deleteFavTriviaUseCase: mockDeleteFavTriviaUseCase,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be EmptyFieldState', () async {
    //arrange
    expect(bloc.state, equals(EmptyFieldState()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Right(tNumberParsed));

    test('should call InputConverter to validate and convert the string to an unsigned integer', () async {
      //arrange
      setUpMockInputConverterSuccess();
      //This is to prevent null pointer after test passes!
      when(mockGetConcreteNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      //we're awaiting for stringToUnsignedInteger() call with the help of mockito's untilCalled()
      //because events arriving to bloc's sink need some time to be executed
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      //assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [ErrorState] when an input is invalid', () async {
      //arrange
      when(mockInputConverter.stringToUnsignedInteger(any)).thenReturn(Left(InvalidInputFailure()));
      //assert later--- is before 'act' part, because adding an event is safer to do in the end of a test
      //in last bloc version initial state on subscription is not emeitted, so we're skipping [EmptyFieldState]
      final expectedStateList = [ErrorState(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockGetConcreteNumberTriviaUseCase.execute(any));
      //assert
      verify(mockGetConcreteNumberTriviaUseCase.execute(NumberParams(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] states when data is gotten successfully', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expectedStateList = [LoadingState(), LoadedState(result: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] states when getting data fails with a server failure', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expectedStateList = [LoadingState(), ErrorState(errorMessage: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] with a proper error message (for cache/server errors respectively)', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expectedStateList = [LoadingState(), ErrorState(errorMessage: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    test('should get data from the random use case', () async {
      //arrange
      when(mockGetRandomNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
      await untilCalled(mockGetRandomNumberTriviaUseCase.execute(any));
      //assert
      verify(mockGetRandomNumberTriviaUseCase.execute(NoParams()));
    });

    test('should emit [Loading, Loaded] states when data is gotten successfully', () async {
      //arrange
      when(mockGetRandomNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Right(tNumberTrivia));
      //assert later
      final expectedStateList = [LoadingState(), LoadedState(result: tNumberTrivia)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] states when getting data fails with a server failure', () async {
      //arrange
      when(mockGetRandomNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Left(ServerFailure()));
      //assert later
      final expectedStateList = [LoadingState(), ErrorState(errorMessage: SERVER_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] with a proper error message (for cache/server errors respectively)', () async {
      //arrange
      when(mockGetRandomNumberTriviaUseCase.execute(any)).thenAnswer((_) async => Left(CacheFailure()));
      //assert later
      final expectedStateList = [LoadingState(), ErrorState(errorMessage: CACHE_FAILURE_MESSAGE)];
      expectLater(bloc, emitsInOrder(expectedStateList));
      //act
      bloc.add(GetTriviaForRandomNumberEvent());
    });
  });
}
