import 'package:equatable/equatable.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid Input - The number must be a positive integer or zero";
const String INSERT_FAVORITE_FAILURE_MESSAGE = "Failed to insert favorite trivia";
const String GET_ALL_FAVORITE_FAILURE_MESSAGE = "Failed to retrieve favorite trivias";
const String DELETE_FAVORITE_FAILURE_MESSAGE = "Failed to delete favorite trivia";

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
