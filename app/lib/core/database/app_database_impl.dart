part of 'app_database.dart';

class _AppDatabaseImpl extends AppDatabase {
  Database? _database;

  @override
  Future<void> init() async {
    _database = await openDatabase(
      'doc_warehouse.db',
      version: 1,
      onCreate: (db, _) async {
        await db.execute('CREATE TABLE documents ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
            'name VARCHAR(256) NOT NULL, '
            'description TEXT, '
            'filePath VARCHAR(512) NOT NULL, '
            'creationTime DATETIME NOT NULL)');
      },
    );
  }

  @override
  Future<QueryResult<List<Map<String, dynamic>>>> query(String sql, [List<dynamic>? params]) async {
    final result = await _database!.rawQuery(sql, params);
    return QueryResult(result);
  }

  @override
  Future<InsertResult<int>> insert(String sql, [List<dynamic>? params]) async {
    final resultId = await _database!.rawInsert(sql, params);
    return InsertResult(id: resultId);
  }

  @override
  Future<void> delete(String sql, [List<dynamic>? params]) async {
    await _database!.rawDelete(sql, params);
  }

  @override
  Future<void> update(String sql, [List<dynamic>? params]) async {
    await _database!.rawUpdate(sql, params);
  }
}
