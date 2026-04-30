import 'package:activos_empresa_app/common/data/data.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CircularProgressLabel extends StatelessWidget {

  final String? label;

  const CircularProgressLabel({
    super.key,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCircularProgress(
              color: Theme.of(context).colorScheme.primary.withAlpha(160),
            ),
            const SizedBox(height: 32),
            Text(
              label ?? DefaultData.loadingLabel,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
              textAlign: TextAlign.center,
            )
          ],  
        ),
      ),
    );
  }

}