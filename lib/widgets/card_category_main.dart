import 'package:flutter/material.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/utils/padded_test_with_styles.dart';

import '../utils/custom_spacer.dart';

class CardCategory extends StatelessWidget {
  const CardCategory({
    Key? key,
    required this.categoryController,
    required this.context,
    required this.categoryName,
    required this.totalTasks,
    required this.numberOfItems,
  }) : super(key: key);

  final CategoryController categoryController;
  final BuildContext context;
  final CategoryTypes categoryName;
  final int totalTasks;
  final int numberOfItems;

  @override
  Widget build(BuildContext context) {
    var currentTask = categoryController.category(categoryName);
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(200, 200, 200, 0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(4, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              height: 150,
              child: Image.asset(
                currentTask.categoryImage,
              ),
            ),
          ),
          CustomSpacer(
            height: 10,
          ),
          CustomTextStyle(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            text: '$numberOfItems' + (numberOfItems > 1 ? ' tasks' : ' task'),
            styles: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              categoryName.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          CustomSpacer(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TweenAnimationBuilder(
              // tween: Tween(begin: 0.0, end: numberOfItems / totalTasks ),
              tween: Tween(
                  begin: 0.0,
                  end: numberOfItems / (totalTasks == 0 ? 1 : totalTasks)),
              builder: (BuildContext context, double value, Widget? child) {
                return LinearProgressIndicator(
                  value: value,
                  color: currentTask.color,
                  backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
                  minHeight: 5,
                );
              },
              duration: const Duration(milliseconds: 500),
            ),
          )
        ],
      ),
    );
  }
}
