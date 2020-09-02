import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/insert_fav_trivia.dart';
import '../repositories/number_trivia_repository.dart';

void main() {
  InsertFavoriteTriviaUseCase usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = InsertFavoriteTriviaUseCase(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should retrieve number for favourite trivia which was recently inserted to repository', () async {
    //arrange
    when(mockNumberTriviaRepository.insertFavoriteNumberTrivia(tNumberTrivia))
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase.execute(tNumberTrivia);
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.insertFavoriteNumberTrivia(tNumberTrivia));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
