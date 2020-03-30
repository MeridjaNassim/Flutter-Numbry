import 'dart:convert';

import 'package:learn_clean_archi/core/errors/exceptions.dart';
import 'package:learn_clean_archi/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:learn_clean_archi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';


class MockSharedPreferences extends Mock implements SharedPreferences{

}

void main() {

  MockSharedPreferences mockSharedPreferences;
  NumberTriviaLocalDataSourceImpl dataSource;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });

  group('getLastNumberTrivia',(){
    final tNumberTriviaModel =NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
      'should return number trivia model from shared preferences when there is one in the cache',
      ()async {
        // arrange
        when(mockSharedPreferences.getString(any))
        .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        
        expect(result,tNumberTriviaModel);
      },
    );
     test(
      'should throw CacheException when there is no cached value',
      ()async {
        // arrange
        when(mockSharedPreferences.getString(any))
        .thenReturn(null);
        // act
        final call =  dataSource.getLastNumberTrivia;
        // assert
        expect(call,throwsA(isInstanceOf<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(text: 'test_text', number: 1);
    test(
      'should call shared preferences to cache the data',
      ()async {
        // arrange
        
        // act
        await dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString =json.encode(tNumberTriviaModel.toJson()); 
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
        
      },
    );
  });

}