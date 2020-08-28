import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/constants.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'package:matcher/matcher.dart';
import 'package:collection/collection.dart';

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

  group('addToFavorites', () {
    final tNumber = 1;
    final dbTriviaEntity = FavoriteTrivia(id: 1, triviaNumber: tNumber, triviaText: 'test trivia');

    test('should return trivia number back when adding it to Favorites', () async {
      //arrange
      when(dataSource.insertFavoriteNumberTrivia(any)).thenAnswer((_) async => tNumber);
      //act
      final result = await dataSource.insertFavoriteNumberTrivia(dbTriviaEntity);
      //assert
      verify(dao.insertFavoriteNumberTrivia(dbTriviaEntity));
      expect(result, equals(tNumber));
    });
  });

  group('deleteFromFavorites', () {
    final Function eq = const ListEquality().equals;
    final dislikedTriviaEntity = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
    final favTriviaEntity = FavoriteTrivia(id: 2, triviaNumber: 2, triviaText: 'Test Trivia 2');
    final resultList = List<FavoriteTrivia>();
    resultList.add(favTriviaEntity);

    test('should not find trivia which was deleted from Favorites', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => resultList);
      when(dataSource.deleteFavoriteNumberTrivia(any)).thenAnswer((_) async => {});
      //act
      await dataSource.insertFavoriteNumberTrivia(favTriviaEntity);
      await dataSource.insertFavoriteNumberTrivia(dislikedTriviaEntity);
      await dataSource.deleteFavoriteNumberTrivia(dislikedTriviaEntity);
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.insertFavoriteNumberTrivia(favTriviaEntity));
      verify(dao.insertFavoriteNumberTrivia(dislikedTriviaEntity));
      verify(dao.deleteFavoriteNumberTrivia(dislikedTriviaEntity));
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(resultList, listResult), true);
    });
  });

  group('getAllFavorites', () {
    final Function eq = const ListEquality().equals;
    final favTriviaEntity1 = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
    final favTriviaEntity2 = FavoriteTrivia(id: 2, triviaNumber: 2, triviaText: 'Test Trivia 2');
    final resultList = List<FavoriteTrivia>();
    resultList.add(favTriviaEntity1);
    resultList.add(favTriviaEntity2);

    test('should not find trivia which was deleted from Favorites', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => resultList);
      //act
      await dataSource.insertFavoriteNumberTrivia(favTriviaEntity1);
      await dataSource.insertFavoriteNumberTrivia(favTriviaEntity2);
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.insertFavoriteNumberTrivia(favTriviaEntity1));
      verify(dao.insertFavoriteNumberTrivia(favTriviaEntity2));
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(resultList, listResult), true);
    });
  });
}
