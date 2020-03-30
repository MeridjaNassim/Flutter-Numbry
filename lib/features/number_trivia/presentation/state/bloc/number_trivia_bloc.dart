import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';
import 'package:learn_clean_archi/core/presentation/util/input_converter.dart';
import 'package:learn_clean_archi/core/usecases/usecase.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../domain/entities/number_trivia.dart';
import 'package:meta/meta.dart';
part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE ="Server failure";
const String CACHE_FAILURE_MESSAGE = "Cache failure";
const String INPUT_INVALID_MESSAGE = "Invalid input , the number must be positive number or 0";


class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({@required GetConcreteNumberTrivia concrete, @required GetRandomNumberTrivia random, @required this.inputConverter}) : 
  assert(concrete != null) , getConcreteNumberTrivia=concrete,
  assert(random != null), getRandomNumberTrivia = random,
  assert(inputConverter != null);

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if(event is GetTriviaForConcreteNumberEvent) {
     final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
     yield* inputEither.fold((failure) async*{
       yield  Error(INPUT_INVALID_MESSAGE);
     }, (value) async*{
       yield Loading();
       final failureOrTrivia =await  getConcreteNumberTrivia(Params(number: value));
       yield* _failureOrTrivia(failureOrTrivia);
     });
    }else if( event is GetTriviaForRandomNumberEvent) {
       yield Loading();
       final failureOrTrivia =await  getRandomNumberTrivia(NoParams());
      yield* _failureOrTrivia(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _failureOrTrivia(Either<Failure, NumberTrivia> failureOrTrivia) async*{
     yield failureOrTrivia.fold((failure){
      return Error(_mapFailureToMessage(failure));
    }, (trivia){
      return Loaded(trivia : trivia );
    });
  }

  String _mapFailureToMessage(Failure failure) {
   switch (failure.runtimeType) {
     case ServerFailure:
       return SERVER_FAILURE_MESSAGE;
       break;
      case CacheFailure : return CACHE_FAILURE_MESSAGE;
     default: return 'Unexpected Error';
   } 
  }
}
