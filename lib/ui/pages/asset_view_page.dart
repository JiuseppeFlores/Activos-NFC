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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Asset Header Card
          _buildAssetHeader(context, colorScheme, textTheme),
          const SizedBox(height: 16),

          // Details Section
          _buildSectionTitle(context, 'Detalles del Activo', Icons.info_outline),
          _buildAssetDetails(context, colorScheme),
          const SizedBox(height: 20),
          if (user.id > 0) ...[
            _buildSectionTitle(context, 'Usuario Asignado', Icons.person_outline),
            _buildUserInfo(context, colorScheme),
            const SizedBox(height: 20),
          ],
          if(user.id > 0) ...[
            _buildSectionTitle(context, 'Estado de Inspección', Icons.fact_check_outlined),
            _buildInspectionStatus(context, colorScheme),
            const SizedBox(height: 24),
          ],

        ],
      ),
    );
  }

  Widget _buildAssetHeader(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2, color: colorScheme.primary, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      asset.assessment ?? 'S/N',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, right: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: colorScheme.primary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.primary.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetDetails(BuildContext context, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _buildDetailTile(
            context,
            Icons.qr_code_2,
            'Código',
            asset.barcode,
          ),
          const Divider(height: 1, indent: 50),
          _buildDetailTile(
            context,
            Icons.nfc,
            'Etiqueta NFC (UID)',
            asset.nfcTag ?? 'No vinculada',
            isNfc: true,
          ),
          if (asset.status != null) ...[
            const Divider(height: 1, indent: 50),
            _buildDetailTile(
              context,
              Icons.info_outline,
              'Disponibilidad',
              asset.status!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.secondary.withOpacity(0.1),
                child: Icon(Icons.person, color: colorScheme.secondary),
              ),
              title: Text(
                user.fullName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('C.I. ${user.identityCard}'),
            ),
            const Divider(height: 1, indent: 70),
            _buildDetailTile(
              context,
              Icons.assignment_ind_outlined,
              'ID de Asignación',
              '#${user.assignmentId}',
              isSmall: true,
            ),
            if(user.identityCard.isNotEmpty)...[
              CustomTextButton(
                icon: Icons.history,
                text: 'Asignaciones',
                onTap: () => BottomSheetManager.showBottomSheet(
                  context: context,
                  child: AssignmentsBottomSheetView(user: user),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, IconData icon, String label, String value, {bool isNfc = false, bool isSmall = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: isSmall,
      leading: Icon(icon, color: isNfc ? Colors.blue : colorScheme.onSurfaceVariant, size: 20),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isNfc && asset.nfcTag == null ? Colors.red : null,
        ),
      ),
    );
  }

  Widget _buildInspectionStatus(BuildContext context, ColorScheme colorScheme) {
    if (asset.isInventoried) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            const Icon(Icons.verified, color: Colors.green, size: 48),
            const SizedBox(height: 12),
            Text(
              'ACTIVO VERIFICADO',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Este activo ya cuenta con un registro de inspección vigente en el sistema.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<InventoryCubit, InventoryState>(
          listener: (context, state) {
            if (state.status == InventoryStatus.success) {
              BotToastManager.showNotification(
                context, 
                'INSPECCIÓN', 
                'Activo registrado correctamente', 
                ProcessType.success,
              );
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
      ),
    );
  }
}