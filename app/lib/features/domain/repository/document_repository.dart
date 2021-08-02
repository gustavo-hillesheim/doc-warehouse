import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';

abstract class DocumentRepository {
  Future<Either<Failure, List<Document>>> getAll();
  Future<Either<Failure, Document?>> getById(int id);
  Future<Either<Failure, Document>> create(Document document);
  Future<Either<Failure, Document>> update(Document document);
  Future<Either<Failure, void>> deleteById(int id);
  Future<Either<Failure, void>> deleteAll(List<Document> documents);
}
