import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/usecases/usecase.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository{

}
void main() {
  GetRandomNumberTrivia usercase ; 
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp((){
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usercase =  GetRandomNumberTrivia(mockNumberTriviaRepository);
  });
 
  final tNumberTrivia = NumberTrivia(text: 'test', number: 1); 

  test('should get random number trivia from repository',() async {
    // arrange 
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async {
      return Right(tNumberTrivia);
    });
    //act 
    final result = await usercase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}