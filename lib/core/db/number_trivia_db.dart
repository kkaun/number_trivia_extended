import 'package:moor_flutter/moor_flutter.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/favorite_trivia.dart';

part 'number_trivia_db.g.dart';

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

  Future<NumberTriviaModel> insertFavoriteNumberTrivia(NumberTriviaModel model, [int testId]) async {
    final id = testId == null ? null : testId;
    final converted = FavoriteTrivia(id: id, triviaNumber: model.number, triviaText: model.text);
    await into(favoriteTrivias).insert(converted);
    return model;
  }

  Stream<List<FavoriteTrivia>> observeAllFavoriteNumberTrivias() => select(favoriteTrivias).watch();
  Future<List<FavoriteTrivia>> getAllFavoriteNumberTrivias() => select(favoriteTrivias).get();

  Future deleteFavoriteNumberTrivia(FavoriteTrivia trivia) => delete(favoriteTrivias).delete(trivia);

  Future<FavoriteTrivia> getById(int id) {
    return (select(favoriteTrivias)..where((favTrivia) => favTrivia.id.equals(id))).getSingle();
  }
}
