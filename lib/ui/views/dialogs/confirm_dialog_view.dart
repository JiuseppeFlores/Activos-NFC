import 'package:activos_empresa_app/common/data/data.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfirmDialogView extends StatelessWidget {
  
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onConfirm;
  final String? titleButtonConfirm;
  
  const ConfirmDialogView({
    super.key,
    required this.title,
    this.message = DefaultData.string,
    this.icon = Icons.info,
    this.onConfirm,
    this.titleButtonConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          radius: 32,
          child: Icon(
            icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: CustomFilledButton(
                text: titleButtonConfirm ?? 'Confirmar',
                onTap: () {
                  if (onConfirm != null) {
                    onConfirm!();
                  }
                },
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: CustomTextButton(
                text: 'Cancelar',
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}