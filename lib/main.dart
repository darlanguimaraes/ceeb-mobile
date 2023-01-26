import 'package:ceeb_mobile/pages/book_form_page.dart';
import 'package:ceeb_mobile/pages/books_page.dart';
import 'package:ceeb_mobile/pages/categories_page.dart';
import 'package:ceeb_mobile/pages/category_form_page.dart';
import 'package:ceeb_mobile/pages/invoice_form_page.dart';
import 'package:ceeb_mobile/pages/invoices_page.dart';
import 'package:ceeb_mobile/pages/lending_form_page.dart';
import 'package:ceeb_mobile/pages/lending_page.dart';
import 'package:ceeb_mobile/pages/login_or_home_page.dart';
import 'package:ceeb_mobile/pages/reader_form_page.dart';
import 'package:ceeb_mobile/pages/readers_page.dart';
import 'package:ceeb_mobile/providers/auth_provider.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:ceeb_mobile/providers/category_provider.dart';
import 'package:ceeb_mobile/providers/invoice_provider.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:ceeb_mobile/utils/app_routes.dart';
import 'package:ceeb_mobile/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  final hiveUtils = HiveUtils();
  await hiveUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => ReaderProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => LendingProvider()),
      ],
      child: MaterialApp(
        title: 'CEEB',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            primary: Colors.blue.shade400,
            secondary: Colors.amber,
          ),
          textTheme: theme.textTheme.copyWith(
            headline6: const TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routes: {
          AppRoutes.login: (ctx) => const LoginOrHomePage(),
          AppRoutes.categories: (ctx) => const CategoriesPage(),
          AppRoutes.categoryForm: (ctx) => const CategoryForm(),
          AppRoutes.invoices: (ctx) => const Invoices(),
          AppRoutes.invoiceForm: (ctx) => const InvoiceFormPage(),
          AppRoutes.readers: (ctx) => const ReadersPage(),
          AppRoutes.readerForm: (ctx) => const ReaderFormPage(),
          AppRoutes.books: (ctx) => const BooksPage(),
          AppRoutes.bookForm: (ctx) => const BookFormPage(),
          AppRoutes.lending: (ctx) => const LendingPage(),
          AppRoutes.lendingForm: (ctx) => const LendingFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
