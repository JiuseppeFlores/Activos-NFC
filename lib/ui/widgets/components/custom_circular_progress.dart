import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {

  final Color? color;

  const CustomCircularProgress({
    super.key,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color ?? Theme.of(context).colorScheme.primary,
      strokeWidth: 2,
    );
  }

}