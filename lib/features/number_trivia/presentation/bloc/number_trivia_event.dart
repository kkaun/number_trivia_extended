part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumberEvent extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumberEvent(this.numberString) : super([numberString]);
}

class GetTriviaForRandomNumberEvent extends NumberTriviaEvent {}

class InsertFavoriteTriviaEvent extends NumberTriviaEvent {
  final NumberTrivia model;

  InsertFavoriteTriviaEvent(this.model) : super([model]);
}

class ObserveAllFavoriteTriviasEvent extends NumberTriviaEvent {}
