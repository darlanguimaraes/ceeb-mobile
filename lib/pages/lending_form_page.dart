import 'package:ceeb_mobile/controllers/reader_controller.dart';
import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/models/lending.dart';
import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:ceeb_mobile/providers/lending_provider.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LendingFormPage extends StatefulWidget {
  const LendingFormPage({super.key});

  @override
  State<LendingFormPage> createState() => _LendingFormPageState();
}

class _LendingFormPageState extends State<LendingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  bool _isLoading = false;

  String readerId = '';
  String readerName = '';
  String bookId = '';
  String bookName = '';
  String bookCode = '';

  List<Book> _books = [];
  List<Reader> _readers = [];

  TextEditingController dateController = TextEditingController();
  TextEditingController filterReader = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateController.text = '';
  }

  Future<void> _submitForm() async {
    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final dateBorrow = DateFormat('dd/MM/yyyy').parse(dateController.text);

      final lending = Lending();
      lending.date = DateFormat('dd/MM/yyyy').parse(dateController.text);
      lending.expectedDate = dateBorrow.add(const Duration(days: 30));
      lending.readerId = readerId;
      lending.readerName = readerName;
      lending.bookId = bookId;
      lending.bookName = bookName;
      lending.bookCode = bookCode;
      lending.returned = false;
      lending.sync = false;

      await Provider.of<LendingProvider>(context, listen: false)
          .borrow(lending);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('SUCESSO!'),
          content: const Text(''),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ocorreu um erro!'),
          content: const Text('Ocorreu um erro para salvar.'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Empréstimo"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: deviceSize.width > 500 ? 500 : double.infinity,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Selecione a data',
                          icon: Icon(Icons.calendar_today),
                        ),
                        controller: dateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Leitor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      FutureBuilder(
                        future:
                            Provider.of<ReaderProvider>(context, listen: false)
                                .loadReaders(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.error != null) {
                            return const Center(
                                child: Text('Ocorreu um erro!'));
                          } else {
                            return SizedBox(
                              child: Consumer<ReaderProvider>(
                                builder: (context, readers, child) =>
                                    Autocomplete<Reader>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return readers.readers
                                        .where((Reader county) => county.name!
                                            .toLowerCase()
                                            .startsWith(textEditingValue.text
                                                .toLowerCase()))
                                        .toList();
                                  },
                                  displayStringForOption: (Reader option) =>
                                      option.name!,
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextField(
                                      controller: fieldTextEditingController,
                                      focusNode: fieldFocusNode,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                  onSelected: (Reader selection) {
                                    print('Selected: ${selection.name}');
                                    setState(() {
                                      readerId = selection.id!;
                                      readerName = selection.name!;
                                    });
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<Reader> onSelected,
                                      Iterable<Reader> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          width: 300,
                                          color: Colors.grey,
                                          child: ListView.builder(
                                            padding: EdgeInsets.all(10.0),
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final Reader option =
                                                  options.elementAt(index);

                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                  title: Text(option.name!,
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Livro',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      FutureBuilder(
                        future:
                            Provider.of<BookProvider>(context, listen: false)
                                .loadBooks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.error != null) {
                            return const Center(
                                child: Text('Ocorreu um erro!'));
                          } else {
                            return SizedBox(
                              child: Consumer<BookProvider>(
                                builder: (context, books, child) =>
                                    Autocomplete<Book>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    return books.books
                                        .where((Book county) => county.name!
                                            .toLowerCase()
                                            .startsWith(textEditingValue.text
                                                .toLowerCase()))
                                        .toList();
                                  },
                                  displayStringForOption: (Book option) =>
                                      option.name!,
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          fieldTextEditingController,
                                      FocusNode fieldFocusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextField(
                                      controller: fieldTextEditingController,
                                      focusNode: fieldFocusNode,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                  onSelected: (Book selection) {
                                    print('Selected: ${selection.name}');
                                    setState(() {
                                      bookId = selection.id!;
                                      bookName = selection.name!;
                                    });
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<Book> onSelected,
                                      Iterable<Book> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          width: 300,
                                          color: Colors.grey,
                                          child: ListView.builder(
                                            padding: EdgeInsets.all(10.0),
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final Book option =
                                                  options.elementAt(index);

                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                  title: Text(option.name!,
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: Align(
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Salvar'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
