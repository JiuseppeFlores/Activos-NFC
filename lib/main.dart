import 'package:activos_empresa_app/blocs/blocs.dart';
import 'package:activos_empresa_app/common/utils/utils.dart';
import 'package:activos_empresa_app/core/models/models.dart';
import 'package:activos_empresa_app/ui/screens/screens.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  await dotenv.load(fileName: '.env');
  Session session = await SharedPreferencesManager.getSession();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AccountBloc(session: session)),
      ],
      child: const ActivoEmpresa(),
    ),
  );
}

class ActivoEmpresa extends StatelessWidget {
  
  const ActivoEmpresa({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activos Empresa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 107, 169, 255)),
      ),
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeScreen(),
        'qr': (_) => const QRScreen(),
      },
      initialRoute: 'login',
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    );
  }
}