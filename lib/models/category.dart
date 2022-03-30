import 'dart:ui';
import '../controller/category_controller.dart';

class Category {
  final int id;
  final String categoryImage;
  final CategoryTypes categoryName;
  final Color color;

  Category(this.id, this.categoryImage, this.categoryName, this.color);
}
