import 'package:ceeb_mobile/models/book.dart';
import 'package:ceeb_mobile/providers/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookFormPage extends StatefulWidget {
  const BookFormPage({super.key});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final book = arg as Book;
        _formData['id'] = book.id.toString();
        _formData['name'] = book.name.toString();
        _formData['author'] = book.author.toString();
        _formData['writer'] = book.writer != null ? book.writer.toString() : '';
        _formData['code'] = book.code.toString();
        _formData['edition'] =
            book.edition != null ? book.edition.toString() : '';
        if (book.remoteId != null) {
          _formData['remoteId'] = book.remoteId!;
        }
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final book = Book();
      book.id = _formData['id']?.toString();
      book.name = _formData['name'].toString();
      book.author = _formData['author'].toString();
      book.writer = _formData['writer']?.toString();
      book.code = _formData['code'].toString();
      book.edition = _formData['edition']?.toString();
      book.borrow = false;
      book.sync = false;
      if (_formData['remoteId'] != null) {
        book.remoteId = _formData['remoteId'].toString();
      }

      await Provider.of<BookProvider>(context, listen: false).persist(book);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('SUCESSO!'),
          content: const Text('Livro Registrado.'),
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
          content: const Text('Ocorreu um erro para salvar o livro.'),
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
        title: const Text(
          'Livro',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: deviceSize.width > 600 ? 600 : double.infinity,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        decoration: const InputDecoration(labelText: 'Nome'),
                        onSaved: (name) => _formData['name'] = name ?? '',
                        validator: (value) {
                          final name = value ?? '';
                          if (name.trim().isEmpty) {
                            return 'Nome é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['code']?.toString(),
                        decoration: const InputDecoration(labelText: 'Código'),
                        onSaved: (code) => _formData['code'] = code ?? '',
                        validator: (value) {
                          final code = value ?? '';
                          if (code.trim().isEmpty) {
                            return 'Código é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['edition']?.toString(),
                        decoration: const InputDecoration(labelText: 'Edição'),
                        onSaved: (edition) =>
                            _formData['edition'] = edition ?? '',
                      ),
                      TextFormField(
                        initialValue: _formData['author']?.toString(),
                        decoration: const InputDecoration(labelText: 'Autor'),
                        onSaved: (author) => _formData['author'] = author ?? '',
                        validator: (value) {
                          final author = value ?? '';
                          if (author.trim().isEmpty) {
                            return 'Autor é obrigatório';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['writer']?.toString(),
                        decoration:
                            const InputDecoration(labelText: 'Escritor'),
                        onSaved: (writer) => _formData['writer'] = writer ?? '',
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
