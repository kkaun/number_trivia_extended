import 'package:moor_flutter/moor_flutter.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

part 'number_trivia_db.g.dart';

class FavoriteTrivias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get triviaNumber => integer()();
  TextColumn get triviaText => text().withLength(min: 1, max: 700)();
}

@UseMoor(tables: [FavoriteTrivias], daos: [NumberTriviaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 2;
}

@UseDao(tables: [FavoriteTrivias])
class NumberTriviaDao extends DatabaseAccessor<AppDatabase> with _$NumberTriviaDaoMixin {
  final AppDatabase db;

  NumberTriviaDao(this.db) : super(db);

  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias() => select(favoriteTrivias).get();
  Future<int> insertFavoriteNumberTrivia(FavoriteTrivia trivia) => into(favoriteTrivias).insert(trivia);
  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia) => delete(favoriteTrivias).delete(trivia);
}

class TriviaModelToEntityConverter {
  FavoriteTrivia convertModelToNewFavTriviaEntity(NumberTriviaModel model) {
    return FavoriteTrivia(triviaNumber: model.number, triviaText: model.text);
  }

  NumberTriviaModel convertExistingFavTriviaEntityToModel(FavoriteTrivia trivia) {
    return NumberTriviaModel(number: trivia.triviaNumber, text: trivia.triviaText);
  }
}
