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

class ErrorState extends NumberTriviaState {
  final String errorMessage;

  ErrorState({@required this.errorMessage}) : super([errorMessage]);

  @override
  List<Object> get props => [errorMessage];
}
