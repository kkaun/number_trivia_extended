import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfoImpl({@required this.connectionChecker});

  @override
  //we don't have to async/await here, 'cause it's already forwarded
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
