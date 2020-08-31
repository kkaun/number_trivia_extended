import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class DeleteFavTriviaUseCase implements UseCase<void, FavoriteTrivia> {
  final NumberTriviaRepository repository;

  DeleteFavTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, void>> execute(FavoriteTrivia trivia) async {
    return await repository.deleteFavoriteNumberTrivia(trivia);
  }
}
