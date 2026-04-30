import 'package:flutter/material.dart';

class RowDetailLabel extends StatelessWidget {

  final String title;
  final String detail;

  const RowDetailLabel({
    super.key,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
            TextSpan(
              text: '$title: ',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: detail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ]
      ),
    );
  }
}