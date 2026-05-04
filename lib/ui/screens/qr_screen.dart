import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScreen extends StatefulWidget {

  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {

  final MobileScannerController _controller = MobileScannerController();

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {

      Barcode? barcode = barcodes.barcodes.firstOrNull;

      if(barcode?.displayValue != null){
        _controller.stop();
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) 
              => ProductScreen(
                    code: barcode?.displayValue ?? DefaultData.string,
                    type: ScanType.barcode,
                  ),
          )
        ).then((_) => _controller.start());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Escanear Código QR',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleBarcode
          ),
          Center(
            child: ClipPath(
              clipper: HoleClipper(),
              child: Container(
                color: Colors.black54, // Deja el centro "sin opacidad"
              ),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.greenAccent, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HoleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectXY(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 250,
          height: 250,
        ),
        12,
        12,
      ));
    return path..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(HoleClipper oldClipper) => false;
}
