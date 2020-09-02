import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/delete_fav_trivia.dart';
import '../repositories/number_trivia_repository.dart';
import 'package:collection/collection.dart';

void main() {
  DeleteFavTriviaUseCase usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = DeleteFavTriviaUseCase(mockNumberTriviaRepository);
  });

  //TODO
}
