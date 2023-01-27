import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem Vindo!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Emprésitimos e Devoluções'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.lending),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Livros'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.books),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Leitores'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.readers),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.currency_exchange),
            title: const Text('Contas'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.invoices),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('Categorias'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.categories),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('Relatórios'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sincronizar'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.synchronize),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () {},
          ),
          const Divider(),
        ],
      ),
    );
  }
}
