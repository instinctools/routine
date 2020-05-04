import 'package:routine_flutter/data/todo.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'todos';
const DB_NAME = 'todos_routine';
const DB_VERSION = 1;

const COLUMN_ID = 'id';
const COLUMN_TITLE = 'title';
const COLUMN_UNIT = 'period_unit';
const COLUMN_VALUE = 'period_value';
const COLUMN_TIMESTAMP = 'timestamp';

const WHERE_ID_CLAUSE = 'id = ?';

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
    var queryMap = await db.query(TABLE_NAME);
    var todos = queryMap.map((item) => Todo.fromMap(item)).toList();
    return todos.toList();
  }

  Future<int> changeTodo(Todo todo) async {
    var db = await database;

    if (todo.id != null) {
      return await db.update(TABLE_NAME, todo.toMap(),
          where: WHERE_ID_CLAUSE, whereArgs: [todo.id]);
    } else {
      return await db.insert(TABLE_NAME, todo.toMap());
    }
  }
}
