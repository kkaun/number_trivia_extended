import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();

  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias();
  Future<Either<Failure, int>> insertFavoriteNumberTrivia(NumberTrivia trivia);
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia);
}
