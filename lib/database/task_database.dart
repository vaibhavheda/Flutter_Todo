import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();

  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todo_tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute(
      "CREATE TABLE $tableTask ("
      "${TasksField.taskId} $idType,"
      "${TasksField.isCompleted} $boolType,"
      "${TasksField.category} $textType,"
      "${TasksField.category_id} $integerType,"
      "${TasksField.title} $textType,"
      "${TasksField.description} $textType,"
      "${TasksField.date} $textType"
      ")",
    );
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;

    final id = await db.insert(tableTask, task.toJson());

    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTask,
      columns: TasksField.values,
      where: '${TasksField.taskId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception("ID ${id} is not found");
    }
  }

  Future<List<Task>> readAllTask() async {
    final db = await instance.database;
    const orderBy = '${TasksField.date} ASC';
    final result = await db.query(tableTask, orderBy: orderBy);

    return result.map((json) => Task.fromJson(json)).toList();
    // if (maps.isNotEmpty) {
    //   return Task.fromJson(maps.first);
    // } else {
    //   throw Exception("ID ${id} is not found");
    // }
  }

  Future<int> update(Task task) async {
    final db = await instance.database;

    return db.update(tableTask, task.toJson(),
        where: '${TasksField.taskId} = ?', whereArgs: [task.taskID]);
  }

  Future<int> delete(int? id) async {
    final db = await instance.database;

    return db
        .delete(tableTask, where: '${TasksField.taskId} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
