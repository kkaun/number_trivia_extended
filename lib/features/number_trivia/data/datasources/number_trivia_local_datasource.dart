import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:numbers_trivia/core/constants.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel model);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

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
}
