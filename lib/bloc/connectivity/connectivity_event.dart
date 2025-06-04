import 'package:equatable/equatable.dart';

abstract class ConnectivityEvent extends Equatable {
  const ConnectivityEvent();

  @override
  List<Object> get props => [];
}

class ConnectivityStatusChanged extends ConnectivityEvent {
  final dynamic connectivityResult;

  const ConnectivityStatusChanged(this.connectivityResult);

  @override
  List<Object> get props => [connectivityResult.hashCode];
}

class CheckConnectivity extends ConnectivityEvent {}
