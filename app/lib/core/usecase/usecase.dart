import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Input, Output> {

  Future<Either<Failure, Output>> call(Input input);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}