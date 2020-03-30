import 'package:data_connection_checker/data_connection_checker.dart';
///Abstraction of Network info  utility class
///this class is intended to check for present connection
abstract class NetworkInfo {

  /// Checks weither the underlying device has concrete connection to internet 
  Future<bool> get isConnected;
}

/// Concretion of the NetworkInfo class using DataConnectionChecker from 'package:data_connection_checker/data_connection_checker.dart'
class NetworkInfoImpl implements NetworkInfo {

  final DataConnectionChecker dataConnectionChecker ;
  NetworkInfoImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected  =>  dataConnectionChecker.hasConnection;

}