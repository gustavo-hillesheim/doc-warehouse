import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/core/utils/file_copier.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';

class UpdateDocumentUseCase extends UseCase<Document, Document> {

  final DocumentRepository repository;
  final FileCopier fileCopier;

  UpdateDocumentUseCase(this.repository, this.fileCopier);

  @override
  Future<Either<Failure, Document>> call(Document document) async {
    final existingDocumentResult = await repository.getById(document.id!);
    if (existingDocumentResult.isLeft()) {
      return Left((existingDocumentResult as Left).value);
    }
    final existingDocument = (existingDocumentResult as Right).value as Document;
    if (existingDocument.filePath != document.filePath) {
      await fileCopier.createInternalFile(
          sourcePath: document.filePath,
          name: '${document.id!}',
          deleteSource: true
      );
    }
    return repository.update(document);
  }

}