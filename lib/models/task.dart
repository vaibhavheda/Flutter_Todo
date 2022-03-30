import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/models/category.dart';

final String tableTask = 'tasks';

class TasksField {
  static final List<String> values = [
    taskId,
    isCompleted,
    date,
    title,
    description,
    category_id,
    category
  ];

  static const String taskId = 'taskId';
  static const String isCompleted = 'isCompleted';
  static const String date = 'date';
  static const String title = 'title';
  static const String description = 'description';
  static const String category = 'category';
  static const String category_id = 'category_id';
}

class Task {
  final int? taskID;
  CategoryTypes taskCategory;
  DateTime taskDate;
  bool isCompleted;
  String taskTitle;
  String taskDescription;
  int categoryId;

  Task(
      {this.taskID,
      required this.taskCategory,
      required this.taskDate,
      required this.isCompleted,
      required this.taskTitle,
      required this.taskDescription,
      required this.categoryId});

  Task copy(
          {int? id,
          String? title,
          String? description,
          DateTime? date,
          int? categoryId,
          bool? isComp,
          CategoryTypes? taskCategory}) =>
      Task(
          taskID: id ?? taskID,
          taskTitle: title ?? taskTitle,
          taskDescription: description ?? taskDescription,
          taskDate: date ?? taskDate,
          isCompleted: isComp ?? isCompleted,
          categoryId: categoryId ?? this.categoryId,
          taskCategory: taskCategory ?? this.taskCategory);

  static Task fromJson(Map<String, Object?> json) => Task(
        taskID: json[TasksField.taskId] as int,
        categoryId: json[TasksField.category_id] as int,
        taskTitle: json[TasksField.title] as String,
        taskDescription: json[TasksField.description] as String,
        taskCategory: CategoryController()
            .getCategoryTypeFromString(json[TasksField.category] as String),
        isCompleted: json[TasksField.isCompleted] == 1,
        taskDate: DateTime.parse(json[TasksField.date] as String),
      );

  Map<String, Object?> toJson() => {
        TasksField.taskId: taskID,
        TasksField.title: taskTitle,
        TasksField.description: taskDescription,
        TasksField.category: taskCategory.name,
        TasksField.category_id: categoryId,
        TasksField.isCompleted: isCompleted ? 1 : 0,
        TasksField.date: taskDate.toIso8601String(),
      };
}
