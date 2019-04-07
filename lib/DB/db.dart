    
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_assignment_02/Model/todo.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TodoDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY autoincrement,"
          "todo VARCHAR(255),"
          "status INTEGER"
          ")");
    });
  }

  newTodo(Todo newTodo) async {
    final db = await database;
    //get the biggest id in the table
    // var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    // int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Todo (todo,status)"
        " VALUES (?,?)",
        [newTodo.todo, newTodo.status]);
    return raw;
  }

  blockOrUnblock(Todo todo) async {
    final db = await database;
    Todo status = Todo(
        id: todo.id,
        todo: todo.todo,
        status: (todo.status==0)? 1:0);
    var res = await db.update("Todo", status.toMap(),
        where: "id = ?", whereArgs: [todo.id]);
    return res;
  }

  updateTodo(Todo newTodo) async {
    final db = await database;
    var res = await db.update("Todo", newTodo.toMap(),
        where: "id = ?", whereArgs: [newTodo.id]);
    return res;
  }

  getTodo(int id) async {
    final db = await database;
    var res = await db.query("Todo", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Todo.fromMap(res.first) : null;
  }

   Future<List<Todo>> getAllCompletTodo() async {
    final int status = 1;
    final db = await database;
    var res = await db.query("Todo", where: "status = ?", whereArgs: [status]);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }
  
  Future<List<Todo>> getAllTaskTodo() async {
    final int status = 0;
    final db = await database;
    var res = await db.query("Todo", where: "status = ?", whereArgs: [status]);
     List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getStatusTodo() async {
    final db = await database;

    print("works");
    // var res = await db.rawQuery("SELECT * FROM Todo WHERE status=1");
    var res = await db.query("Todo", where: "status = ? ", whereArgs: [1]);

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    var res = await db.query("Todo");
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  deleteTodo(int id) async {
    print("delete");
    final db = await database;
    return db.delete("Todo", where: "id = ?", whereArgs: [id]);
  }

  deleteTodoFromStatus() async {
    int status = 1;
    print("deletefromstatus");
    final db = await database;
    return db.delete("Todo", where: "status = ?", whereArgs: [status]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Todo");
  }
}