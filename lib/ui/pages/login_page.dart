import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/forms/forms.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {

  final Session? session;

  const LoginPage({
    super.key,
    required this.session,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late AccountBloc _accountBloc;
  bool _loading = true;

  void _initLogin() async {
    final session = widget.session ?? _accountBloc.session;
    if(session.isStarted){
      await _login(session.username, session.password);
    }else{
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _initLogin();
  }

  @override
  Widget build(BuildContext context) {

    return _loading 
      ? LoadingPage()
      : Card(
          margin: EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Iniciar Sesión',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Divider(height: 24),
                Text(
                  'Ingrese su usuario y contraseña para acceder a la aplicación',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 16),
                LoginForm(onSubmit: _login),
              ],
            ),
          ),
        );
  }

  Future<void> _login(String username, String password) async {
    final success = await _accountBloc.login(context, username, password);
    if(success){
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'home');
    }else{
      setState(() => _loading = false);
    }
  }

}