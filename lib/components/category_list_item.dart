import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;

  const CategoryListItem(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name.toString()),
      trailing: SizedBox(
        width: 50,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.categoryForm,
                arguments: category,
              ),
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
