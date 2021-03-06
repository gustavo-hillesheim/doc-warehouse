import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DocumentRepositoryImpl extends DocumentRepository {
  final DocumentDataSource datasource;

  DocumentRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Document>>> getAll({String? name}) async {
    try {
      final result = await datasource.getAll(name: name);
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Document>> create(Document document) async {
    try {
      final result = await datasource.create(DocumentModel.fromDocument(document));
      return Right(document.copyWith(
        id: result,
      ));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Document>> update(Document document) async {
    if (document.id == null) {
      return Left(BusinessFailure("O documento não possui ID"));
    }
    try {
      await datasource.update(DocumentModel.fromDocument(document));
      return Right(document.copyWith());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Document>> getById(int id) async {
    try {
      final document = await datasource.getById(id);
      return Right(document);
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteById(int id) async {
    try {
      await datasource.deleteById(id);
      return Right(null);
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAll(List<Document> documents) async {
    final ids = <int>[];
    for (final document in documents) {
      if (document.id == null) {
        return Left(DatabaseFailure('Não é possível remover documentos sem ID'));
      } else {
        ids.add(document.id!);
      }
    }
    try {
      await datasource.deleteAllById(ids);
      return Right(null);
    } on DatabaseException catch(e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, int>> getNextId() async {
    try {
      return Right(await datasource.getNextId());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}