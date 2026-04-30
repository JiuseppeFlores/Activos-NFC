import 'package:activos_empresa_app/common/data/data.dart';
import 'package:activos_empresa_app/common/enums/enums.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

class BotToastManager{
  static void showNotification(BuildContext context, String title, String message, ProcessType type, [bottom = false]){
    Color color = type == ProcessType.success
        ? Colors.green.shade400
        : type == ProcessType.warning
            ? Colors.amber.shade400
            : type == ProcessType.danger
                ? Colors.red.shade400
                : Theme.of(context).colorScheme.primary;
    IconData icon = type == ProcessType.success
        ? Icons.verified_rounded
        : type == ProcessType.warning
            ? Icons.warning_rounded
            : type == ProcessType.danger
                ? Icons.dangerous_rounded
                : Icons.info_rounded;
    BotToast.showNotification(
      margin: const EdgeInsets.all(8.0),
      contentPadding: const EdgeInsets.all(0.0),
      backgroundColor: color,
      duration: const Duration(milliseconds: DefaultData.durationBotToast),
      align: bottom ? Alignment.bottomCenter : Alignment.topCenter,
      title: (cancelFunc) {
        return BotToastContainer(title: title, message: message, icon: icon);
      },
    );
  }
}