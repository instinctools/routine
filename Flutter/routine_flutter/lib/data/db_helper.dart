import 'package:routine_flutter/data/todo.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'todos';
const DB_NAME = 'todos_routine';
const DB_VERSION = 1;

const COLUMN_ID = 'id';
const COLUMN_TITLE = 'title';
const COLUMN_UNIT = 'periodUnit';
const COLUMN_VALUE = 'periodValue';
const COLUMN_TIMESTAMP = 'timestamp';

class DatabaseHelper {
//  Singleton
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  factory DatabaseHelper() => instance;

  Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }

    return await initDb();
  }

  Future<Database> initDb() async {
    var dbPath = await getDatabasesPath();
    String path = dbPath + '\/' + DB_NAME;
    return await openDatabase(path,
        version: DB_VERSION,
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE $TABLE_NAME ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "title TEXT,"
              "period_unit TEXT,"
              "period_value INTEGER,"
              "timestamp INTEGER"
              ")");
        },
        onOpen: (db) async => print("database = ${await db.getVersion()}"));
  }

  Future<List<Todo>> getTodos() async {
    var db = await database;
    var res = await db.query(TABLE_NAME);
    return res.map((item) => Todo.fromMap(item));
  }
}
