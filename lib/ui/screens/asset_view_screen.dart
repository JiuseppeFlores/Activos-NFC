import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/common/enums/enums.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetViewScreen extends StatefulWidget {

  final String code;
  final ScanType type;

  const AssetViewScreen({
    super.key,
    required this.code,
    required this.type,
  });

  @override
  State<AssetViewScreen> createState() => _AssetViewScreenState();
}

class _AssetViewScreenState extends State<AssetViewScreen> {

  @override
  void initState() {
    super.initState();
    context.read<AssetCubit>().loadAsset(widget.code, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inspección de Activos',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocConsumer<AssetCubit, AssetState>(
        listener: (context, state) {
          if (state.status == AssetStatus.error) {
             // Error handling
          }
        },
        builder: (context, state) {
          if (state.status == AssetStatus.loading) {
             return const LoadingPage();
          }

          if (state.status == AssetStatus.error) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.5)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text(
                        'INFORMACIÓN',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        state.errorMessage ?? 'Error al cargar activo',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final asset = state.asset;
          if (asset == null) return const SizedBox();

          return Container(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: AssetViewPage(
                user: asset.assignedUser ?? User(),
                asset: asset,
              ),
            ),
          );
        },
      ),
    );
  }
}