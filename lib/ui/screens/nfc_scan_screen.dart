import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScanScreen extends StatefulWidget {
  const NfcScanScreen({super.key});

  @override
  State<NfcScanScreen> createState() => _NfcScanScreenState();
}

class _NfcScanScreenState extends State<NfcScanScreen> with WidgetsBindingObserver {
  String _message = 'Acerque el tag NFC al dispositivo...';
  bool _isScanning = false;
  bool _isNfcAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndStartScan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndStartScan();
    }
  }

  void _checkAndStartScan() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    setState(() {
      _isNfcAvailable = isAvailable;
      if (!isAvailable) {
        _message = 'El NFC no está habilitado o no es soportado por este dispositivo.';
        _isScanning = false;
      } else {
        _message = 'Acerque el tag NFC al dispositivo...';
        if (!_isScanning) _startNfcScan();
      }
    });
  }

  void _startNfcScan() async {
    setState(() {
      _isScanning = true;
    });

    try {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          final Map<String, dynamic> data = tag.data;
          List<int>? identifier;

          if (data.containsKey('nfca')) {
            identifier = List<int>.from(data['nfca']['identifier']);
          } else if (data.containsKey('mifareclassic')) {
            identifier = List<int>.from(data['mifareclassic']['identifier']);
          } else if (data.containsKey('mifareultralight')) {
            identifier = List<int>.from(data['mifareultralight']['identifier']);
          } else if (data.containsKey('isodep')) {
             identifier = List<int>.from(data['isodep']['identifier']);
          } else if (data.containsKey('ndef')) {
            identifier = List<int>.from(data['ndef']['identifier']);
          }

          if (identifier != null) {
            final String nfcId = identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
                .join(' ');
            
            await NfcManager.instance.stopSession();
            if (mounted) Navigator.pop(context, nfcId);
          } else {
            setState(() {
              _message = 'No se pudo identificar el Tag. Intente con otro.';
              _isScanning = false;
            });
          }
        },
      );
    } catch (e) {
      setState(() {
        _message = 'Error al iniciar sesión NFC: $e';
        _isScanning = false;
      });
    }
  }

  void _openNfcSettings() {
    if (Platform.isAndroid) {
      AppSettings.openAppSettings(type: AppSettingsType.nfc);
    } else {
      AppSettings.openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Escaneo de NFC')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: (_isNfcAvailable ? colorScheme.primary : Colors.grey).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isNfcAvailable ? Icons.contactless_outlined : Icons.do_disturb_alt_outlined,
                  size: 100, 
                  color: _isNfcAvailable ? colorScheme.primary : Colors.grey
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 48),
              if (_isScanning)
                const CircularProgressIndicator()
              else if (!_isNfcAvailable)
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _openNfcSettings,
                      icon: const Icon(Icons.settings),
                      label: const Text('Habilitar NFC en Ajustes'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Ingresar manualmente'),
                    ),
                  ],
                ),
              const SizedBox(height: 48),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Cancelar'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
