import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/bot_toast_manager.dart';
import 'package:activos_nfc_app/common/utils/dialog_alert_manager.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/forms/forms.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:activos_nfc_app/ui/views/dialogs/message_dialog_view.dart';
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

  late AuthCubit _authCubit;
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
    _authCubit = BlocProvider.of<AuthCubit>(context);
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _initLogin();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Sincronización con AccountBloc para mantener compatibilidad con el resto de la app
          final authResponse = state.authResponse!;
          final session = Session(
            id: authResponse.user.id,
            username: state.username!,
            password: state.password!,
            token: authResponse.token,
          );
          _accountBloc.add(OnUpdateSession(session));
          
          BotToastManager.showNotification(
            context, 
            'INICIO DE SESIÓN', 
            '¡Bienvenid@ ${authResponse.user.name}!', 
            ProcessType.success,
          );
          Navigator.pushReplacementNamed(context, 'home');
        } else if (state.status == AuthStatus.error) {
          setState(() => _loading = false);
          DialogAlertManager.showDialogAlert(
            context,
            MessageDialogView(
              title: 'INICIO DE SESIÓN', 
              icon: Icons.warning, 
              message: state.errorMessage ?? 'Error desconocido',
            ),
          );
        }
      },
      child: _loading 
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
          ),
    );
  }

  Future<void> _login(String username, String password) async {
    setState(() => _loading = true);
    await _authCubit.login(username, password);
    if (!mounted) return;
  }

}