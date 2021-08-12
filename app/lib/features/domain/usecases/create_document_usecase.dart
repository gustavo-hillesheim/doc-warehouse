import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/usecase/usecase.dart';
import 'package:doc_warehouse/core/utils/file_copier.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:flutter/foundation.dart';

class CreateDocumentUseCase extends UseCase<Document, Document> {
  final DocumentRepository repository;
  final FileCopier fileCopier;

  CreateDocumentUseCase(this.repository, this.fileCopier);

  @override
  Future<Either<Failure, Document>> call(Document document) async {
    final nextIdResult = await repository.getNextId();
    if (nextIdResult.isLeft()) {
      return Left((nextIdResult as Left).value);
    }
    final nextId = (nextIdResult as Right).value;
    File? internalFile;
    try {
      internalFile = await fileCopier.createInternalFile(
        sourcePath: document.filePath,
        name: '$nextId',
        deleteSource: true,
      );
    } on Exception catch(e) {
      debugPrint("Could not copy file ${document.filePath}: $e");
      return Left(InternalFailure('Não foi possível copiar o arquivo para o diretório da aplicação'));
    }
    return repository.create(document.copyWith(
      filePath: internalFile.path,
    ));
  }
}
