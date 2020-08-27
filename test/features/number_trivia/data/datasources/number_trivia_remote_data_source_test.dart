import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:http/http.dart' as http;
import 'package:matcher/matcher.dart';
import 'package:numbers_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    void setUpMockHttpClientSuccessResponseCode() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
    }

    void setUpMockHttpClientFailureResponseCode() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
    }

    test('''should perform a GET request on a URL with number being the endpoint 
    & with application/json header''', () async {
      //arrange
      /// 'anyNamed()': An argument matcher that matches any named argument passed in for the
      /// parameter named [named].
      setUpMockHttpClientSuccessResponseCode();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/$tNumber', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return NumberTrivia when the response status code is 200', () async {
      //arrange
      setUpMockHttpClientSuccessResponseCode();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the answer status is 404 or other', () async {
      //arrange
      setUpMockHttpClientFailureResponseCode();
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    void setUpMockHttpClientSuccessResponseCode() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
    }

    void setUpMockHttpClientFailureResponseCode() {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
    }

    test('''should perform a GET request on a random number URL  
    & with application/json header''', () async {
      //arrange
      /// 'anyNamed()': An argument matcher that matches any named argument passed in for the
      /// parameter named [named].
      setUpMockHttpClientSuccessResponseCode();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(mockHttpClient.get('http://numbersapi.com/random', headers: {
        'Content-Type': 'application/json',
      }));
    });

    test('should return NumberTrivia when the response status code is 200', () async {
      //arrange
      setUpMockHttpClientSuccessResponseCode();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw ServerException when the answer status is 404 or other', () async {
      //arrange
      setUpMockHttpClientFailureResponseCode();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
