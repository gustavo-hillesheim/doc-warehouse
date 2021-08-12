import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/core/utils/file_deleter.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class DeleteDocumentUseCase extends UseCase<Document, void> {
  final DocumentRepository repository;
  final FileDeleter fileDeleter;

  DeleteDocumentUseCase(this.repository, this.fileDeleter);

  @override
  Future<Either<Failure, void>> call(Document document) async {
    if (document.id == null) {
      return Future.value(Left(BusinessFailure('The document does not have an id')));
    }
    final result = await repository.deleteById(document.id!);
    if (result.isRight()) {
      await fileDeleter.delete(document.filePath);
    }
    return result;
  }
}