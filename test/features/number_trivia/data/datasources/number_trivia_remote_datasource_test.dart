import 'dart:convert';
import 'package:learn_clean_archi/core/errors/exceptions.dart';
import 'package:learn_clean_archi/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

import 'package:learn_clean_archi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {

}

void main() {

 MockHttpClient mockHttpClient;
 NumberTriviaRemoteDataSourceImpl datasource ; 
  setUp((){
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDataSourceImpl(mockHttpClient);
   
  });
  void arrangeTest(String text, int statuscode) {
     when(mockHttpClient.get(any,headers: anyNamed('headers')))
        .thenAnswer((_) async =>  http.Response(text,statuscode));
  }
  void setUpHttpResponseWithSuccess200(){
    arrangeTest(fixture('trivia.json'), 200);
  }
  void setUpHttpResponseWithFailure400(){
    arrangeTest('something went wrong', 400);
  }
  group('getConcreteNumberTrivia',(){
    final tNumber = 1;
    final tNumberTriviaModel =NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perform a GET request on the url with number being in the endpoint with header application/json ',
      ()async {
        // arrange
       setUpHttpResponseWithSuccess200();
        // act
        await datasource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockHttpClient.get('http://numbersapi.com/$tNumber',headers:{
          'Content-Type' :'application/json'
        }));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      ()async {
        // arrange
      setUpHttpResponseWithSuccess200();
        // act
        final result = await datasource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result,tNumberTriviaModel);
      },
    );
    test(
      'should throw a ServerException when the response code is not 200',
      ()async {
        // arrange
        setUpHttpResponseWithFailure400();
        // act
        final call = datasource.getConcreteNumberTrivia;
        // assert
        expect(()=>call(tNumber), throwsA(isA<ServerException>()));
      },
    );
   
  });

  group('getRandomNumberTrivia', (){
    
    final tNumberTriviaModel =NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perform a GET request on the url (random) with header application/json ',
      ()async {
        // arrange
       setUpHttpResponseWithSuccess200();
        // act
        await datasource.getRandomNumberTrivia();
        // assert
        verify(mockHttpClient.get('http://numbersapi.com/random',headers:{
          'Content-Type' :'application/json'
        }));
      },
    );

    test(
      'should return NumberTriviaModel when the response code is 200',
      ()async {
        // arrange
      setUpHttpResponseWithSuccess200();
        // act
        final result = await datasource.getRandomNumberTrivia();
        // assert
        expect(result,tNumberTriviaModel);
      },
    );
    test(
      'should throw a ServerException when the response code is not 200',
      ()async {
        // arrange
        setUpHttpResponseWithFailure400();
        // act
        final call = datasource.getRandomNumberTrivia;
        // assert
        expect(call, throwsA(isA<ServerException>()));
      },
    );
  });

}