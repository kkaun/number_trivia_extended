import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/constants.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_db.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockDao extends Mock implements NumberTriviaDao {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockDao dao;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dao = MockDao();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences, dao: dao);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(mockSharedPreferences.getString(SHARED_PREFS_CACHED_NUMBER_TRIVIA_STR));
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw CacheException when there is no cached value', () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(SHARED_PREFS_CACHED_NUMBER_TRIVIA_STR, expectedJsonString));
    });
  });

  group('addToFavourites', () {
    final tNumber = 1;
    final dbTriviaEntity = FavouriteTrivia(id: 1, triviaNumber: tNumber, triviaText: 'test trivia');

    test('should return trivia number back when adding it to favourites', () async {
      //arrange
      when(dataSource.insertFavouriteNumberTrivia(any)).thenAnswer((_) async => tNumber);
      //act
      final result = await dataSource.insertFavouriteNumberTrivia(dbTriviaEntity);
      //assert
      verify(dao.insertFavouriteNumberTrivia(dbTriviaEntity));
      expect(result, equals(tNumber));
    });
  });

  group('deleteFromFavourites', () {
    final dislikedTriviaEntity = FavouriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
    final favTriviaEntity = FavouriteTrivia(id: 2, triviaNumber: 2, triviaText: 'Test Trivia 2');
    final resultList = List<FavouriteTrivia>();
    resultList.add(favTriviaEntity);

    test('should not find trivia which was deleted from favourites', () async {
      //arrange
      when(dataSource.getAllFavouriteNumberTrivias()).thenAnswer((_) async => resultList);
      when(dataSource.deleteFavouriteNumberTrivia(any)).thenAnswer((_) async => {});
      //act
      await dataSource.insertFavouriteNumberTrivia(favTriviaEntity);
      await dataSource.insertFavouriteNumberTrivia(dislikedTriviaEntity);
      await dataSource.deleteFavouriteNumberTrivia(dislikedTriviaEntity);
      final listResult = await dataSource.getAllFavouriteNumberTrivias();
      //assert
      verify(dao.insertFavouriteNumberTrivia(favTriviaEntity));
      verify(dao.insertFavouriteNumberTrivia(dislikedTriviaEntity));
      verify(dao.deleteFavouriteNumberTrivia(dislikedTriviaEntity));
      verify(dao.getAllFavouriteNumberTrivias());
      expect(listResult.length, 1);
      expect(listResult, equals(resultList));
    });
  });
}
