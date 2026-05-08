import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/ui/screens/screens.dart';
import 'package:flutter/material.dart';

class RouteManager {

  static void goToNfcScan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NfcScanScreen(),
      ),
    );
  }

  static void goToAssetViewScreen(BuildContext context, ScanType type, String code){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) 
          => AssetViewScreen(code: code, type: type),
      )
    );
  }

}
