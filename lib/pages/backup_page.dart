import 'dart:io';

import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/providers/backup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    String message = '';

    generateBackup() async {
      final returned =
          await Provider.of<BackupProvider>(context, listen: false).generate();
      setState(() {
        message = returned == 'ok'
            ? 'Backup gerado com sucesso'
            : 'Não foi possível gerar o backup';
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cópia de Segurança',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: deviceSize.width > 700 ? 700 : double.infinity,
          child: Column(
            children: [
              const Text(
                'Clique ne botão abaixo para gerar a cópia de segurança',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: generateBackup, child: const Text('Backup')),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
