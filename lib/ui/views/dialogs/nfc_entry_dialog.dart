import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/core/navigation/route_manager.dart';
import 'package:activos_nfc_app/ui/screens/nfc_scan_screen.dart';
import 'package:activos_nfc_app/ui/screens/qr_screen.dart';
import 'package:flutter/material.dart';

class ScanEntryDialog extends StatefulWidget {
  const ScanEntryDialog({super.key});

  @override
  State<ScanEntryDialog> createState() => _ScanEntryDialogState();
}

class _ScanEntryDialogState extends State<ScanEntryDialog> {
  final TextEditingController _controller = TextEditingController();
  ScanType _selectedType = ScanType.nfc;

  void _onScan() async {
    if (_selectedType == ScanType.nfc) {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const NfcScanScreen()),
      );
      if (result != null && result.isNotEmpty) {
        setState(() => _controller.text = result);
      }
    } else {
      // Modo selección para QR: el valor vuelve al diálogo en lugar de navegar
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const QRScreen(isSelectionMode: true)),
      );
      
      if (result != null && result.isNotEmpty) {
        setState(() => _controller.text = result);
      }
    }
  }

  void _onSubmit() {
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      Navigator.pop(context);
      RouteManager.goToAssetViewScreen(context, _selectedType, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNfc = _selectedType == ScanType.nfc;

    return AlertDialog(
      title: Text(
        'Buscar Activo',
        style: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selector de Tipo de Escaneo
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _TypeSelector(
                  label: 'NFC',
                  isSelected: isNfc,
                  icon: Icons.nfc,
                  onTap: () => setState(() {
                    _selectedType = ScanType.nfc;
                    _controller.clear();
                  }),
                ),
                _TypeSelector(
                  label: 'QR / Barras',
                  isSelected: !isNfc,
                  icon: Icons.qr_code_scanner,
                  onTap: () => setState(() {
                    _selectedType = ScanType.barcode;
                    _controller.clear();
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Campo de Texto Dinámico
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: isNfc ? 'Código UID NFC' : 'Código de Barras',
              hintText: isNfc ? 'XX XX XX XX XX XX' : 'MD-XX-XX-XXXX',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(isNfc ? Icons.nfc : Icons.barcode_reader),
            ),
          ),
          const SizedBox(height: 16),
          
          // Botón de Escaneo Rápido
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _onScan,
              icon: Icon(isNfc ? Icons.nfc : Icons.qr_code_scanner),
              label: Text(isNfc ? 'Escanear Tag NFC' : 'Escanear QR / Barras'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _onSubmit,
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _TypeSelector({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
