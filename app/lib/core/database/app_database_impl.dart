part of 'app_database.dart';

class _AppDatabaseImpl extends AppDatabase {
  Database? _database;

  @override
  Future<void> init() async {
    _database = await openDatabase(
      'doc_warehouse.db',
      version: 1,
      onCreate: (db, _) async {
        print('on create');
        await db.execute('CREATE TABLE documents ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name VARCHAR(256), '
            'description TEXT, '
            'filePath VARCHAR(512), '
            'creationTime DATETIME)');
      },
    );
  }

  @override
  Future<QueryResult<List<Map<String, dynamic>>>> query(String sql) async {
    final result = await _database!.rawQuery(sql);
    return QueryResult(result);
  }

  @override
  Future<InsertResult<int>> insert(String sql, [List<dynamic>? params]) async {
    final resultId = await _database!.rawInsert(sql, params);
    return InsertResult(id: resultId);
  }
}
