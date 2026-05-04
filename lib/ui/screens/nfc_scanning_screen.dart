import 'dart:io';

import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/core/navigation/route_manager.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCScanningScreen extends StatefulWidget {
  const NFCScanningScreen({super.key});

  @override
  State<NFCScanningScreen> createState() => _NFCScanningScreenState();
}

class _NFCScanningScreenState extends State<NFCScanningScreen> with WidgetsBindingObserver {
  bool _isScanning = false;
  String? _scannedData;
  String? _errorMessage;
  bool _nfcAvailable = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkNFCAvailability();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkNFCAvailability();
    }
  }

  Future<void> _checkNFCAvailability() async {
    try {
      final isAvailable = await NfcManager.instance.isAvailable();
      setState(() {
        _nfcAvailable = isAvailable;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error verificando disponibilidad NFC';
      });
    }
  }

  Future<void> _startNFCScanning() async {
    if (!_nfcAvailable) {
      setState(() {
        _errorMessage = 'NFC no está disponible en este dispositivo';
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _errorMessage = null;
      _scannedData = null;
    });

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          String data = '';
          try {
            // Extraer información útil del tag
            final identifier = tag.data['nfca']?['identifier'] ?? 
                              tag.data['nfcb']?['identifier'] ?? 
                              tag.data['isodep']?['identifier'];
            
            if (identifier != null) {
              final hexString = (identifier as List<int>)
                  .map((byte) => byte.toRadixString(16).padLeft(2, '0').toUpperCase())
                  .join(' ');
              data = 'UID del Tag: $hexString';
              RouteManager.goToProductScreen(context, ScanType.nfc, hexString);
            } else {
              // Mostrar la estructura completa del tag
              data = 'Datos del Tag:\n${tag.data.toString()}';
            }
          } catch (e) {
            data = 'ID del Tag: ${tag.data.toString()}';
          }

          setState(() {
            _scannedData = data;
            _isScanning = false;
          });

          await NfcManager.instance.stopSession();
        },
        alertMessage: 'Acerca tu dispositivo al tag NFC',
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
        _isScanning = false;
      });
      await NfcManager.instance.stopSession();
    }
  }

  void _resetScanning() {
    setState(() {
      _scannedData = null;
      _errorMessage = null;
      _isScanning = false;
    });
  }

  void _openNFCSettings() {
    if (Platform.isAndroid) {
      AppSettings.openAppSettings(type: AppSettingsType.nfc);
    } else {
      AppSettings.openAppSettings();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Escaneo por NFC',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Verificación de disponibilidad NFC
                  if (!_nfcAvailable)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.red.withAlpha(20),
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'NFC no disponible',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Verifique que su dispositivo tenga habilitado la funcionalidad de NFC',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _openNFCSettings,
                          icon: const Icon(Icons.settings),
                          label: const Text('Abrir ajustes NFC'),
                        ),
                      ],
                    ),
                  )
                  else if (_isScanning)
                    // Estado de carga - Esperando lectura NFC
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.nfc,
                              size: 80,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Escaneando...',
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Acerca tu dispositivo\nal tag NFC',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40),
                          TextButton.icon(
                            onPressed: (){
                              NfcManager.instance.stopSession();
                              _resetScanning();
                            },
                            icon: Icon(Icons.close, color: Colors.red),
                            label: Text(
                              'Cancelar Escaneo',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_scannedData != null)
                    // Datos escaneados exitosamente
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Tag escaneado exitosamente',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Datos del tag:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                _scannedData!,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Courier',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _resetScanning,
                          child: const Text('Escanear otro tag'),
                        ),
                      ],
                    )
                  else if (_errorMessage != null)
                    // Mensaje de error
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _resetScanning,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    )
                  else
                    // Estado inicial - Botón para iniciar escaneo
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          ),
                          child: Icon(
                            Icons.nfc_rounded,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Listo para escanear',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Toca el botón para comenzar\na escanear tags NFC',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton.icon(
                          onPressed: _startNFCScanning,
                          icon: const Icon(Icons.nfc),
                          label: const Text('Iniciar escaneo'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}