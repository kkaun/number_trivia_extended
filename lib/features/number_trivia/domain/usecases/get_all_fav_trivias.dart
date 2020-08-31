import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class GetAllFavoriteTrivias implements UseCase<List<FavoriteTrivia>, NoParams> {
  final NumberTriviaRepository repository;

  GetAllFavoriteTrivias(this.repository);

  @override
  Future<Either<Failure, List<FavoriteTrivia>>> execute(NoParams noParams) async {
    return await repository.getAllFavoriteNumberTrivias();
  }
}
