import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/bot_toast_manager.dart';
import 'package:activos_nfc_app/common/utils/dialog_alert_manager.dart';
import 'package:activos_nfc_app/ui/forms/forms.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:activos_nfc_app/ui/views/dialogs/message_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          final authResponse = state.authResponse!;
          
          BotToastManager.showNotification(
            context, 
            'INICIO DE SESIÓN', 
            '¡Bienvenid@ ${authResponse.user.name}!', 
            ProcessType.success,
          );
          Navigator.pushReplacementNamed(context, 'home');
        } else if (state.status == AuthStatus.error) {
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
      builder: (context, state) {
        if (state.status == AuthStatus.loading || state.status == AuthStatus.initial) {
          return const LoadingPage();
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
                const Divider(height: 24),
                Text(
                  'Ingrese su usuario y contraseña para acceder a la aplicación',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                LoginForm(
                  onSubmit: (username, password) => 
                    context.read<AuthCubit>().login(username, password),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}