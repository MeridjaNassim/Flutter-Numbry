import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasources/number_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_datasource.dart';
import '../models/number_trivia_model.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();
class NumberTriviaRepositoryImplementation implements NumberTriviaRepository{
  
  final NumberTriviaLocalDataSource localDataSource ; 
  final NumberTriviaRemoteDataSource remoteDataSource ; 
  final NetworkInfo networkInfo ;

  NumberTriviaRepositoryImplementation({@required this.localDataSource, @required this.remoteDataSource, @required this.networkInfo});
  
  
  
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async{
   return await _getTrivia(()=> remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async{

   return await _getTrivia(()=> remoteDataSource.getRandomNumberTrivia());
   
  }
  Future<Either<Failure,NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    
    if( await networkInfo.isConnected){
      try {
        NumberTriviaModel trivia = await getConcreteOrRandom();
        await localDataSource.cacheNumberTrivia(trivia);
        return Right(trivia);
      }on ServerException {
        return Left(ServerFailure());
      }
    
    }else {
     try{
        final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
     } on CacheException {
       return Left(CacheFailure());
     }
    }
  }

}