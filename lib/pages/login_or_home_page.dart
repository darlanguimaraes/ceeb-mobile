import 'package:ceeb_mobile/pages/home_page.dart';
import 'package:ceeb_mobile/pages/login_page.dart';
import 'package:ceeb_mobile/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginOrHomePage extends StatelessWidget {
  const LoginOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);
    return auth.isAuth ? const HomePage() : const LoginPage();
  }
}
