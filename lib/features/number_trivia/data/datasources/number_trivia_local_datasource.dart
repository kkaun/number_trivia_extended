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
  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias();
  Future<int> insertFavoriteNumberTrivia(FavoriteTrivia trivia);
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia);
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
  Future<int> insertFavoriteNumberTrivia(FavoriteTrivia trivia) async {
    return await dao.insertFavoriteNumberTrivia(trivia);
  }

  @override
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia) async {
    return await dao.deleteFavoriteNumberTrivia(trivia);
  }

  @override
  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias() async {
    return await dao.getAllFavoriteNumberTrivias();
  }
}
