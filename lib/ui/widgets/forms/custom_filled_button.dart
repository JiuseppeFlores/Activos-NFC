import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool disabled;
  final bool loading;
  final Color? color;
  final bool upperCase;
  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onTap,
    this.disabled = false,
    this.loading = false,
    this.color,
    this.upperCase = false,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: disabled ? null : onTap,
      child: loading
          ? SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.surface,
                strokeWidth: 2.0,
              ),
            )
          : Text(
              upperCase ? text.toUpperCase() : text,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
            ),
    );
  }
}
