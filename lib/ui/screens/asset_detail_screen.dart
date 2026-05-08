import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/common/utils/utils.dart';
import 'package:activos_nfc_app/ui/screens/nfc_scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetDetailScreen extends StatefulWidget {
  final int assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  State<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends State<AssetDetailScreen> {
  final TextEditingController _nfcController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<AssetCubit>().loadAssetById(widget.assetId);
  }

  @override
  void dispose() {
    _nfcController.dispose();
    super.dispose();
  }

  void _onScanNfc() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const NfcScanScreen()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _nfcController.text = result;
      });
    }
  }

  void _onUpdateNfc() {
    final nfcTag = _nfcController.text.trim();
    // Validación de formato: 04 26 66 02 50 5F 80 (7 pares de hex)
    final regExp = RegExp(r'^([0-9A-Fa-f]{2} ){6}[0-9A-Fa-f]{2}$');
    
    if (!regExp.hasMatch(nfcTag)) {
      BotToastManager.showNotification(
        context, 
        'FORMATO INVÁLIDO', 
        'El código debe seguir el formato: XX XX XX XX XX XX XX', 
        ProcessType.danger,
      );
      return;
    }

    context.read<AssetCubit>().updateNfcTag(widget.assetId, nfcTag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Activo'),
      ),
      body: BlocConsumer<AssetCubit, AssetState>(
        listener: (context, state) {
          if (state.status == AssetStatus.updateSuccess) {
            BotToastManager.showNotification(
              context, 
              'ÉXITO', 
              'Código NFC asignado correctamente', 
              ProcessType.success,
            );
            context.read<AssetCubit>().resetStatus();
          } else if (state.status == AssetStatus.updateError) {
            BotToastManager.showNotification(
              context, 
              'ERROR', 
              state.errorMessage ?? 'Error al actualizar', 
              ProcessType.danger,
            );
            context.read<AssetCubit>().resetStatus();
          }
        },
        builder: (context, state) {
          if (state.status == AssetStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AssetStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Error desconocido'));
          }

          final asset = state.asset;
          if (asset == null) return const SizedBox();

          // Pre-cargar el nfcTag actual si el controlador está vacío
          if (_nfcController.text.isEmpty && asset.nfcTag != null) {
             _nfcController.text = asset.nfcTag!;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(asset),
                const SizedBox(height: 24),
                const Text(
                  'Asignar Código NFC',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _nfcController,
                  decoration: InputDecoration(
                    labelText: 'UID Tag NFC',
                    hintText: '04 26 66 02 50 5F 80',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.nfc),
                      onPressed: _onScanNfc,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: state.status == AssetStatus.updating ? null : _onUpdateNfc,
                    icon: state.status == AssetStatus.updating 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                    label: const Text('Actualizar NFC'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(asset) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow('ID:', asset.id.toString()),
            _buildInfoRow('Activo:', asset.name),
            _buildInfoRow('Cód. Barras:', asset.barcode),
            _buildInfoRow('Estado:', asset.status ?? 'N/A'),
            _buildInfoRow('Valoración:', asset.valuation ?? 'N/A'),
            _buildInfoRow('NFC Actual:', asset.nfcTag ?? 'No asignado'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
