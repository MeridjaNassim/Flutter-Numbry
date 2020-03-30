part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => ['empty'];
}
class Loading extends NumberTriviaState {

  @override
  List<Object> get props => ['loading'];
}
class Loaded extends NumberTriviaState {
  
  final NumberTrivia trivia;
  Loaded({this.trivia});
  
  @override
  List<Object> get props => [trivia];

}
class Error extends NumberTriviaState {
  final String errorMessage ;

  Error(this.errorMessage);

  @override
  List<Object> get props => [errorMessage]; 
  
}