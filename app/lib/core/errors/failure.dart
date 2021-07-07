import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  String get message;
}

class DatabaseFailure extends Failure {

  final String message;

  DatabaseFailure(this.message);

  @override
  List<Object?> get props => [message];
}