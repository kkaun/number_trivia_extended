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
  //MockTriviaConverter triviaConverter;

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
    final tDBTriviaModel = NumberTriviaModel(number: tNumber, text: 'test trivia');

    final Function eq = const ListEquality().equals;
    final tFavTriviaModel1 = NumberTriviaModel(number: 1, text: 'test trivia for 1');
    final tFavTriviaModel2 = NumberTriviaModel(number: 1, text: 'another test trivia  for 1');
    final tFavTriviaEntity1 = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia for 1');
    final tFavTriviaEntity2 = FavoriteTrivia(id: 2, triviaNumber: 1, triviaText: 'another test trivia  for 1');
    final tDuplicatedNumList = List<FavoriteTrivia>();
    tDuplicatedNumList.add(tFavTriviaEntity1);
    tDuplicatedNumList.add(tFavTriviaEntity2);

    test('should return trivia number back when adding it to Favorites', () async {
      //arrange
      when(dataSource.insertFavoriteNumberTrivia(any)).thenAnswer((_) async => tNumber);
      //act
      final result = await dataSource.insertFavoriteNumberTrivia(tDBTriviaModel);
      //assert
      verify(dao.insertFavoriteNumberTrivia(tDBTriviaModel));
      expect(result, equals(tNumber));
    });

    test('should be able to store several favorite trivias with same numbers (but with different texts)', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => tDuplicatedNumList);
      //act
      await dataSource.insertFavoriteNumberTrivia(tFavTriviaModel1);
      await dataSource.insertFavoriteNumberTrivia(tFavTriviaModel2);
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.insertFavoriteNumberTrivia(tFavTriviaModel1));
      verify(dao.insertFavoriteNumberTrivia(tFavTriviaModel2));
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(tDuplicatedNumList, listResult), true);
      expect(listResult[0].triviaNumber, equals(tDuplicatedNumList[0].triviaNumber));
      expect(listResult[1].triviaNumber, equals(tDuplicatedNumList[1].triviaNumber));
    });
  });

  group('deleteFromFavorites', () {
    final Function eq = const ListEquality().equals;
    final tDislikedTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    final tDislikedEntity = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
    final tFavTriviaModel = NumberTriviaModel(number: 2, text: 'test trivia 2');
    final tFavEntity = FavoriteTrivia(id: 2, triviaNumber: 2, triviaText: 'test trivia 2');
    final int tDislikedId = 1;
    final int tFavId = 2;
    final tResultList = List<FavoriteTrivia>();
    tResultList.add(tFavEntity);

    test('should not find trivia which was deleted from Favorites', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => tResultList);
      when(dataSource.deleteFavoriteNumberTrivia(any)).thenAnswer((_) async => {});
      //act
      await dataSource.insertFavoriteNumberTrivia(tFavTriviaModel, tFavId);
      await dataSource.insertFavoriteNumberTrivia(tDislikedTriviaModel, tDislikedId);
      await dataSource.deleteFavoriteNumberTrivia(tDislikedEntity);
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.insertFavoriteNumberTrivia(tFavTriviaModel, tFavId));
      verify(dao.insertFavoriteNumberTrivia(tDislikedTriviaModel, tDislikedId));
      verify(dao.deleteFavoriteNumberTrivia(tDislikedEntity));
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(tResultList, listResult), true);
    });
  });

  group('getAllFavorites', () {
    final Function eq = const ListEquality().equals;
    final tFavTriviaModel1 = NumberTriviaModel(number: 1, text: 'test trivia');
    final tFavTriviaModel2 = NumberTriviaModel(number: 2, text: 'test trivia 2');
    final tFavTriviaEntity1 = FavoriteTrivia(id: 1, triviaNumber: 1, triviaText: 'test trivia');
    final tFavTriviaEntity2 = FavoriteTrivia(id: 2, triviaNumber: 2, triviaText: 'test trivia 2');
    final tResultList = List<FavoriteTrivia>();
    tResultList.add(tFavTriviaEntity1);
    tResultList.add(tFavTriviaEntity2);
    final emptyResultList = List<FavoriteTrivia>();

    test('should contain the same data set when getting all fav trivias', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => tResultList);
      //act
      await dataSource.insertFavoriteNumberTrivia(tFavTriviaModel1);
      await dataSource.insertFavoriteNumberTrivia(tFavTriviaModel2);
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.insertFavoriteNumberTrivia(tFavTriviaModel1));
      verify(dao.insertFavoriteNumberTrivia(tFavTriviaModel2));
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(tResultList, listResult), true);
    });

    test('should return empty list when no trivia was added to favorites', () async {
      //arrange
      when(dataSource.getAllFavoriteNumberTrivias()).thenAnswer((_) async => emptyResultList);
      //act
      final listResult = await dataSource.getAllFavoriteNumberTrivias();
      //assert
      verify(dao.getAllFavoriteNumberTrivias());
      expect(eq(listResult, emptyResultList), true);
    });
  });
}
