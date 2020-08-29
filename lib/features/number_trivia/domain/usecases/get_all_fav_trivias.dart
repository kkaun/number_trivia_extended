import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class GetAllFavorileTrivias implements UseCase<List<FavoriteTrivia>, Params> {
  @override
  Future<Either<Failure, List<FavoriteTrivia>>> execute(Params params) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
