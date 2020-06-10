import 'package:routine_flutter/data/todo.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = 'todos';
const DB_NAME = 'todos_routine';
const DB_VERSION = 1;

const COLUMN_ID = 'id';
const COLUMN_TITLE = 'title';
const COLUMN_UNIT = 'period_unit';
const COLUMN_VALUE = 'period_value';
const COLUMN_TARGET_DATE = 'target_time';
const COLUMN_RESET_TYPE = 'reset_type';

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
              "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,"
              "$COLUMN_TITLE TEXT,"
              "$COLUMN_UNIT TEXT,"
              "$COLUMN_VALUE INTEGER,"
              "$COLUMN_TARGET_DATE INTEGER,"
              "$COLUMN_RESET_TYPE TEXT"
              ")");
        },
        onOpen: (db) async => print("database = ${await db.getVersion()}"));
  }

  Future<List<Todo>> getTodos() async {
    var db = await database;
    var queryMap = await db.query(TABLE_NAME);
    print("all items:  $queryMap");
    var todos = queryMap.map((item) => Todo.fromMap(item)).toList();
    return todos.toList();
  }

  Future<int> changeTodo(Todo todo) async {
    var db = await database;

    if (todo.id != null) {
      return await db.update(TABLE_NAME, todo.toMap(), where: WHERE_ID_CLAUSE, whereArgs: [todo.id]);
    } else {
      return await db.insert(TABLE_NAME, todo.toMap());
    }
  }

  Future<int> deleteTodo(int id) async {
    var db = await database;
    return await db.delete(TABLE_NAME, where: WHERE_ID_CLAUSE, whereArgs: [id.toString()]);
  }
}
