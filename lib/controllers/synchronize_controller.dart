import 'dart:convert';

import 'package:ceeb_mobile/controllers/book_controller.dart';
import 'package:ceeb_mobile/controllers/category_controller.dart';
import 'package:ceeb_mobile/controllers/invoice_controller.dart';
import 'package:ceeb_mobile/controllers/lending_controller.dart';
import 'package:ceeb_mobile/controllers/reader_controller.dart';
import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/models/category.dart';
import 'package:ceeb_mobile/models/invoice.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/models/reader.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SynchronizeController {
  final uuid = Uuid();
  final baseUrl = 'https://ceeb-admin.vercel.app/api';
  // final baseUrl = 'http://192.168.1.6:3000/api';

  Future<String> synchronize(String username, String password) async {
    try {
      final token = await login(username, password);
      await syncCategories(token);
      await syncReaders(token);
      await syncBooks(token);
      await syncInvoice(token);
      await syncLending(token);

      return 'Dados sincronizados!';
    } catch (e) {
      print(e);
      return 'Erro ao sincronizar os dados: $e';
    }
  }

  Future<String> login(String username, String password) async {
    final Map body = {
      "username": username,
      "password": password,
    };
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user'),
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao realizar o login');
      }

      final data = jsonDecode(response.body);
      return data['token'];
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> syncBooks(String token) async {
    final bookController = BookController();
    final books = await bookController.listForSynchronize();
    if (books.isNotEmpty) {
      final dataBooks = books.map((e) => e.toJson()).toList();
      final body = json.encoder.convert(dataBooks);

      final responseNewData = await http.post(
        Uri.parse('$baseUrl/synchronize/books?auth=$token'),
        body: body,
      );
      final newData = jsonDecode(responseNewData.body);
      final List listNewBooks = newData['newData'];
      if (listNewBooks.isNotEmpty) {
        for (var element in listNewBooks) {
          final bookUpdate = await bookController.getBook(element['id']);
          bookUpdate!.remoteId = element['remoteId'];
          await bookController.persistSync(bookUpdate);
        }
      }
    }

    final resp =
        await http.get(Uri.parse('$baseUrl/synchronize/books?auth=$token'));
    final data = jsonDecode(resp.body);
    final List listBooks = data['books'];
    if (listBooks.isNotEmpty) {
      for (var element in listBooks) {
        final book =
            await bookController.findByRemoteId(element['id']) ?? Book();
        book.remoteId = element['id'];
        book.author = element['author'];
        book.borrow = element['borrow'];
        book.code = element['code'];
        book.edition = element['edition'];
        book.name = element['name'];
        book.writer = element['writer'];
        book.sync = true;
        await bookController.persistSync(book);
      }
    }
  }

  Future<void> syncReaders(String token) async {
    final readerController = ReaderController();
    final readers = await readerController.listForSynchronize();
    if (readers.isNotEmpty) {
      final dataReaders = readers.map((e) => e.toJson()).toList();
      final body = json.encoder.convert(dataReaders);

      final responseNewData = await http.post(
        Uri.parse('$baseUrl/synchronize/readers?auth=$token'),
        body: body,
      );
      final newData = jsonDecode(responseNewData.body);
      final List listNewReaders = newData['newData'];
      if (listNewReaders.isNotEmpty) {
        for (var element in listNewReaders) {
          final readerUpdate = await readerController.getReader(element['id']);
          readerUpdate!.remoteId = element['remoteId'];
          await readerController.persistSync(readerUpdate);
        }
      }
    }

    final resp =
        await http.get(Uri.parse('$baseUrl/synchronize/readers?auth=$token'));
    final data = jsonDecode(resp.body);
    final List listReaders = data['readers'];
    if (listReaders.isNotEmpty) {
      for (var element in listReaders) {
        final reader =
            await readerController.findByRemoteId(element['id']) ?? Reader();
        reader.remoteId = element['id'];
        reader.name = element['name'];
        reader.phone = element['phone'];
        reader.address = element['address'];
        reader.city = element['city'];
        reader.email = element['email'];
        reader.openLoan = element['openLoan'];
        reader.sync = true;
        await readerController.persistSync(reader);
      }
    }
  }

  Future<void> syncCategories(String token) async {
    final categoryController = CategoryController();
    final categories = await categoryController.listForSynchronize();

    if (categories.isNotEmpty) {
      final dataCategories = categories.map((e) => e.toJson()).toList();
      final body = json.encoder.convert(dataCategories);

      final responseNewData = await http.post(
        Uri.parse('$baseUrl/synchronize/categories?auth=$token'),
        body: body,
      );
      final newData = jsonDecode(responseNewData.body);
      final List listNewCategory = newData['newData'];
      if (listNewCategory.isNotEmpty) {
        for (var element in listNewCategory) {
          final categoryUpdate = await categoryController.get(element['id']);
          categoryUpdate!.remoteId = element['remoteId'];
          await categoryController.persist(categoryUpdate, true);
        }
      }
    }
    final resp = await http.get(
      Uri.parse('$baseUrl/synchronize/categories?auth=$token'),
    );
    final data = jsonDecode(resp.body);
    final List listCat = data['categories'];
    if (listCat.isNotEmpty) {
      for (var element in listCat) {
        Category category =
            await categoryController.findByRemoteId(element['id']) ??
                Category();
        category.remoteId = element['id'];
        category.name = element['name'];
        await categoryController.persist(category, true);
      }
    }
  }

  Future<void> syncInvoice(String token) async {
    final invoiceController = InvoiceController();
    final categoryController = CategoryController();
    final invoices = await invoiceController.listForSynchronize();
    if (invoices.isNotEmpty) {
      final List temp = [];
      for (var element in invoices) {
        final category = await categoryController.get(element.category!.id!);
        temp.add(element.toJson(category!.remoteId!));
      }
      final body = json.encoder.convert(temp);

      final responseNewData = await http.post(
        Uri.parse('$baseUrl/synchronize/invoices?auth=$token'),
        body: body,
      );
      final newData = jsonDecode(responseNewData.body);
      final List listNewInvoices = newData['newData'];
      if (listNewInvoices.isNotEmpty) {
        for (var element in listNewInvoices) {
          final invoiceUpdate = await invoiceController.get(element['id']);
          invoiceUpdate!.remoteId = element['remoteId'];
          await invoiceController.persistSync(invoiceUpdate);
        }
      }
    }

    final resp =
        await http.get(Uri.parse('$baseUrl/synchronize/invoices?auth=$token'));
    final data = jsonDecode(resp.body);
    final List listInvoices = data['invoices'];
    if (listInvoices.isNotEmpty) {
      final categoryController = CategoryController();

      for (var element in listInvoices) {
        final category =
            await categoryController.findByRemoteId(element['categoryId']);

        final invoice =
            await invoiceController.findByRemoteId(element['id']) ?? Invoice();
        invoice.categoryId = category!.id;
        invoice.category = category;
        invoice.credit = element['credit'];
        invoice.date = DateTime.tryParse(element['date']);
        invoice.lendingId = element['lendingId'];
        invoice.paymentType = element['paymentType'];
        invoice.quantity = double.tryParse(element['quantity']);
        invoice.remoteId = element['id'];
        invoice.value = double.tryParse(element['value']);
        invoice.sync = true;
        await invoiceController.persistSync(invoice);
      }
    }
  }

  Future<void> syncLending(String token) async {
    final lendingController = LendingController();
    final bookController = BookController();
    final readerController = ReaderController();
    final lendings = await lendingController.listForSynchronize();
    if (lendings.isNotEmpty) {
      final List listLendings = [];
      for (var element in lendings) {
        final book = await bookController.getBook(element.bookId!);
        final reader = await readerController.getReader(element.readerId!);
        listLendings.add(element.toJson(book!.remoteId!, reader!.remoteId!));
      }
      final body = json.encoder.convert(listLendings);

      final responseNewData = await http.post(
        Uri.parse('$baseUrl/synchronize/lendings?auth=$token'),
        body: body,
      );
      final newData = jsonDecode(responseNewData.body);
      final List listNewLendings = newData['newData'];
      if (listNewLendings.isNotEmpty) {
        for (var element in listNewLendings) {
          final lendingUpdate = await lendingController.get(element['id']);
          lendingUpdate!.remoteId = element['remoteId'];
          await lendingController.persistSync(lendingUpdate);
        }
      }
    }

    final resp =
        await http.get(Uri.parse('$baseUrl/synchronize/lendings?auth=$token'));
    final data = jsonDecode(resp.body);
    final List listLendings = data['lendings'];
    if (listLendings.isNotEmpty) {
      final bookController = BookController();
      final readerController = ReaderController();

      for (var element in listLendings) {
        final bookRemote = element['book'];
        final book = await bookController.findByRemoteId(bookRemote['id']);

        final readerRemote = element['reader'];
        final reader =
            await readerController.findByRemoteId(readerRemote['id']);

        final lending =
            await lendingController.findByRemoteId(element['id']) ?? Lending();
        lending.bookId = book!.id;
        lending.bookName = book.name;
        lending.bookCode = book.code;
        lending.bookEdition = book.edition;
        lending.readerId = reader!.id;
        lending.readerName = reader.name;
        lending.code = book.code;
        lending.date = DateTime.tryParse(element['date']);
        lending.expectedDate = DateTime.tryParse(element['expectedDate']);
        if (element['deliveryDate'] != null) {
          lending.deliveryDate = DateTime.tryParse(element['deliveryDate']);
        }
        lending.returned = element['returned'];
        lending.remoteId = element['id'];
        lending.sync = true;
        await lendingController.persistSync(lending);
      }
    }
  }
}
