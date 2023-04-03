import 'dart:io';

import 'package:ceeb_mobile/controllers/book_controller.dart';
import 'package:ceeb_mobile/controllers/category_controller.dart';
import 'package:ceeb_mobile/controllers/invoice_controller.dart';
import 'package:ceeb_mobile/controllers/lending_controller.dart';
import 'package:ceeb_mobile/controllers/reader_controller.dart';

class BackupController {
  Future<String> generate() async {
    final file = File('/storage/emulated/0/Download/backup.txt');

    String finalData = '';
    try {
      finalData += 'CATEGORIAS\n\n';
      finalData += await _getCategories();
      finalData += 'LIVROS\n\n';
      finalData += await _getBooks();
      finalData += 'LEITORES\n\n';
      finalData += await _getReaders();
      finalData += 'EMPRESTIMOS\n\n';
      finalData += await _getLending();
      finalData += 'CONTAS\n\n';
      finalData += await _getInvoice();

      await file.writeAsString(finalData);
    } catch (e) {
      return 'error';
    }

    return 'ok';
  }

  Future<String> _getCategories() async {
    final categoryController = CategoryController();
    final list = await categoryController.list();

    String data = 'id;name;remoteId;\n';
    for (var category in list) {
      data += '${category.id};${category.name};${category.remoteId}\n';
    }
    return data;
  }

  Future<String> _getBooks() async {
    final bookController = BookController();
    final books = await bookController.list();

    String data = 'id;name;author;writer;code;borrow;edition;remoteId;\n';
    for (var book in books) {
      data +=
          '${book.id};${book.name};${book.author};${book.writer};${book.code};${book.borrow};${book.edition};${book.remoteId};\n';
    }
    return data;
  }

  Future<String> _getReaders() async {
    final readerController = ReaderController();
    final readers = await readerController.list();

    String data = 'id;name;phone;address;city;email;openLoan;remoteId;\n';
    for (var reader in readers) {
      data +=
          '${reader.id};${reader.name};${reader.phone};${reader.address};${reader.city};${reader.email};${reader.openLoan};${reader.remoteId};\n';
    }
    return data;
  }

  Future<String> _getInvoice() async {
    final invoiceController = InvoiceController();
    final invoices = await invoiceController.list();

    String data =
        'id;date;quantity;value;credit;paymentType;categoryId;remoteId;\n';
    for (var invoice in invoices) {
      data +=
          '${invoice.id};${invoice.date?.toUtc().toIso8601String()};${invoice.quantity};${invoice.value};${invoice.credit};${invoice.paymentType};${invoice.categoryId};${invoice.remoteId};\n';
    }
    return data;
  }

  Future<String> _getLending() async {
    final lendingController = LendingController();
    final lendings = await lendingController.list();

    String data =
        'id;bookId;readerId;date;expectedDate;deliveryDate;code;returned;remoteId;\n';
    for (var lending in lendings) {
      data +=
          '${lending.id};${lending.bookId};${lending.readerId};${lending.date?.toUtc().toIso8601String()};${lending.expectedDate?.toUtc().toIso8601String()};${lending.deliveryDate?.toUtc().toIso8601String()};${lending.code};${lending.returned};${lending.remoteId};\n';
    }

    return data;
  }
}
