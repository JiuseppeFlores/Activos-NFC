import 'package:activos_nfc_app/blocs/blocs.dart';
import 'package:activos_nfc_app/core/models/models.dart';
import 'package:activos_nfc_app/ui/views/placeholder_view.dart';
import 'package:activos_nfc_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentsBottomSheetView extends StatefulWidget {

  final User user;

  const AssignmentsBottomSheetView({
    super.key,
    required this.user,
  });

  @override
  State<AssignmentsBottomSheetView> createState() => _AssignmentsBottomSheetViewState();
}

class _AssignmentsBottomSheetViewState extends State<AssignmentsBottomSheetView> {

  @override
  void initState() {
    super.initState();
    context.read<AssignedAssetsCubit>().loadAssignedAssets(widget.user.identityCard);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.user.fullName.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Divider(height: 32),
        Expanded(
          child: BlocBuilder<AssignedAssetsCubit, AssignedAssetsState>(
            builder: (context, state) {
              if (state.status == AssignedAssetsStatus.loading) {
                return const CircularProgressLabel(
                  label: 'Cargando bienes asignados,\nespere por favor...',
                );
              }

              if (state.status == AssignedAssetsStatus.error) {
                return PlaceholderView(
                  icon: Icons.error_outline,
                  label: state.errorMessage ?? 'Error al cargar asignaciones',
                );
              }

              final assets = state.assets;
              if (assets.isEmpty) {
                return const PlaceholderView(
                  icon: Icons.assignment_late,
                  label: 'Sin asignaciones',
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienes asignados',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final item = assets[index];
                        return ListTile(
                          leading: Icon(
                            Icons.assignment,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            item.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            item.barcode,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 4),
                      itemCount: assets.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}