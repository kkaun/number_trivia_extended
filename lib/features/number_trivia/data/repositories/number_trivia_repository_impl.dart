import 'package:flutter/foundation.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/error/exceptions.dart';
import 'package:numbers_trivia/core/network/network_info.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomNumberChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.remoteDataSource, @required this.localDataSource, @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(_ConcreteOrRandomNumberChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> insertFavoriteNumberTrivia(NumberTrivia trivia) async {
    try {
      return Right(await localDataSource.insertFavoriteNumberTrivia(trivia));
    } on InvalidDataException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<List<FavoriteTrivia>>>> observeAllFavoriteNumberTrivias() async {
    try {
      return Right(localDataSource.observeAllFavoriteNumberTrivias());
    } on Error {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteFavoriteNumberTrivia(FavoriteTrivia trivia) async {
    try {
      return Right(await localDataSource.deleteFavoriteNumberTrivia(trivia));
    } on Error {
      return Left(CacheFailure());
    }
  }
}
