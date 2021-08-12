import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/utils/file_copier.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/update_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late UpdateDocumentUseCase usecase;
  late FileCopier fileCopier;
  late DocumentRepository repository;

  setUp(() {
    fileCopier = MockFileCopier();
    repository = MockDocumentRepository();
    usecase = UpdateDocumentUseCase(repository, fileCopier);
  });

  void mockFileCopier(File returnFile) {
    when(() => fileCopier.createInternalFile(
            sourcePath: any(named: 'sourcePath'),
            name: any(named: 'name'),
            deleteSource: any(named: 'deleteSource')))
        .thenAnswer((_) async => returnFile);
  }

  test('Should call repository to update Document', () async {
    mockFileCopier(File('fake'));
    when(() => repository.getById(mockDocumentWithId.id!))
        .thenAnswer((_) async => Right(mockDocumentWithId.copyWith(filePath: 'another_file.txt')));
    when(() => repository.update(mockDocumentWithId))
        .thenAnswer((_) async => Right(mockDocumentWithId));

    final result = await usecase(mockDocumentWithId);

    expect(result, Right(mockDocumentWithId));
    verify(() => fileCopier.createInternalFile(
        sourcePath: mockDocumentWithId.filePath,
        name: '${mockDocumentWithId.id}',
        deleteSource: true)).called(1);
    verify(() => repository.update(mockDocumentWithId)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockFileCopier extends Mock implements FileCopier {}
