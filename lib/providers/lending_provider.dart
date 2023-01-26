import 'package:ceeb_mobile/controllers/lending_controller.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:flutter/material.dart';

class LendingProvider with ChangeNotifier {
  final List<Lending> _lendings = [];

  List<Lending> get lendings => [..._lendings];
  int get count => _lendings.length;

  Future<void> loadLendings() async {
    _lendings.clear();

    final lendingController = LendingController();
    final lendings = await lendingController.list();
    _lendings.addAll(lendings);
    notifyListeners();
  }

  Future<void> borrow(Lending lending) async {
    final lendingController = LendingController();
    await lendingController.borrowBook(lending);
    await loadLendings();
  }

  Future<void> returned(Lending lending) async {
    final lendingController = LendingController();
    await lendingController.returnBook(lending);
    await loadLendings();
  }
}
