import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/new_task_add.dart';

typedef TaskToggleCallback = Function(Task task, bool change);
typedef TaskCallback = Function(Task task);

class TodoTaskSlidable extends StatelessWidget {
  final Task todo;
  final TaskToggleCallback onTaskCompleted;
  final TaskCallback onTaskDelete;
  final TaskCallback onTaskUpdate;
  final CategoryController categoryController = CategoryController();

  TodoTaskSlidable({
    required this.todo,
    required this.onTaskCompleted,
    required this.onTaskDelete,
    required this.onTaskUpdate,
  }) : super(key: ObjectKey(todo));
  TextStyle? _getTextStyle(BuildContext ctx) {
    if (!todo.isCompleted) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color colorReq = categoryController.category(todo.taskCategory).color;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(200, 200, 200, 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(1, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Slidable(
          key: ObjectKey(todo),
          startActionPane: ActionPane(
            extentRatio: 1 / 2,
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
              onTaskDelete(todo);
            }),
            children: [
              SlidableAction(
                onPressed: (_) {
                  onTaskDelete(todo);
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                flex: 1,
              ),
              SlidableAction(
                onPressed: (_) {
                  onTaskCompleted(todo, !todo.isCompleted);
                },
                backgroundColor: const Color.fromRGBO(100, 200, 100, 1),
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Complete',
                flex: 1,
              ),
            ],
          ),
          child: Material(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewTaskAddScreen(
                            task: todo,
                            onTaskUpdate: onTaskUpdate,
                            onTaskDelete: onTaskDelete,
                            isNewTask: false,
                          )),
                );
              },
              leading: Checkbox(
                checkColor: Colors.white,
                activeColor: colorReq.withOpacity(0.7),
                shape: const CircleBorder(),
                value: todo.isCompleted,
                onChanged: (bool? value) {
                  onTaskCompleted(todo, value ?? false);
                },
              ),
              title: Text(
                todo.taskTitle,
                style: _getTextStyle(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
