import 'package:moor_flutter/moor_flutter.dart';

// abstract class FavTrivia {
//   int id;
//   int triviaNumber;
//   String triviaText;
// }

class FavoriteTrivias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get triviaNumber => integer()();
  TextColumn get triviaText => text().withLength(min: 1, max: 700)();
}
