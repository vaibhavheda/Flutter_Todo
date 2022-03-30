import 'package:flutter/material.dart';
import 'package:todo_app/models/category.dart';

enum CategoryTypes { Personal, Business, Gaming, Other }

class CategoryController {
  List<Category> categories = [
    Category(
        1, 'assets/images/personal.png', CategoryTypes.Personal, Colors.blue),
    Category(2, 'assets/images/business.png', CategoryTypes.Business,
        Colors.deepOrangeAccent),
    Category(
        3, 'assets/images/gaming.png', CategoryTypes.Gaming, Colors.lightGreen),
    Category(4, 'assets/images/other.png', CategoryTypes.Other, Colors.teal),
  ];

  Category category(CategoryTypes type) {
    return categories
        .where((element) => element.categoryName.name == type.name)
        .first;
  }

  CategoryTypes getCategoryTypeFromString(String type) {
    switch (type) {
      case "Personal":
        return CategoryTypes.Personal;
      case "Business":
        return CategoryTypes.Business;
      case "Gaming":
        return CategoryTypes.Gaming;
      case "Other":
      default:
        return CategoryTypes.Other;
    }
  }
}
