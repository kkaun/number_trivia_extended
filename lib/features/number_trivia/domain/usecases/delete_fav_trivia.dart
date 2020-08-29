import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class DeleteFavTriviaUseCase implements UseCase<void, Params> {
  @override
  Future<Either<Failure, void>> execute(Params params) {
    // TODO: implement execute
    throw UnimplementedError();
  }
}
