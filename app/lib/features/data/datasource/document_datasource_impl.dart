import 'package:doc_warehouse/core/database/app_database.dart';
import 'package:doc_warehouse/core/errors/exceptions.dart';
import 'package:doc_warehouse/features/data/datasource/document_datasource.dart';
import 'package:doc_warehouse/features/data/models/document_model.dart';

class DocumentDatasourceImpl extends DocumentDatasource {
  final AppDatabase database;

  DocumentDatasourceImpl(this.database);

  @override
  Future<List<DocumentModel>> getDocuments() async {
    try {
      final queryResult = await database.query("SELECT name, description, filePath, creationTime, "
          "tags FROM document");
      return queryResult.data
          .map((json) => DocumentModel.fromJson(json))
          .toList(growable: false);
    } on Exception catch (e) {
      throw new DatabaseException("Could not query documents", e);
    }
  }
}