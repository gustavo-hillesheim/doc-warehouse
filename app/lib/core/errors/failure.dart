import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  String get message;
}

class BusinessFailure extends Failure {
  final String message;

  BusinessFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class DatabaseFailure extends Failure {
  final String message;

  DatabaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class InternalFailure extends Failure {
  final String message;

  InternalFailure(this.message);

  @override
  List<Object?> get props => [message];
}
