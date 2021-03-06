import 'package:dartz/dartz.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/core/errors/failure.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/repository/document_repository_impl.dart';
import 'package:doc_warehouse/features/domain/repository/document_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentRepository repository;
  late DocumentDataSource datasource;

  setUp(() {
    datasource = MockDocumentDatasource();
    repository = DocumentRepositoryImpl(datasource);
  });

  test('should return Document model and call datasource', () async {
    when(datasource.getAll).thenAnswer((_) async => mockDocumentsModel);

    final result = await repository.getAll();

    expect(result, Right(mockDocumentsModel));
    verify(datasource.getAll).called(1);
  });

  test('should pass name filter to datasource', () async {
    when(() => datasource.getAll(name: any(named: 'name'))).thenAnswer((_) async =>
    mockDocumentsModel);

    final result = await repository.getAll(name: 'nameFilter');

    expect(result, Right(mockDocumentsModel));
    verify(() => datasource.getAll(name: 'nameFilter')).called(1);
  });

  test('should return DatabaseFailure on exception on getDocuments', () async {
    when(datasource.getAll).thenThrow(DatabaseException('Database error'));

    final result = await repository.getAll();

    expect(result, Left(DatabaseFailure('Database error')));
    verify(datasource.getAll).called(1);
  });

  test('should create Document, call datasource and return new Document',
      () async {
    when(() => datasource.create(mockDocumentModel)).thenAnswer((_) async => 1);

    final result = await repository.create(mockDocument);

    expect(result, Right(mockDocumentWithId));
    verify(() => datasource.create(mockDocumentModel)).called(1);
  });

  test('should return DatabaseFailure on exception on create', () async {
    when(() => datasource.create(mockDocumentModel))
        .thenThrow(DatabaseException('Database error'));

    final result = await repository.create(mockDocument);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.create(mockDocumentModel)).called(1);
  });

  test('should update Document, call datasource and return updated Document',
      () async {
    when(() => datasource.update(mockDocumentModelWithId))
        .thenAnswer((_) async {});

    final result = await repository.update(mockDocumentWithId);

    expect(result, Right(mockDocumentWithId));
    verify(() => datasource.update(mockDocumentModelWithId)).called(1);
  });

  test('should throw error when updating Document without id', () async {
    final result = await repository.update(mockDocument);

    expect(result, Left(BusinessFailure('O documento n??o possui ID')));
  });

  test(
      'should throw error when updating Document when datasource returns exception',
      () async {
    when(() => datasource.update(mockDocumentModelWithId))
        .thenThrow(DatabaseException("fake exception"));

    final result = await repository.update(mockDocumentWithId);

    expect(result, Left(DatabaseFailure('fake exception')));
  });

  test('should get Document, call datasource and return new Document',
      () async {
    when(() => datasource.getById(1))
        .thenAnswer((_) async => mockDocumentModelWithId);

    final result = await repository.getById(1);

    expect(result, Right(mockDocumentModelWithId));
    verify(() => datasource.getById(1)).called(1);
  });

  test('should return DatabaseFailure on exception on create', () async {
    when(() => datasource.getById(1))
        .thenThrow(DatabaseException('Database error'));

    final result = await repository.getById(1);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.getById(1)).called(1);
  });

  test('should delete Document with given id', () async {
    when(() => datasource.deleteById(1)).thenAnswer((_) async {});

    final result = await repository.deleteById(1);

    expect(result, Right(null));
    verify(() => datasource.deleteById(1)).called(1);
  });

  test('should return DatabaseFailure on exception on delete', () async {
    when(() => datasource.deleteById(1))
        .thenThrow(DatabaseException('Database error'));

    final result = await repository.deleteById(1);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.deleteById(1)).called(1);
  });

  test('should delete given Documents', () async {
    when(() => datasource.deleteAllById(any())).thenAnswer((_) async {});

    final documentsToDelete = [
      mockDocumentWithId.copyWith(id: 1),
      mockDocumentWithId.copyWith(id: 2)
    ];
    final result = await repository.deleteAll(documentsToDelete);

    expect(result, Right(null));
    verify(() => datasource.deleteAllById([1, 2])).called(1);
  });

  test('should return Failure if a document does not have an id', () async {
    final result = await repository.deleteAll([mockDocumentWithId, mockDocument]);

    expect(result, Left(DatabaseFailure('N??o ?? poss??vel remover documentos sem ID')));
  });

  test('should return DatabaseFailure on exception on delete', () async {
    when(() => datasource.deleteAllById(any()))
        .thenThrow(DatabaseException('Database error'));

    final documentsToDelete = [
      mockDocumentWithId.copyWith(id: 1),
      mockDocumentWithId.copyWith(id: 2)
    ];
    final result = await repository.deleteAll(documentsToDelete);

    expect(result, Left(DatabaseFailure('Database error')));
    verify(() => datasource.deleteAllById([1, 2])).called(1);
  });

  test('should return next id', () async {
    when(() => datasource.getNextId()).thenAnswer((_) async => 1);

    final result = await repository.getNextId();

    expect(result, Right(1));
    verify(() => datasource.getNextId()).called(1);
  });

  test('should return Left on Exception on getNextId', () async {
    when(() => datasource.getNextId()).thenThrow(DatabaseException('This is an exception'));

    final result = await repository.getNextId();

    expect(result, Left(DatabaseFailure('This is an exception')));
    verify(() => datasource.getNextId()).called(1);
  });
}

class MockDocumentDatasource extends Mock implements DocumentDataSource {}
