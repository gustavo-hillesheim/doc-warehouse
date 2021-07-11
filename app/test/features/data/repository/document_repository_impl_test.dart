import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/repository/document_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepositoryImpl repository;
  late DocumentDatasource datasource;

  setUp(() {
    datasource = MockDocumentDatasource();
    repository = DocumentRepositoryImpl(datasource);
  });

  test('should return Document model and acll datasource', () async {
    when(datasource.getDocuments).thenAnswer((_) async => mockDocumentsModel);

    final result = await repository.getDocuments();

    expect(result, Right(mockDocumentsModel));
    verify(datasource.getDocuments).called(1);
  });

  test('should return DatabaseFailure on exception on getDocuments', () async {
    when(datasource.getDocuments).thenThrow(DatabaseException('Database error'));

    final result = await repository.getDocuments();

    expect(result, Left(DatabaseFailure('Database error')));
    verify(datasource.getDocuments).called(1);
  });

  test('should create Document, call datasource and return new Document', () async {
    when(() => datasource.create(mockDocumentModel)).thenAnswer((_) async => 1);

    final result = await repository.create(mockDocument);

    expect(result, Right(mockDocumentWithId));
    verify(() => datasource.create(mockDocumentModel)).called(1);
  });

  test('should return DatabaseFailure on exception on create', () async {
    when(() => datasource.create(mockDocumentModel)).thenThrow(DatabaseException('Database error'));

    final result = await repository.create(mockDocument);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.create(mockDocumentModel)).called(1);
  });

  test('should get Document, call datasource and return new Document', () async {
    when(() => datasource.getDocument(1)).thenAnswer((_) async => mockDocumentModelWithId);

    final result = await repository.getDocument(1);

    expect(result, Right(mockDocumentModelWithId));
    verify(() => datasource.getDocument(1)).called(1);
  });

  test('should return DatabaseFailure on exception on create', () async {
    when(() => datasource.getDocument(1)).thenThrow(DatabaseException('Database error'));

    final result = await repository.getDocument(1);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.getDocument(1)).called(1);
  });
}

class MockDocumentDatasource extends Mock implements DocumentDatasource {}
