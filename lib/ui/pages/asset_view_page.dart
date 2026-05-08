import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/forms/forms.dart';
import 'package:activos_nfc_app/ui/views/views.dart';
import 'package:activos_nfc_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetViewPage extends StatelessWidget {
  
  final User user;
  final Asset asset;

  const AssetViewPage({
    super.key,
    required this.user,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderDetailLabel(
                icon: Icons.person,
                title: 'Usuario',
                textButton: user.identityCard.isNotEmpty ? CustomTextButton(
                  icon: Icons.visibility,
                  text: 'Asignaciones',
                  onTap: () => BottomSheetManager.showBottomSheet(
                    context: context,
                    child: AssignmentsBottomSheetView(
                      user: user,
                    ),
                  ),
                ) : null,
              ),
              const Divider(height: 16),
              RowDetailLabel(title: 'Nombre', detail: user.fullName),
              const SizedBox(height: 8),
              RowDetailLabel(title: 'Cédula de Identidad', detail: user.identityCard),
              const SizedBox(height: 24),
              const HeaderDetailLabel(icon: Icons.sell, title: 'Activo'),
              const Divider(height: 32),
              RowDetailLabel(title: 'Nombre', detail: asset.name),
              const SizedBox(height: 8),
              RowDetailLabel(title: 'Código de Barras', detail: asset.barcode),
              const SizedBox(height: 24),
              HeaderDetailLabel(
                icon: asset.isInventoried ? Icons.check_circle : Icons.add_box, 
                title: 'Inventario'
              ),
              const Divider(height: 32),
              
              if (asset.isInventoried)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.5)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.verified, color: Colors.green, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'ACTIVO INVENTARIADO',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Este activo ya cuenta con un registro de inventario vigente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RowDetailLabel(title: 'ID de Asignación', detail: '${user.assignmentId}'),
                    const SizedBox(height: 16),
                    BlocConsumer<InventoryCubit, InventoryState>(
                      listener: (context, state) {
                        if (state.status == InventoryStatus.success) {
                          BotToastManager.showNotification(
                            context, 
                            'INVENTARIO', 
                            'Activo registrado correctamente', 
                            ProcessType.success,
                          );
                          // Recargar el activo para actualizar el estado de inventariado
                          context.read<AssetCubit>().loadAsset(asset.barcode, ScanType.barcode);
                        } else if (state.status == InventoryStatus.error) {
                          BotToastManager.showNotification(
                            context, 
                            'ERROR', 
                            state.errorMessage ?? 'Error al registrar inventario', 
                            ProcessType.danger,
                          );
                        }
                      },
                      builder: (context, state) {
                        return InventoryForm(
                          onSubmit: (String observation) async {
                            final userId = context.read<AuthCubit>().state.authResponse?.user.id ?? 0;
                            context.read<InventoryCubit>().registerInventory(
                              idActivo: asset.id,
                              idUsuario: userId,
                              observacion: observation,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}