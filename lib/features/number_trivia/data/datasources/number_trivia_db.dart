import 'package:moor_flutter/moor_flutter.dart';

part 'number_trivia_db.g.dart';

class FavouriteTrivias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get triviaNumber => integer()();
  TextColumn get triviaText => text().withLength(min: 1, max: 700)();
}

@UseMoor(tables: [FavouriteTrivias], daos: [NumberTriviaDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [FavouriteTrivias])
class NumberTriviaDao extends DatabaseAccessor<AppDatabase> with _$NumberTriviaDaoMixin {
  final AppDatabase db;

  NumberTriviaDao(this.db) : super(db);

  Future<List<FavouriteTrivia>> getAllFavouriteNumberTrivias() => select(favouriteTrivias).get();
  Future<int> insertFavouriteNumberTrivia(FavouriteTrivia trivia) => into(favouriteTrivias).insert(trivia);
  Future deleteFavouriteNumberTrivia(FavouriteTrivia trivia) => delete(favouriteTrivias).delete(trivia);
}
