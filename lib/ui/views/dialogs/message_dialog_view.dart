import 'package:activos_empresa_app/common/data/data.dart';
import 'package:flutter/material.dart';

class MessageDialogView extends StatelessWidget {
  
  final String title;
  final IconData icon;
  final String message;
  
  const MessageDialogView({
    super.key,
    required this.title,
    this.icon = Icons.info,
    this.message = DefaultData.string,
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
        SizedBox(height: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}