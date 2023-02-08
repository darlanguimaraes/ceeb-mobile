import 'package:ceeb_mobile/controllers/lending_controller.dart';
import 'package:ceeb_mobile/dto/report_lending_dto.dart';
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
    lendings.sort((b, a) => a.date!.compareTo(b.date!));
    _lendings.addAll(lendings);
    notifyListeners();
  }

  Future<void> loadLendingsFilter(bool open) async {
    _lendings.clear();

    final lendingController = LendingController();
    final lendings = await lendingController.listFilter(open);
    lendings.sort((b, a) => a.date!.compareTo(b.date!));
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

  Future<ReportLending> getReport() async {
    final lendingController = LendingController();
    final lendings = await lendingController.listFilter(true);

    final lateLendings = lendings.where((element) => element.isLate).toList();
    final report =
        ReportLending(lendings.length, lateLendings.length, lateLendings);
    return report;
  }
}
