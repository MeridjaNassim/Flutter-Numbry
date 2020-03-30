import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/entities/number_trivia.dart';
/// This class is an abstraction of a repository that handles getting number trivias , 
/// created to ensure independace of domain layer from data layer

abstract class NumberTriviaRepository {
  /// Gets a concerete Number Trivia from sources based on [number]
  /// @return Future of either : [Failure] object if operation fails or [NumberTrivia] object if operation succeds

  Future<Either<Failure,NumberTrivia>> getConcreteNumberTrivia(int number) ;
  
   /**
   * Gets a random Number Trivia from sources 
   * @return Future of either : [Failure] object if operation fails or [NumberTrivia] object if operation succeds
   */
  Future<Either<Failure,NumberTrivia>> getRandomNumberTrivia();
}

// We use Either type from dartz to handle exceptions better and not deal with exceptions propagation (its kept in repository)