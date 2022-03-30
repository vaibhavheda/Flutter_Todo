import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/database/task_database.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/utils/custom_spacer.dart';
import 'package:todo_app/utils/padded_test_with_styles.dart';
import 'package:todo_app/widgets/new_task_add.dart';
import 'package:todo_app/widgets/todo_task_slidable.dart';

import 'card_category_main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late TaskController taskController;
  late CategoryController categoryController;
  bool isLoading = false;
  bool _saving = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskController = TaskController();
    categoryController = CategoryController();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    taskController.tasks = await TasksDatabase.instance.readAllTask();

    setState(() => isLoading = false);
  }

  void _handleTaskCompleteToggle(Task task, bool change) async {
    setState(() {
      _saving = true;
    });
    taskController.completeTask(task, change);
    log('${task.taskID}' + task.taskTitle);
    await TasksDatabase.instance.update(task.copy(isComp: change));
    setState(() {
      _saving = false;
    });
  }

  void _handleTaskDelete(Task task) async {
    setState(() {
      _saving = true;
    });
    taskController.removeTask(task);
    await TasksDatabase.instance.delete(task.taskID);
    setState(() {
      _saving = false;
    });
  }

  void _handleTaskUpdate(Task task) async {
    setState(() {
      _saving = true;
    });
    await TasksDatabase.instance.update(task);
    taskController.updateTask(task);
    setState(() {
      _saving = false;
    });
  }

  void _handleTaskAdd(Task task) async {
    setState(() {
      _saving = true;
    });
    taskController.addNewTask(await TasksDatabase.instance.create(task));
    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int _totalTasks = taskController.tasks.length;
    DateTime now = DateTime.now();
    DateTime date = DateTime.utc(now.year, now.month, now.day);
    List<Task> todayTask = taskController.tasks.where((element) {
      DateTime checkDate = DateTime.utc(
          element.taskDate.year, element.taskDate.month, element.taskDate.day);
      return checkDate.compareTo(date) == 0;
    }).toList();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextStyle(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              text: 'What\'s up, Vaibhav!',
              styles:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            CustomTextStyle(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              text: 'CATEGORIES',
              styles: const TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600),
            ),
            // Category Cards
            SizedBox(
              height: 300,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: categoryController.categories.length,
                itemBuilder: (BuildContext context, int index) => CardCategory(
                    categoryController: categoryController,
                    context: context,
                    categoryName:
                        categoryController.categories[index].categoryName,
                    totalTasks: _totalTasks,
                    numberOfItems: taskController.tasks
                        .where((element) =>
                            element.taskCategory ==
                            categoryController.categories[index].categoryName)
                        .toList()
                        .length),
                separatorBuilder: (BuildContext context, int index) =>
                    CustomSpacer(
                  width: 15,
                ),
              ),
            ),
            // Today's task
            CustomSpacer(
              height: 20,
            ),
            CustomTextStyle(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              text: 'TODAY\'S TASK',
              styles: const TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w600),
            ),
            // List View
            Expanded(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      TodoTaskSlidable(
                        todo: todayTask[index],
                        onTaskCompleted: _handleTaskCompleteToggle,
                        onTaskDelete: _handleTaskDelete,
                        onTaskUpdate: _handleTaskUpdate,
                      ),
                  itemCount: todayTask.length),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTaskAddScreen(
                  // id: (taskController.getLastTaskId() + 1),
                  isNewTask: true,
                  onTaskCreate: _handleTaskAdd),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
