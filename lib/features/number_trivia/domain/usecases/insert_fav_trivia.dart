import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class InsertFavoriteTriviaUseCase implements UseCase<FavoriteTrivia, Params> {
  @override
  Future<Either<Failure, FavoriteTrivia>> execute(Params params) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
