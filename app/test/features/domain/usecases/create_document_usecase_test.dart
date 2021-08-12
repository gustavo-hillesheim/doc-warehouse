import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/core/utils/file_copier.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:doc_warehouse/features/domain/usecases/create_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepository repository;
  late FileCopier fileCopier;
  late CreateDocumentUseCase usecase;

  setUp(() {
    fileCopier = MockFileCopier();
    repository = MockDocumentRepository();
    usecase = CreateDocumentUseCase(repository, fileCopier);
  });

  void mockFileCopier(File returnFile) {
    when(() => fileCopier.createInternalFile(
            sourcePath: any(named: 'sourcePath'),
            name: any(named: 'name'),
            deleteSource: any(named: 'deleteSource')))
        .thenAnswer((_) async => returnFile);
  }

  void mockFileCopierThrow(Exception exception) {
    when(() => fileCopier.createInternalFile(
        sourcePath: any(named: 'sourcePath'),
        name: any(named: 'name'),
        deleteSource: any(named: 'deleteSource'))).thenThrow(exception);
  }

  void mockRepositoryCreate(
      Document expectedParam, Either<Failure, Document> returnEither) {
    when(() => repository.create(expectedParam))
        .thenAnswer((_) async => returnEither);
  }

  void mockRepositoryGetNextId(Either<Failure, int> nextId) {
    when(() => repository.getNextId()).thenAnswer((_) async => nextId);
  }

  test('should save document in repository and return created object',
      () async {
    mockRepositoryGetNextId(Right(1));
    mockRepositoryCreate(
        mockDocument, Right<Failure, Document>(mockDocumentWithId));
    mockFileCopier(File(mockDocument.filePath));

    final result = await usecase(mockDocument);

    expect(result, Right(mockDocumentWithId));
    verify(() => repository.getNextId()).called(1);
    verify(() => fileCopier.createInternalFile(
        sourcePath: mockDocument.filePath,
        name: '1',
        deleteSource: true)).called(1);
    verify(() => repository.create(mockDocument)).called(1);
  });

  test('should return Failure on getNextId error', () async {
    mockRepositoryGetNextId(Left(DatabaseFailure("Could not query next id")));

    final result = await usecase(mockDocument);

    expect(result, Left(DatabaseFailure("Could not query next id")));
    verify(() => repository.getNextId()).called(1);
    verifyNever(() => fileCopier.createInternalFile(
        sourcePath: any(named: 'sourcePath'),
        name: any(named: 'name'),
        deleteSource: any(named: 'deleteSource')));
    verifyNever(() => repository.create(mockDocument));
  });

  test('should return Failure on fileCopier error', () async {
    mockRepositoryGetNextId(Right(1));
    mockFileCopierThrow(Exception('Could not copy file'));

    final result = await usecase(mockDocument);

    expect(result, isA<Left<Failure, Document>>());
    verify(() => repository.getNextId()).called(1);
    verify(() => fileCopier.createInternalFile(
        sourcePath: mockDocument.filePath,
        name: '1',
        deleteSource: true)).called(1);
    verifyNever(() => repository.create(mockDocument));
  });

  test('should return Failure on repository error', () async {
    mockRepositoryGetNextId(Right(1));
    mockRepositoryCreate(mockDocument, Left(FakeFailure()));
    mockFileCopier(File(mockDocument.filePath));

    final result = await usecase(mockDocument);

    expect(result, Left(FakeFailure()));
    verify(() => repository.getNextId()).called(1);
    verify(() => fileCopier.createInternalFile(
        sourcePath: mockDocument.filePath,
        name: '1',
        deleteSource: true)).called(1);
    verify(() => repository.create(mockDocument)).called(1);
  });
}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockFileCopier extends Mock implements FileCopier {}

class FakeFailure extends Failure {
  final String message = 'fake message';

  @override
  List<Object?> get props => [];
}
