import 'dart:convert';

import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../mocks/document_model_mock.dart';

void main() {

  test('should be subclass of Document', () {
    expect(documentModelMock, isA<Document>());
  });

  test('should convert JSON to model', () {
    final expectedResult = DocumentModel(
      id: 1,
      name: "Document Name",
      filePath: "path/to/doc.txt",
      description: "A simple document",
      creationTime: DateTime(2021, 1, 1),
    );

    final jsonModel = json.decode(mockDocumentModelJson);
    final result = DocumentModel.fromJson(jsonModel);

    expect(result, equals(expectedResult));
  });

  test('should convert model to JSON', () {
    final expectedResult = {
      "id": null,
      "name": "document",
      "filePath": "path/to/document",
      "description": "Description",
      "creationTime": "2021-12-06 00:00:00.000",
    };

    final result = documentModelMock.toJson();

    expect(result, expectedResult);
  });
}

final documentModelMock = DocumentModel(
  name: 'document',
  filePath: 'path/to/document',
  creationTime: DateTime(2021, 12, 06),
  description: 'Description',
);
