import 'package:ceeb_mobile/controllers/book_controller.dart';
import 'package:ceeb_mobile/models/book.dart';
import 'package:flutter/material.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => [..._books];
  int get count => _books.length;

  Future<void> loadBooks() async {
    _books.clear();

    final bookController = BookController();
    final categories = await bookController.list();
    _books.addAll(categories);
    notifyListeners();
  }

  Future<void> persist(Book book) async {
    final bookController = BookController();
    await bookController.persist(book);
    await loadBooks();
  }
}
