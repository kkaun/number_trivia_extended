import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:numbers_trivia/core/constants.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  //For shared prefs cache (currently)
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel model);

  //For local DB cache
  Stream<List<FavoriteTrivia>> observeAllFavoriteNumberTrivias();
  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias();
  Future<NumberTriviaModel> insertFavoriteNumberTrivia(NumberTriviaModel trivia, [int testId]);
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia);
  Future<FavoriteTrivia> getByDBId(int dbId);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  final NumberTriviaDao dao;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences, @required this.dao});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(SHARED_PREFS_CACHED_NUMBER_TRIVIA_STR);
    if (jsonString != null) {
      //we're returning Future because more complex implementations mostly use Future-based data
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel model) {
    return sharedPreferences.setString(SHARED_PREFS_CACHED_NUMBER_TRIVIA_STR, json.encode(model.toJson()));
  }

  @override
  Future<NumberTriviaModel> insertFavoriteNumberTrivia(NumberTriviaModel model, [int testId]) {
    if (testId == null) {
      return dao.insertFavoriteNumberTrivia(model);
    } else {
      return dao.insertFavoriteNumberTrivia(model, testId);
    }
  }

  @override
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia) {
    return dao.deleteFavoriteNumberTrivia(trivia);
  }

  @override
  Stream<List<FavoriteTrivia>> observeAllFavoriteNumberTrivias() {
    return dao.observeAllFavoriteNumberTrivias();
  }

  @override
  Future<FavoriteTrivia> getByDBId(int dbId) {
    return dao.getById(dbId);
  }

  @override
  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias() {
    return dao.getAllFavoriteNumberTrivias();
  }
}
