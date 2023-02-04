import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEEB',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
