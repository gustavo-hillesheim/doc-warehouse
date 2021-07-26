import 'dart:convert';

import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentDataSource datasource;
  late AppDatabase database;

  setUp(() {
    database = MockDatabase();
    datasource = DocumentDataSourceImpl(database);
  });

  test('should execute correct query on getAll', () async {
    when(() => database.query(any())).thenAnswer(
        (_) async => QueryResult([jsonDecode(mockDocumentModelJson)]));

    final result = await datasource.getAll();

    expect(result, [mockDocumentModelJsonInstance]);
    verify(() => database.query(
            "SELECT id, name, description, filePath, creationTime FROM documents"))
        .called(1);
  });

  test('should throw DatabaseException on error on getAll', () async {
    when(() => database.query(any())).thenThrow(Exception('lol'));

    try {
      await datasource.getAll();
      fail("Should have thrown exception");
    } on Exception catch (e) {
      expect(e, isA<DatabaseException>());
    }
  });

  test('should execute correct insert SQL', () async {
    when(() => database.insert(any(), any()))
        .thenAnswer((_) async => InsertResult(id: 1));

    final result = await datasource.create(mockDocumentModel);

    expect(result, 1);
    verify(() => database.insert(
            'INSERT INTO documents '
            '(name, description, filePath, creationTime) VALUES (?, ?, ?, ?)',
            [
              mockDocumentModel.name,
              mockDocumentModel.description,
              mockDocumentModel.filePath,
              mockDocumentModel.creationTime.toIso8601String()
            ])).called(1);
  });

  test('should throw DatabaseException on error on create', () async {
    when(() => database.insert(any(), any())).thenThrow(Exception('lol'));

    try {
      await datasource.create(mockDocumentModel);
      fail("Should have thrown exception");
    } on Exception catch (e) {
      expect(e, isA<DatabaseException>());
    }
  });

  test('should execute correct query on getById', () async {
    when(() => database.query(any(), any())).thenAnswer(
        (_) async => QueryResult([jsonDecode(mockDocumentModelJson)]));

    final result = await datasource.getById(1);

    expect(result, mockDocumentModelJsonInstance);
    verify(() => database.query(
        "SELECT name, description, filePath, creationTime FROM documents WHERE id = ?",
        [1])).called(1);
  });

  test('should throw DatabaseException on error on getById', () async {
    when(() => database.query(any(), any())).thenThrow(Exception('lol'));

    try {
      await datasource.getById(1);
      fail("Should have thrown exception");
    } on Exception catch (e) {
      expect(e, isA<DatabaseException>());
    }
  });

  test('should execute correct query on deleteById', () async {
    when(() => database.delete(any(), any())).thenAnswer((_) async {});

    await datasource.deleteById(1);

    verify(() => database.delete("DELETE FROM documents WHERE id = ?", [1]))
        .called(1);
  });

  test('should throw DatabaseException on error on deleteById', () async {
    when(() => database.delete(any(), any())).thenThrow(Exception('lol'));

    try {
      await datasource.deleteById(1);
      fail("Should have thrown exception");
    } on Exception catch (e) {
      expect(e, isA<DatabaseException>());
    }
  });
}

class MockDatabase extends Mock implements AppDatabase {}
