import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:numbers_trivia/core/db/number_trivia_db.dart';
import 'package:numbers_trivia/core/network/network_info.dart';
import 'package:numbers_trivia/core/util/input_converter.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:numbers_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:numbers_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/delete_fav_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_all_fav_trivias.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/domain/usecases/insert_fav_trivia.dart';
import 'package:numbers_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Feature - NumberTrivia
  //Bloc:
  //? Clases requiring cleanup (such as Blocs wich reqiure closing their streams) shouldn't be registered as Singletons!
  //? In other words: If we do some disposal(disposable) logic, we should use factory.
  serviceLocator.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: serviceLocator(),
      getRandomNumberTriviaUseCase: serviceLocator(),
      insertFavoriteTriviaUseCase: serviceLocator(),
      observeAllFavoriteTriviasUseCase: serviceLocator(),
      deleteFavTriviaUseCase: serviceLocator(),
      inputConverter: serviceLocator()));

  //Use Cases:
  serviceLocator.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InsertFavoriteTriviaUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ObserveAllFavoriteTriviasUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteFavTriviaUseCase(serviceLocator()));

  //Repository:
  serviceLocator.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
      remoteDataSource: serviceLocator(), localDataSource: serviceLocator(), networkInfo: serviceLocator()));

  //Data Sources:
  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: serviceLocator()));

  serviceLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: serviceLocator(), dao: serviceLocator()));

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: serviceLocator()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
  //moor db
  serviceLocator.registerLazySingleton(() => AppDatabase());
  serviceLocator.registerLazySingleton(() => NumberTriviaDao(serviceLocator()));
}

//* We're registering dependencies respectively in order by going down our clean architecture invocation chain.
//* In bigger projects we could also divide init() method by sub-methods (like initFeatures() and so on).
