import 'dart:async';

import 'package:doc_warehouse/features/data/models/document_model.dart';

abstract class DocumentDatasource {
  Future<List<DocumentModel>> getDocuments();
  Future<int> create(DocumentModel model);
}