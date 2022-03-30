import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/models/task.dart';

class TaskController {
  List<Task> tasks = [];

  addNewTask(Task newTask) {
    tasks.add(newTask);
  }

  removeTask(Task deleteTask) {
    tasks.remove(deleteTask);
  }

  completeTask(Task currentTask, bool value) {
    tasks
        .where((element) => element.taskID == currentTask.taskID)
        .toList()[0]
        .isCompleted = value;
  }

  getLastTaskId() {
    if (tasks.isEmpty) return 1;
    return tasks.last.taskID;
  }

  updateTask(Task updateTask) {
    for (var element in tasks) {
      if (element.taskID == updateTask.taskID) {
        element.isCompleted = updateTask.isCompleted;
        element.taskCategory = updateTask.taskCategory;
        element.taskTitle = updateTask.taskTitle;
        element.taskDescription = updateTask.taskDescription;
        element.taskDate = updateTask.taskDate;
      }
    }
  }
}
