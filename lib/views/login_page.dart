import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/route_utils.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_PAGE.login.toTitle),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            authService.login();
          },
          child: const Text("Log in"),
        ),
      ),
    );
  }
}
