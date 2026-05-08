import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/core/clients/clients.dart';
import 'package:activos_nfc_app/core/repositories/asset_repository.dart';
import 'package:activos_nfc_app/core/repositories/assignment_repository.dart';
import 'package:activos_nfc_app/core/repositories/auth_repository.dart';
import 'package:activos_nfc_app/core/repositories/inventory_repository.dart';
import 'package:activos_nfc_app/core/repositories/session_repository.dart';
import 'package:activos_nfc_app/core/services/asset_service.dart';
import 'package:activos_nfc_app/core/services/assignment_service.dart';
import 'package:activos_nfc_app/core/services/auth_service.dart';
import 'package:activos_nfc_app/core/services/inventory_service.dart';
import 'package:activos_nfc_app/ui/screens/screens.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {

  await dotenv.load(fileName: '.env');

  // 1. Capa de Servicios de Red (Hablan con Dio)
  final authService = AuthService(AuthClient());
  final assetService = AssetService(AssetClient());
  final assignmentService = AssignmentService(AssignmentClient());
  final inventoryService = InventoryService(InventoryClient());

  // 2. Capa de Repositorios (Obtienen y tratan la información)
  final sessionRepository = SessionRepository();
  final authRepository = AuthRepository(authService, sessionRepository);
  final assetRepository = AssetRepository(assetService);
  final assignmentRepository = AssignmentRepository(assignmentService);
  final inventoryRepository = InventoryRepository(inventoryService);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authRepository: authRepository)),
        BlocProvider(create: (_) => AssetCubit(assetRepository: assetRepository)),
        BlocProvider(create: (_) => InventoryCubit(inventoryRepository: inventoryRepository)),
        BlocProvider(create: (_) => AssignedAssetsCubit(assignmentRepository: assignmentRepository)),
      ],
      child: const ActivoEmpresa(),
    ),
  );
}

class ActivoEmpresa extends StatelessWidget {
  
  const ActivoEmpresa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activos NFC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 107, 169, 255)),
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