import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an intger when the string represents an unsigned integer', () async {
      //arrange
      final str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Right(123));
    });
  });

  test('should return a Failure when the string is not an integer', () async {
    //arrange
    final str = 'abc';
    //act
    final result = inputConverter.stringToUnsignedInteger(str);
    //assert
    expect(result, Left(InvalidInputFailure()));
  });

  test('should return Failure when the string is negative integer (API does not hadle that case)', () async {
    //arrange
    final str = '-123';
    //act
    final result = inputConverter.stringToUnsignedInteger(str);
    //assert
    expect(result, Left(InvalidInputFailure()));
  });
}
