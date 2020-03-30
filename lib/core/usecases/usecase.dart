import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Abstraction of a Use case of the application that is callable via [call] method
abstract class UseCase<Type, Params> {
  ///  Return a [Future] of either a failure if operation fails or [Type] object if operation succeds
  Future<Either<Failure,Type>> call(Params params);
}

/// Common NoParams object when no parameters are needed for a usecase
class NoParams extends Equatable{
  
  
  NoParams();

  
  @override
  
  List<Object> get props => null;

}