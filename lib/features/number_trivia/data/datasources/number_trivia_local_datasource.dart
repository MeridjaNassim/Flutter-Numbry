import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';
///Abstraction of the Local Datasource for number Trivia objects
abstract class NumberTriviaLocalDataSource {


  /// Gets the latest cached [NumberTriviaModel] from cache local memory
  /// Throws [CacheException] if no cached data is present 
  Future<NumberTriviaModel> getLastNumberTrivia();
   /// Caches [triviaToCache] to local memory cache 
   /// Throws [CacheException] if some error occurs
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) ;
}

const CACHED_NUMBER_TRIVIA = "CACHED_NUMBER_TRIVIA";
class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);


  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString == null) throw CacheException();
    return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  


}