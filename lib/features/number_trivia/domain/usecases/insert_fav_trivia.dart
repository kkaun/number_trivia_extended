import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class InsertFavoriteTriviaUseCase implements UseCase<NumberTrivia, NumberTrivia> {
  final NumberTriviaRepository repository;

  InsertFavoriteTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> execute(NumberTrivia model) {
    return repository.insertFavoriteNumberTrivia(model);
  }
}
