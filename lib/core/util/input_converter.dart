import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      int parsedNumber = int.parse(str);
      if (parsedNumber.isNegative) return Left(InvalidInputFailure());
      return Right(parsedNumber);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
