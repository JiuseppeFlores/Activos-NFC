import 'package:activos_empresa_app/blocs/blocs.dart';
import 'package:activos_empresa_app/core/models/models.dart';
import 'package:activos_empresa_app/ui/views/placeholder_view.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
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

  late bool _loading;
  late AccountBloc _accountBloc;
  late List<Product> _assets;

  void _loadAssets() async {
    setState(() => _loading = true);
    final assets = await _accountBloc.getAssignments(context, widget.user.identityCard);
    setState(() {
      //_assets = [...assets,...assets,...assets,...assets,...assets,...assets,...assets];
      _assets = assets;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loading = false;
    _assets = [];
    _accountBloc = BlocProvider.of<AccountBloc>(context);
    _loadAssets();
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
        Divider(height: 32),
        Expanded(
          child: _loading 
            ? CircularProgressLabel(
                label: 'Cargando bienes asignados,\nespere por favor...',
              )
            : _assets.isEmpty
                ? PlaceholderView(
                    icon: Icons.assignment_late,
                    label: 'Sin asignaciones',
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienes asignados',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final item = _assets[index];
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
                            separatorBuilder: (context, index) => SizedBox(height: 4),
                            itemCount: _assets.length,
                          ),
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}