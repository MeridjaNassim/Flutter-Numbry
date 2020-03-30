import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// call : https://numbersapi.com/[number] endpoint
  /// @return Future of [NumberTriviaModel] on success or  throws exception
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) ;
  
   /**
   * call : https://numbersapi.com/random endpoint
   * @return Future of [NumberTriviaModel] on success or  throws [ServerException]
   */
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient ;

  NumberTriviaRemoteDataSourceImpl(this.httpClient); 

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number)async{
   
   return await _getNumberTriviaFromUrl('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    
    return await _getNumberTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getNumberTriviaFromUrl(String url) async {
     
    final result = await httpClient.get(url,headers: {
       'Content-Type' :'application/json'
     });
    
    if(result.statusCode == 200) return NumberTriviaModel.fromJson(json.decode(result.body));
    else {
      throw ServerException();
    }
  }

}