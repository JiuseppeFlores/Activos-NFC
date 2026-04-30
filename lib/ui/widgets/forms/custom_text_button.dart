import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final Color? color;
  final bool disabled;
  final bool loading;
  final bool upperCase;
  final IconAlignment? iconAlignment;
  const CustomTextButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.color,
    this.disabled = false,
    this.loading = false,
    this.upperCase = false,
    this.iconAlignment = IconAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return (color ?? Theme.of(context).colorScheme.primary).withAlpha(32);
            }
            return Colors.transparent;
          },
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          )
        ),
      ),
      onPressed: disabled ? null : onTap,
      iconAlignment: iconAlignment,
      icon:
          icon != null
              ? Icon(
                icon,
                color: disabled
                          ? Theme.of(context).colorScheme.onSurface.withAlpha(160) 
                          : color ?? Theme.of(context).colorScheme.primary,
                size: 20.0,
              )
              : null,
      label:
          loading
              ? SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  color: color ?? Theme.of(context).colorScheme.primary,
                  strokeWidth: 2.0,
                ),
              )
              : Text(
                upperCase ? text.toUpperCase() : text,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      disabled
                          ? Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(160)
                          : color ?? Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
    );
  }
}