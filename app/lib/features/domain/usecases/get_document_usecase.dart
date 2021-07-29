import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class GetDocumentUseCase extends UseCase<int, Document> {
  final DocumentRepository repository;

  GetDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, Document>> call(int id) async {
    final result = await repository.getById(id);
    return result.fold(
      (failure) => Left(failure),
      (document) {
        if (document == null) {
          return Left(BusinessFailure("Could not find document of id $id"));
        }
        return Right(document);
      },
    );
  }
}
