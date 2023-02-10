import 'package:ceeb_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{};

  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: ((ctx) => AlertDialog(
            title: Text('Erro'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              )
            ],
          )),
    );
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    _formKey.currentState?.save();
    setState(() => _isLoading = true);
    AuthProvider auth = Provider.of(context, listen: false);
    try {
      await auth.authenticate(_formData['username']!, _formData['password']!);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(15),
                width: deviceSize.width > 500 ? 500 : double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Casa Espírita Euripedes Barsanulpho',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Cookie',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Image.asset(
                      'assets/images/euripedes.png',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: deviceSize.width * 0.75,
                        height: 250,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: _formData['username']?.toString(),
                                decoration: const InputDecoration(
                                    labelText: 'Nome de usuário'),
                                textInputAction: TextInputAction.next,
                                onSaved: (username) =>
                                    _formData['username'] = username ?? '',
                                validator: (_name) {
                                  final name = _name ?? '';
                                  if (name.trim().isEmpty) {
                                    return 'Digite o nome de usuário.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Senha'),
                                obscureText: true,
                                onSaved: (password) =>
                                    _formData['password'] = password ?? '',
                                validator: (_password) {
                                  final password = _password ?? '';
                                  if (password.trim().isEmpty ||
                                      password.length < 4) {
                                    return 'Senha inválida';
                                  }
                                  return null;
                                },
                              ),
                              const Spacer(),
                              if (_isLoading)
                                const CircularProgressIndicator()
                              else
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 8,
                                    ),
                                  ),
                                  onPressed: _submitForm,
                                  child: const Text('Entrar'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
