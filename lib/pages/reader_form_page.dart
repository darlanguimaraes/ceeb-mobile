import 'package:ceeb_mobile/models/reader.dart';
import 'package:ceeb_mobile/providers/reader_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReaderFormPage extends StatefulWidget {
  const ReaderFormPage({super.key});

  @override
  State<ReaderFormPage> createState() => _ReaderFormPageState();
}

class _ReaderFormPageState extends State<ReaderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final reader = arg as Reader;
        _formData['id'] = reader.id.toString();
        _formData['name'] = reader.name.toString();
        _formData['phone'] = reader.phone?.toString() ?? '';
        _formData['address'] = reader.address?.toString() ?? '';
        _formData['city'] = reader.city?.toString() ?? '';
      }
    }
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);

    try {
      final reader = Reader();
      reader.id = _formData['id']?.toString();
      reader.name = _formData['name'].toString();
      reader.phone = _formData['phone']?.toString();
      reader.address = _formData['address']?.toString();
      reader.city = _formData['city']?.toString();
      reader.sync = false;

      await Provider.of<ReaderProvider>(context, listen: false).persist(reader);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('SUCESSO!'),
          content: const Text('Leitor Registrado.'),
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
          content: const Text('Ocorreu um erro para salvar o leitor.'),
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
        title: const Text('Leitor'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: deviceSize.width > 500 ? 500 : double.infinity,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _formData['name']?.toString(),
                        decoration: const InputDecoration(labelText: 'Nome'),
                        // textInputAction: TextInputAction.done,
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
                        initialValue: _formData['phone']?.toString(),
                        decoration:
                            const InputDecoration(labelText: 'Telefone'),
                        onSaved: (name) => _formData['phone'] = name ?? '',
                      ),
                      TextFormField(
                        initialValue: _formData['address']?.toString(),
                        decoration:
                            const InputDecoration(labelText: 'Endereço'),
                        onSaved: (name) => _formData['address'] = name ?? '',
                      ),
                      TextFormField(
                        initialValue: _formData['city']?.toString(),
                        decoration: const InputDecoration(labelText: 'Cidade'),
                        onSaved: (name) => _formData['city'] = name ?? '',
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
