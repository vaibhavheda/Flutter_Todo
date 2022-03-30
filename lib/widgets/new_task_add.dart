import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/utils/custom_spacer.dart';
import '../models/task.dart';

typedef TaskCallback = Function(Task task);

class NewTaskAddScreen extends StatefulWidget {
  final bool isNewTask;
  final TaskCallback? onTaskCreate;
  final TaskCallback? onTaskUpdate;
  final TaskCallback? onTaskDelete;
  final Task? task;
  const NewTaskAddScreen(
      {Key? key,
      this.onTaskCreate,
      this.onTaskUpdate,
      this.task,
      this.onTaskDelete,
      required this.isNewTask})
      : super(key: key);

  @override
  _NewTaskAddScreenState createState() => _NewTaskAddScreenState();
}

class _NewTaskAddScreenState extends State<NewTaskAddScreen> {
  late TextEditingController _titleController, _descriptionController;
  late CategoryController categoryController;
  late CategoryTypes categoryValue;
  late DateTime taskDate;
  late bool isCompletedTask;
  @override
  void initState() {
    categoryController = CategoryController();
    _titleController = TextEditingController(
        text: widget.isNewTask ? '' : widget.task?.taskTitle);
    _descriptionController = TextEditingController(
        text: widget.isNewTask ? '' : widget.task?.taskDescription);
    isCompletedTask = (widget.isNewTask ? false : widget.task?.isCompleted)!;
    categoryValue = (widget.isNewTask
        ? CategoryTypes.Personal
        : widget.task?.taskCategory)!;
    taskDate = (widget.isNewTask ? DateTime.now() : widget.task?.taskDate)!;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleDropdownChange(CategoryTypes value) {
    setState(() {
      categoryValue = value;
    });
  }

  void _handleTaskCompleted(bool value) {
    setState(() {
      isCompletedTask = value;
    });
  }

  void showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (value) {
                if (value != taskDate) {
                  setState(() {
                    taskDate = value;
                  });
                }
              },
              initialDateTime: DateTime.now(),
              minimumYear: 1950,
              maximumYear: 2050,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (widget.isNewTask == false)
            IconButton(
                onPressed: () {
                  if (widget.task != null) {
                    widget.onTaskDelete!(widget.task as Task);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.black,
                )),
          IconButton(
              onPressed: () {
                final task = Task(
                  taskID: widget.task?.taskID,
                  taskDescription: _descriptionController.text,
                  taskTitle: _titleController.text,
                  taskCategory: categoryValue,
                  taskDate: taskDate,
                  isCompleted: isCompletedTask,
                  categoryId: categoryController.category(categoryValue).id,
                );

                widget.isNewTask
                    ? widget.onTaskCreate!(task)
                    : widget.onTaskUpdate!(task);
                // await TasksDatabase.instance.create(task);
                // go back
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.save_alt_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            // First Title field
            CustomSpacer(
              height: 30,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                autofocus: true,
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  icon: Icon(Icons.task_outlined),
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Create a task...',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  icon: Icon(Icons.description_outlined),
                  contentPadding: EdgeInsets.all(8),
                  hintText: 'Write a note...',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        showDatePicker();
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 18.0)),
                      ),
                      icon: const Icon(
                        Icons.calendar_today_rounded,
                      ),
                      label: Text(
                          "${taskDate.day}/${taskDate.month}/${taskDate.year}"),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Completed ?'),
                      checkColor: Colors.white,
                      activeColor: Colors.blueGrey,
                      value: isCompletedTask,
                      onChanged: (bool? value) {
                        _handleTaskCompleted(value ?? false);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                ),
                child: DropdownButton(
                    items: CategoryTypes.values
                        .map<DropdownMenuItem<CategoryTypes>>(
                            (CategoryTypes value) {
                      return DropdownMenuItem<CategoryTypes>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    value: categoryValue,
                    borderRadius: const BorderRadius.all(Radius.circular(11.0)),
                    underline: Container(),
                    onChanged: (value) {
                      _handleDropdownChange(value as CategoryTypes);
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
