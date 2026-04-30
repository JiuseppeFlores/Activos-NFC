import 'package:activos_empresa_app/ui/views/views.dart';
import 'package:flutter/material.dart';

class BottomSheetManager {
  static void showBottomSheet({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
    bool isDismissible = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      builder: (context) {
        return BottomSheetView(
          child: child,
        );
      },
    );
  }
}