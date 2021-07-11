import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DocumentRepositoryImpl extends DocumentRepository {
  final DocumentDatasource datasource;

  DocumentRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Document>>> getAll() async {
    try {
      final result = await datasource.getAll();
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
}