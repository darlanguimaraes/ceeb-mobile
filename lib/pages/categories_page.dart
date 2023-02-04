import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/components/category_list_item.dart';
import 'package:ceeb_mobile/providers/category_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categorias',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.categoryForm),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: deviceSize.width > 700 ? 700 : double.infinity,
          child: FutureBuilder(
            future: Provider.of<CategoryProvider>(context, listen: false)
                .loadCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return const Center(child: Text('Ocorreu um erro!'));
              } else {
                return Consumer<CategoryProvider>(
                  builder: ((ctx, categories, child) => ListView.builder(
                        itemCount: categories.count,
                        itemBuilder: ((ctx, index) => Column(
                              children: [
                                CategoryListItem(categories.categories[index]),
                                const Divider(),
                              ],
                            )),
                      )),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
