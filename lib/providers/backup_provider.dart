import 'package:ceeb_mobile/controllers/backup_controller.dart';
import 'package:flutter/material.dart';

class BackupProvider with ChangeNotifier {
  Future<String> generate() async {
    final backupController = BackupController();
    return await backupController.generate();
  }
}
