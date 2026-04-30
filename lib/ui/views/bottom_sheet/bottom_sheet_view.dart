import 'package:flutter/material.dart';

class BottomSheetView extends StatelessWidget {
  final Widget child;
  const BottomSheetView({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.all(16),
      child: Material(
        child: child,
      ),
    );
  }
}