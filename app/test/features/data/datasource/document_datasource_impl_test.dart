import 'dart:convert';

import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource_impl.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks/document_model_mock.dart';

void main() {
  late DocumentDatasource datasource;
  late AppDatabase database;

  setUp(() {
    database = MockDatabase();
    datasource = DocumentDatasourceImpl(database);
  });

  test('should execute correct query', () async {
    when(() => database.query(any())).thenAnswer((_) async => QueryResult([jsonDecode(documentModelJson)]));

    final result = await datasource.getDocuments();

    expect(result, [DocumentModel(
        id: 1,
        name: "Document Name",
        filePath: "path/to/doc.txt",
        description: "A simple document",
        creationTime: DateTime(2021, 1, 1),
    )]);
    verify(() => database.query("SELECT name, description, filePath, creationTime, tags FROM document")).called(1);
  });

  test('should throw DatabaseException on error', () async {
      when(() => database.query(any())).thenThrow(Exception('lol'));

      try {
        await datasource.getDocuments();
        fail("Should have thrown exception");
      } on Exception catch (e) {
        expect(e, isA<DatabaseException>());
      }
  });
}

class MockDatabase extends Mock implements AppDatabase {}