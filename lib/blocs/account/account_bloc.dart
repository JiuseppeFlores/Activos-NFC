// ignore_for_file: use_build_context_synchronously

import 'package:activos_empresa_app/common/enums/enums.dart';
import 'package:activos_empresa_app/common/utils/utils.dart';
import 'package:activos_empresa_app/core/clients/clients.dart';
import 'package:activos_empresa_app/core/models/models.dart';
import 'package:activos_empresa_app/core/services/services.dart';
import 'package:activos_empresa_app/ui/screens/screens.dart';
import 'package:activos_empresa_app/ui/views/views.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {

  final Session session;

  AccountBloc({required this.session}) : super(AccountState(session: session)) {
    on<OnUpdateSession>((event, emit) => emit(state.copyWith(session: event.session)));
  }

  Future<bool> login(BuildContext context, String username, String password) async {
    const action = 'INICIO DE SESIÓN';
    final service = LoginService(LoginClient());
    final response = await service.login(username, password);
    final success = response.isSuccessful;
    if(success){
      final session = Session(
        id: response.data,
        username: username,
        password: password,
      );
      add(OnUpdateSession(session));
      SharedPreferencesManager.saveSession(session);
      BotToastManager.showNotification(
        context, action, '¡Bienvenid@ $username!', ProcessType.success,
      );
    }else{
      DialogAlertManager.showDialogAlert(
        context,
        MessageDialogView(title: action, icon: Icons.warning, message: response.error.replaceAll('<br>', '\n')),
      );
    }
    return success;
  }

  void logout(BuildContext context, VoidCallback? onConfirm){
    const action = 'CERRAR SESIÓN';
    DialogAlertManager.showDialogAlert(
      context, 
      ConfirmDialogView(
        title: action,
        icon: Icons.warning,
        message: '¿Esta segur@ que desea salir de la sesión actual?',
        titleButtonConfirm: 'Salir',
        onConfirm: () async {
          final session = Session();
          add(OnUpdateSession(session));
          await SharedPreferencesManager.saveSession(session);
          if(onConfirm != null){ onConfirm(); }
          Navigator.pushAndRemoveUntil(
            context, 
            MaterialPageRoute(builder: (_) => LoginScreen(session: session)), 
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> getProductByBarcode(BuildContext context, String barcode) async {
    const action = 'ACTIVO NO ASIGNADO';
    final service = ProductService(ProductClient());
    final response = await service.getProductByBarcode(barcode);
    final data = response.data;
    if(!response.isSuccessful){
      DialogAlertManager.showDialogAlert(
        context,
        MessageDialogView(title: action, icon: Icons.warning, message: response.error.replaceAll('<br>', '\n')),
      );
    }
    return data;
  }

  Future<bool> registerInventory(BuildContext context, int assignmentId, String observation) async {
    const action = 'REGISTRAR INVENTARIO';
    final service = InventoryService(InventoryClient());
    final response = await service.registerInventory(assignmentId, state.session.id, observation);
    if(response.isSuccessful){
      BotToastManager.showNotification(
        context, action, 'Producto registrado correctamente', ProcessType.success,
      );
    }else{
      DialogAlertManager.showDialogAlert(
        context,
        MessageDialogView(title: action, icon: Icons.warning, message: response.error.replaceAll('<br>', '\n')),
      );
    }
    return response.isSuccessful;
  }

  Future<List<Product>> getAssignments(BuildContext context, String identityCard) async {
    const action = 'OBTENER ASIGNACIONES';
    final service = UserService(UserClient());
    final response = await service.getAssignments(identityCard);
    final data = response.data ?? [];
    if(!response.isSuccessful){
      DialogAlertManager.showDialogAlert(
        context,
        MessageDialogView(title: action, icon: Icons.warning, message: response.error.replaceAll('<br>', '\n')),
      );
    }
    return data;
  }

}
