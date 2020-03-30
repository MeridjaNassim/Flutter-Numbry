import 'package:dartz/dartz.dart';
import 'package:learn_clean_archi/core/errors/exceptions.dart';
import 'package:learn_clean_archi/core/errors/failures.dart';
import 'package:learn_clean_archi/core/network/network_info.dart';
import 'package:learn_clean_archi/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:learn_clean_archi/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:learn_clean_archi/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:learn_clean_archi/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:learn_clean_archi/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';


class MockRemoteDataSource extends Mock implements NumberTriviaRemoteDataSource{

}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource{
  
}
class MockNetworkInfo extends Mock implements NetworkInfo {

}



void main() {
  NumberTriviaRepository repository;
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockNetworkInfo = MockNetworkInfo();
    mockLocalDataSource =MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = NumberTriviaRepositoryImplementation(
      remoteDataSource : mockRemoteDataSource,
      localDataSource : mockLocalDataSource,
      networkInfo : mockNetworkInfo
     );
  });
  void runTestOnline(Function body) {
     group('device is online', (){
      setUp((){
         when(mockNetworkInfo.isConnected)
        .thenAnswer((_)async => true);
        });

        body();
        
        }  
      );
  }
  void runTestOffline(Function body) {
     group('device is offline', (){
      setUp((){
         when(mockNetworkInfo.isConnected)
        .thenAnswer((_)async => false);
        });
        
        body();
        
        }  
      );
  }
  group('getConcreteNumberTrivia',(){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if device is online',
      ()async {
        // arrange
        when(mockNetworkInfo.isConnected)
        .thenAnswer((_)async => true);

        // act
        repository.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    runTestOnline((){
        test(
        'should return remote data when the call to remote datasource is successful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
       test(
        'should cache data locally when the call to remote data source is successful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );
       test(
        'should return server failure when the call to remote data sources is unsuccessful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline((){
      test(
        'should return last locally cached data when the cached data is present',
        ()async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async=> tNumberTriviaModel);
          // act
           final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when no last cached data is present',
        ()async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
          // act
           final result = await repository.getConcreteNumberTrivia(tNumber);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
  group('getRandomNumberTrivia',(){
  
    final tNumberTriviaModel = NumberTriviaModel(text: 'test', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test(
      'should check if device is online',
      ()async {
        // arrange
        when(mockNetworkInfo.isConnected)
        .thenAnswer((_)async => true);

        // act
        repository.getRandomNumberTrivia();
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );
    runTestOnline((){
        test(
        'should return remote data when the call to remote datasource is successful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );
       test(
        'should cache data locally when the call to remote data source is successful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verify(mockLocalDataSource.cacheNumberTrivia(tNumberTrivia));
        },
      );
       test(
        'should return server failure when the call to remote data sources is unsuccessful',
        ()async {
          // arrange
          when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenThrow(ServerException());
          // act
          final result = await repository.getRandomNumberTrivia();
          // assert
          verify(mockRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline((){
      test(
        'should return last locally cached data when the cached data is present',
        ()async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenAnswer((_) async=> tNumberTriviaModel);
          // act
           final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'should return cache failure when no last cached data is present',
        ()async {
          // arrange
          when(mockLocalDataSource.getLastNumberTrivia())
          .thenThrow(CacheException());
          // act
           final result = await repository.getRandomNumberTrivia();
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
  
}