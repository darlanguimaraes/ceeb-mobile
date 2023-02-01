import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/controllers/synchronize_controller.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SynchronizePage extends StatefulWidget {
  const SynchronizePage({super.key});

  @override
  State<SynchronizePage> createState() => _SynchronizePageState();
}

class _SynchronizePageState extends State<SynchronizePage> {
  bool _isLoading = false;
  String _message = '';

  synchronize() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });
    final synchronizeController = SynchronizeController();
    final returnValue = await synchronizeController.synchronize();
    await Provider.of<CategoryProvider>(context, listen: false)
        .loadCategories();

    setState(() {
      _isLoading = false;
      _message = returnValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sincronizar Dados',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: ListView(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: synchronize,
                      child: const Text('Sincronizar'),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _message,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
