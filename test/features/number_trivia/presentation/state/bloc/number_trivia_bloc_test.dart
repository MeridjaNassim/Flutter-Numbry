import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';
import 'package:learn_clean_archi/core/presentation/util/input_converter.dart';
import 'package:learn_clean_archi/core/usecases/usecase.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/presentation/state/bloc/number_trivia_bloc.dart';
import 'package:mockito/mockito.dart';


class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {

}
class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {
  
}

class MockInputConverter extends Mock implements InputConverter {

}

void main() {
  NumberTriviaBloc bloc ;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia ;
  MockInputConverter mockInputConverter;
  setUp((){
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc =NumberTriviaBloc(concrete: mockGetConcreteNumberTrivia, random: mockGetRandomNumberTrivia, inputConverter:mockInputConverter);

  });

  test('initial state should be Empty', (){
    expect(bloc.initialState, Empty());
  });
  
  group('GetTriviaForConcreteNumber', (){
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test_text', number: 1);
    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
         .thenReturn(Right(tNumberParsed));
    }
    test(
      'should call the input converter to validate and convert the string to an unsigned integer',
      ()async {
        // arrange
       setUpMockInputConverterSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );
    test(
      'should emit [Error] state when the input is invalid',
      ()async {
        // arrange
          when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));
           // assert Later
        final expected = [Empty(),Error(INPUT_INVALID_MESSAGE)];
        expectLater(bloc.cast<NumberTriviaState>(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
    test(
      'should get data from the concrete use case',
      ()async {
        // arrange
       setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async=>Right(tNumberTrivia));  
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );
    test(
      'should emit [Loading , Loaded] when data is gotten successfully',
      ()async {
        // arrange
        setUpMockInputConverterSuccess();
         when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async=>Right(tNumberTrivia));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
    test(
      'should emit [Loading , Error] when getting data fails',
      ()async {
        // arrange
        setUpMockInputConverterSuccess();
         when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async=>Left(ServerFailure()));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Error(SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
    test(
      'should emit [Loading , Error] with proper message for the error when getting data fails',
      ()async {
        // arrange
        setUpMockInputConverterSuccess();
         when(mockGetConcreteNumberTrivia(any))
        .thenAnswer((_) async=>Left(CacheFailure()));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Error(CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
        bloc.add(GetTriviaForConcreteNumberEvent(numberString: tNumberString));
      },
    );
  });
   group('GetTriviaForRandomNumber', (){
    
    final tNumberTrivia = NumberTrivia(text: 'test_text', number: 1);
    test(
      'should get data from the random use case',
      ()async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async=>Right(tNumberTrivia));  
        // act
        bloc.add(GetTriviaForRandomNumberEvent());
        await untilCalled(mockGetRandomNumberTrivia(NoParams()));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );
    test(
      'should emit [Loading , Loaded] when data is gotten successfully',
      ()async {
        // arrange
     
      when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async=>Right(tNumberTrivia));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
       bloc.add(GetTriviaForRandomNumberEvent());
      },
    );
    test(
      'should emit [Loading , Error] when getting data fails',
      ()async {
        // arrange
       when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async=>Left(ServerFailure()));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Error(SERVER_FAILURE_MESSAGE)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
       bloc.add(GetTriviaForRandomNumberEvent());
      },
    );
    test(
      'should emit [Loading , Error] with proper message for the error when getting data fails',
      ()async {
        // arrange
     when(mockGetRandomNumberTrivia(any))
        .thenAnswer((_) async=>Left(CacheFailure()));  
        // assertLater
        final expected = [
          Empty(),
          Loading(),
          Error(CACHE_FAILURE_MESSAGE)
        ];
        expectLater(bloc.cast(), emitsInOrder(expected));
        // act
         bloc.add(GetTriviaForRandomNumberEvent());
      },
    );
  });
}