import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text('Cargando, espere por favor...'),
      ],
    );
  }

}