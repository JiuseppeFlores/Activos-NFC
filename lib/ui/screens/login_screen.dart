import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {

  final Session? session;

  const LoginScreen({
    super.key,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Theme.of(context).colorScheme.primary,
          //     Theme.of(context).colorScheme.primaryContainer,
          //   ],
          // ),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: LoginPage(
              session: session,
            ),
          ),
        ),
      ),
    );
  }

}