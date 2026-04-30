import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HeaderDetailLabel extends StatelessWidget {

  final IconData icon;
  final String title;
  final CustomTextButton? textButton;

  const HeaderDetailLabel({
    super.key,
    required this.icon,
    required this.title,
    this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Icon(icon),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(width: 8),
        ...(textButton != null 
          ? [textButton!]
          : []
        ),
      ],
    );
  }
}