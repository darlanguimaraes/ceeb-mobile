import 'package:ceeb_mobile/controllers/synchronize_controller.dart';
import 'package:flutter/material.dart';

class SynchronizePage extends StatefulWidget {
  const SynchronizePage({super.key});

  @override
  State<SynchronizePage> createState() => _SynchronizePageState();
}

class _SynchronizePageState extends State<SynchronizePage> {
  synchronize() async {
    final synchronizeController = SynchronizeController();
    await synchronizeController.synchronize();
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
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: synchronize,
            child: const Text('Enviar dados'),
          ),
        ],
      ),
    );
  }
}
