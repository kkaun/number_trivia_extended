import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:numbers_trivia/core/constants.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_db.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  //For shared prefs cache (currently)
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel model);

  //For local DB cache
  Future<List<FavouriteTrivia>> getAllFavouriteNumberTrivias();
  Future<int> insertFavouriteNumberTrivia(FavouriteTrivia trivia);
  Future deleteFavouriteNumberTrivia(FavouriteTrivia trivia);
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
  Future<int> insertFavouriteNumberTrivia(FavouriteTrivia trivia) async {
    return await dao.insertFavouriteNumberTrivia(trivia);
  }

  @override
  Future deleteFavouriteNumberTrivia(FavouriteTrivia trivia) async {
    return await dao.deleteFavouriteNumberTrivia(trivia);
  }

  @override
  Future<List<FavouriteTrivia>> getAllFavouriteNumberTrivias() async {
    return await dao.getAllFavouriteNumberTrivias();
  }
}
