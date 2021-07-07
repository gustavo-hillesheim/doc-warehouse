import 'package:doc_warehouse/features/data/models/document_model.dart';
import 'package:doc_warehouse/features/domain/entities/document.dart';

const documentModelJson = '''
{
  "id": 1,
  "name": "Document Name",
  "filePath": "path/to/doc.txt",
  "description": "A simple document",
  "creationTime": "2021-01-01 00:00:00.000"
}
''';

final mockDocumentsModel = [
  DocumentModel(
      name: 'Test Document',
      filePath: 'document.txt',
      creationTime: mockCreationTime
  ),
];
final mockDocumentModel = DocumentModel(
  name: 'DocName',
  description: 'DocDesc',
  filePath: 'filePath.txt',
  creationTime: mockCreationTime,
);
final mockDocumentModelWithId = DocumentModel(
  name: 'DocName',
  description: 'DocDesc',
  filePath: 'filePath.txt',
  creationTime: mockCreationTime,
  id: 1,
);
final mockDocuments = [
  Document(
    name: 'fake_document',
    filePath: 'doc.txt',
    creationTime: mockCreationTime,
  ),
];
final mockCreationTime = DateTime.now();
final mockDocument = Document(
  name: 'DocName',
  description: 'DocDesc',
  filePath: 'filePath.txt',
  creationTime: mockCreationTime,
);
final mockDocumentWithId = Document(
  name: 'DocName',
  description: 'DocDesc',
  filePath: 'filePath.txt',
  creationTime: mockCreationTime,
  id: 1,
);