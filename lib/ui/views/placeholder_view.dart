import 'package:flutter/material.dart';

class PlaceholderView extends StatelessWidget {

  final IconData icon;
  final String label;

  const PlaceholderView({
    super.key,
    this.icon = Icons.not_interested,
    this.label = 'Sin datos'
  });

  @override
  Widget build(BuildContext context) {

    final color = Theme.of(context).colorScheme.primary.withAlpha(80);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 48,
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.surface,
              size: 56,
            ),
          ),
          SizedBox(height: 16),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

}