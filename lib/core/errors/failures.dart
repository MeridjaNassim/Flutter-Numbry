import 'package:equatable/equatable.dart';

/// This class represents an Abstract Failure object thrown by  exceptions

/// @extends Equatable for comparaison purposes

abstract class Failure extends Equatable{
  final List properties ;
  Failure([this.properties]) ;

   @override
  List<Object> get props => properties;

}

// General Failures
/// Failure object when server exception is thrown
class ServerFailure extends Failure {


}
/// Failure object when cache exception is thrown
class CacheFailure extends Failure {
  
}