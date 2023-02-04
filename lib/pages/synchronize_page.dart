import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:ceeb_mobile/controllers/synchronize_controller.dart';
import 'package:flutter/material.dart';

class SynchronizePage extends StatefulWidget {
  const SynchronizePage({super.key});

  @override
  State<SynchronizePage> createState() => _SynchronizePageState();
}

class _SynchronizePageState extends State<SynchronizePage> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, String>{};
  bool _isLoading = false;
  String _message = '';

  synchronize() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState?.save();

    setState(() {
      _isLoading = true;
      _message = '';
    });
    final synchronizeController = SynchronizeController();
    final returnValue = await synchronizeController.synchronize(
        _formData['username']!, _formData['password']!);

    setState(() {
      _isLoading = false;
      _message = returnValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sincronizar Dados',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Container(
          width: deviceSize.width > 500 ? 500 : double.infinity,
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const Text(
                'Digite o nome de usuário e senha para realizar o sincronização dos dados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    initialValue: _formData['username']?.toString(),
                    decoration:
                        const InputDecoration(labelText: 'Nome de usuário'),
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
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    onSaved: (password) =>
                        _formData['password'] = password ?? '',
                    validator: (_password) {
                      final password = _password ?? '';
                      if (password.trim().isEmpty || password.length < 5) {
                        return 'Senha inválida';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: synchronize,
                          child: const Text('Sincronizar'),
                        ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      _message,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
