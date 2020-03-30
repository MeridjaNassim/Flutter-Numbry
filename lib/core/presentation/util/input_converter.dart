import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';

class InputConverter {
  Either<Failure,int> stringToUnsignedInteger(String str) {
      try{
        final integer = int.parse(str);
        return integer >= 0 ? Right(integer) : throw FormatException();
      } on FormatException {
        return Left(InvalidInputFailure());
      }
     
  }
}

class InvalidInputFailure extends Failure {

}