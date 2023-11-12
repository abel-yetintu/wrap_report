import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wrap_report/models/article.dart';

class DatabaseHelper {
  static const String _databaseName = 'articles.db';
  static const String _tableName = 'articles_table';
  static const String _colUrl = 'url';
  static const String _colTitle = 'title';
  static const String _colDescription = 'description';
  static const String _colContent = 'content';
  static const String _colImage = 'image';
  static const String _colPublishedAt = 'publishedAt';
  static const String _colSource = 'source';

  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, _databaseName);

    return await openDatabase(path, version: 1, onCreate: _createDatabse);
  }

  void _createDatabse(Database db, int newVersion) async {
    String sql =
        'CREATE TABLE $_tableName($_colUrl TEXT PRIMARY KEY, $_colTitle TEXT, $_colDescription TEXT, $_colContent TEXT, $_colImage TEXT, $_colPublishedAt TEXT, $_colSource TEXT)';
    await db.execute(sql);
  }

  // CRUD operations

  Future<List<Article>> getAllArticles() async {
    final database = await this.database;
    final result = await database.query(_tableName);
    return result.map((map) => Article.fromMap(map)).toList();
  }

  Future<int> insertArticle(Article article) async {
    final database = await this.database;
    return await database.insert(_tableName, article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteArticle(Article article) async {
    final database = await this.database;
    return await database.delete(
      _tableName,
      where: '$_colUrl = ?',
      whereArgs: [article.url],
    );
  }

  Future<int> queryRowCount() async {
    final database = await this.database;
    final results = await database.rawQuery('SELECT COUNT(*) FROM $_tableName');
    return Sqflite.firstIntValue(results) ?? 0;
  }
}
