import 'package:activos_empresa_app/ui/views/views.dart';
import 'package:flutter/material.dart';

class DialogAlertManager {
  static void showDialogAlert(BuildContext context, Widget child,
      [bool dismissable = true]) {
    showDialog(
      context: context,
      barrierDismissible: dismissable,
      barrierColor: Colors.black.withAlpha(120),
      builder: (context) => PopScope(
          canPop: dismissable,
          child: DialogView(child: child),
        )
      );
  }
}
