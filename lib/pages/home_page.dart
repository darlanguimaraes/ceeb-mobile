import 'package:ceeb_mobile/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:dbcrypt/dbcrypt.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var plainPassword = "ceebceeb";
    var hashedPassword =
        new DBCrypt().hashpw(plainPassword, new DBCrypt().gensaltWithRounds(8));
    print(hashedPassword);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CEEB',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
