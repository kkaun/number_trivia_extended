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

  final Function eq = const ListEquality().equals;
  final tDislikedTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
  final tDislikedEntity = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
  final tFavTriviaModel = NumberTriviaModel(number: 2, text: 'test trivia 2');
  final tFavEntity = FavoriteTrivia(id: 2, triviaNumber: 2, triviaText: 'test trivia 2');
  final tResultList = List<FavoriteTrivia>();
  tResultList.add(tFavEntity);
  tResultList.add(tDislikedEntity);

  test('should ensure that repository doesnt contain recently deleted trivia', () async {
    //arrange
    when(mockNumberTriviaRepository.getAllFavoriteNumberTrivias()).thenAnswer((_) async => Right(tResultList));
    when(mockNumberTriviaRepository.deleteFavoriteNumberTrivia(tDislikedEntity)).thenAnswer((_) async => Right({}));
    //act
    await mockNumberTriviaRepository.insertFavoriteNumberTrivia(tDislikedTriviaModel);
    await mockNumberTriviaRepository.insertFavoriteNumberTrivia(tFavTriviaModel);
    await usecase.execute(tDislikedEntity);
    final listResult = await mockNumberTriviaRepository.getAllFavoriteNumberTrivias();
    //assert
    verify(mockNumberTriviaRepository.insertFavoriteNumberTrivia(tFavTriviaModel));
    verify(mockNumberTriviaRepository.insertFavoriteNumberTrivia(tDislikedTriviaModel));
    verify(mockNumberTriviaRepository.deleteFavoriteNumberTrivia(tDislikedEntity));
    verify(mockNumberTriviaRepository.getAllFavoriteNumberTrivias());
    expect(eq(listResult, tResultList), true);
  });
}
