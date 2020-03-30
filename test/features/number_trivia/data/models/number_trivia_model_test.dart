import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:learn_clean_archi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number : 1,text :'test_text');
  test(
    'should be subclass of NumberTrivia entity',
    ()async {
    
      // assert
      expect(tNumberTriviaModel,isA<NumberTrivia>());  
    },
  );
  group('fromJson', (){
    test(
      'should return valid model when JSON number is an integer',
      ()async {
        // arrange
        final Map<String,dynamic> jsonMap = json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
     test(
      'should return valid model when JSON model is regarded as double',
      ()async {
        // arrange
        final Map<String,dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group('toJson', (){
    test(
      'should return a JSON map containing proper data',
      ()async {
        // arrange
        
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
            "text": "test_text",
            "number": 1,
        };
        expect(result , expectedMap);
      },
    );
  });
}