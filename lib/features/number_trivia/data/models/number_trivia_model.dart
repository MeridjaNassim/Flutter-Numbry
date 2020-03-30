import '../../domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';
class NumberTriviaModel extends NumberTrivia {
  
  NumberTriviaModel({@required text,@required number}) : super(number : number ,text : text);
  factory NumberTriviaModel.fromJson(Map<String,dynamic> json) {
    return NumberTriviaModel(text: json['text'], number: (json['number'] as num).toInt());
  }
  Map<String,dynamic > toJson(){
    return {
      'text' : text,
      'number' : number
    };
  }
}