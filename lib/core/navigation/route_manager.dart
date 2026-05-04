import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/ui/screens/screens.dart';
import 'package:flutter/material.dart';

class RouteManager {

  static void goToNFCScanning(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NFCScanningScreen(),
      ),
    );
  }

  static void goToProductScreen(BuildContext context, ScanType type, String uidTag){
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) 
          => ProductScreen(code: uidTag, type: type),
      )
    );
  }

}
