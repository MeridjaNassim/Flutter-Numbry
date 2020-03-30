import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:learn_clean_archi/core/network/network_info.dart';
import 'package:learn_clean_archi/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:learn_clean_archi/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/presentation/state/bloc/number_trivia_bloc.dart';

import 'core/presentation/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
final sl = GetIt.instance;
Future<void> init() async {

  //! Features - Number Trivia Feature
  //bloc should always be created as factory 
  sl.registerFactory(()=> NumberTriviaBloc(concrete: sl(), random: sl(), inputConverter: sl())
  );

  // usecases 
  sl.registerLazySingleton(()=>GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(()=> GetRandomNumberTrivia(sl()));

  // repository ;
  sl.registerLazySingleton<NumberTriviaRepository>(()=> NumberTriviaRepositoryImplementation(localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));
  // data sources 
   sl.registerLazySingleton<NumberTriviaRemoteDataSource>(()=> NumberTriviaRemoteDataSourceImpl(sl()));
    sl.registerLazySingleton<NumberTriviaLocalDataSource>(()=> NumberTriviaLocalDataSourceImpl(sl()));
  // networkInfo 
  sl.registerLazySingleton<NetworkInfo>(()=> NetworkInfoImpl(sl()));
  //! Core
  sl.registerLazySingleton(()=> InputConverter());
  //! External 

  sl.registerLazySingleton<http.Client>(()=> http.Client());
  final sharedpref = await SharedPreferences.getInstance();
  sl.registerLazySingleton(()  =>  sharedpref );

  sl.registerLazySingleton(()  =>  DataConnectionChecker() );

}
