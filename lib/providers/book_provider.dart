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
    final books = await bookController.list();
    _books.addAll(books);
    notifyListeners();
  }

  Future<void> loadBooksFilter(String filter) async {
    _books.clear();
    final bookController = BookController();
    final books = await bookController.find(filter);
    _books.addAll(books);
    notifyListeners();
  }

  Future<void> persist(Book book) async {
    final bookController = BookController();
    await bookController.persist(book);
    await loadBooks();
  }

  Future<List<Book>> find(String name) async {
    final bookController = BookController();
    return await bookController.find(name);
  }
}
