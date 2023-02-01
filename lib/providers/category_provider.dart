import 'package:ceeb_mobile/controllers/category_controller.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => [..._categories];
  int get count => _categories.length;

  Future<void> loadCategories() async {
    _categories.clear();

    final categoryController = CategoryController();
    final categories = await categoryController.list();
    categories.sort((a, b) => a.name!.compareTo(b.name!));
    _categories.addAll(categories);
    notifyListeners();
  }

  Future<void> persist(Category category) async {
    final categoryController = CategoryController();
    await categoryController.persist(category, false);
    await loadCategories();
  }
}
