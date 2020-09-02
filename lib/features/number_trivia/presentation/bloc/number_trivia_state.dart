part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];
}

class EmptyFieldState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class LoadedState extends NumberTriviaState {
  final NumberTrivia result;

  LoadedState({@required this.result}) : super([result]);

  @override
  List<Object> get props => [result];
}

class InsertFavoriteTriviaState extends NumberTriviaState {
  final NumberTrivia trivia;

  InsertFavoriteTriviaState({@required this.trivia}) : super([trivia]);

  @override
  List<Object> get props => [trivia];
}

class ObserveAllFavoriteTrviasState extends NumberTriviaState {
  final Stream<List<FavoriteTrivia>> favTriviaStream;

  ObserveAllFavoriteTrviasState(this.favTriviaStream);

  @override
  List<Object> get props => [favTriviaStream];
}

class DeleteFavoriteTriviaState extends NumberTriviaState {
  final int number;

  DeleteFavoriteTriviaState({@required this.number}) : super([number]);

  @override
  List<Object> get props => [number];
}

class ErrorState extends NumberTriviaState {
  final String errorMessage;

  ErrorState({@required this.errorMessage}) : super([errorMessage]);

  @override
  List<Object> get props => [errorMessage];
}
