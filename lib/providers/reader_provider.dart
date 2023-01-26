import 'package:ceeb_mobile/controllers/reader_controller.dart';
import 'package:ceeb_mobile/models/reader.dart';
import 'package:flutter/material.dart';

class ReaderProvider with ChangeNotifier {
  final List<Reader> _readers = [];

  List<Reader> get readers => [..._readers];
  int get count => _readers.length;

  Future<void> loadReaders() async {
    _readers.clear();

    final readerController = ReaderController();
    final readers = await readerController.list();
    _readers.addAll(readers);
    notifyListeners();
  }

  Future<void> persist(Reader reader) async {
    final readerController = ReaderController();
    await readerController.persist(reader);
    await loadReaders();
  }

  Future<List<Reader>> find(String name) async {
    final readerController = ReaderController();
    return await readerController.find(name);
  }
}
