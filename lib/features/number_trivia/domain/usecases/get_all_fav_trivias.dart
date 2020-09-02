import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/usecase.dart';

class ObserveAllFavoriteTriviasUseCase implements UseCase<Stream<List<FavoriteTrivia>>, NoParams> {
  final NumberTriviaRepository repository;

  ObserveAllFavoriteTriviasUseCase(this.repository);

  @override
  Future<Either<Failure, Stream<List<FavoriteTrivia>>>> execute(NoParams noParams) async {
    return await repository.observeAllFavoriteNumberTrivias();
  }
}
