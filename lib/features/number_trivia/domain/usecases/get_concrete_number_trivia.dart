import 'package:equatable/equatable.dart';
import 'package:learn_clean_archi/core/usecases/usecase.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';
import '../entities/number_trivia.dart';
import 'package:meta/meta.dart';

/// Use Case : getting a number trivia based on a number
/// Dependencie : [NumberTriviaRepository] repository must be injected 
class GetConcreteNumberTrivia implements UseCase<NumberTrivia,Params>{

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
  
  @override
  Future<Either<Failure,NumberTrivia>> call(Params params) async{
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable{
  
  final int number ;

  Params({@required this.number}); 

  @override
  
  List<Object> get props => [number];
}