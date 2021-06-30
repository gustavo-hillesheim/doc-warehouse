import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DocumentRepositoryImpl extends DocumentRepository {
  final DocumentDatasource datasource;

  DocumentRepositoryImpl(this.datasource);

  @override
  Future<Either<Failure, List<Document>>> getDocuments() async {
    try {
      return Right(await datasource.getDocuments());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}