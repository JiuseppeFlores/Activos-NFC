import 'package:activos_empresa_app/blocs/blocs.dart';
import 'package:activos_empresa_app/common/utils/utils.dart';
import 'package:activos_empresa_app/core/models/models.dart';
import 'package:activos_empresa_app/ui/forms/forms.dart';
import 'package:activos_empresa_app/ui/views/views.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatelessWidget {
  
  final User user;
  final Product product;

  const ProductPage({
    super.key,
    required this.user,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderDetailLabel(
                icon: Icons.person,
                title: 'Usuario',
                textButton: user.identityCard.isNotEmpty ? CustomTextButton(
                  icon: Icons.visibility,
                  text: 'Asignaciones',
                  onTap: () => BottomSheetManager.showBottomSheet(
                    context: context,
                    child: AssignmentsBottomSheetView(
                      user: user,
                    ),
                  ),
                ) : null,
              ),
              Divider(height: 16),
              RowDetailLabel(title: 'Nombre', detail: user.fullName),
              SizedBox(height: 8),
              RowDetailLabel(title: 'Cédula de Identidad', detail: user.identityCard),
              SizedBox(height: 24),
              HeaderDetailLabel(icon: Icons.sell, title: 'Producto'),
              Divider(height: 32),
              RowDetailLabel(title: 'Nombre', detail: product.name),
              SizedBox(height: 8),
              RowDetailLabel(title: 'Código de Barras', detail: product.barcode),
              SizedBox(height: 24),
              HeaderDetailLabel(icon: Icons.add_box, title: 'Inventario'),
              Divider(height: 32),
              RowDetailLabel(title: 'ID de Asignación', detail: '${user.assignmentId}'),
              SizedBox(height: 16),
              InventoryForm(
                onSubmit: (String observation) async {
                  final accountBloc = BlocProvider.of<AccountBloc>(context);
                  final success = await accountBloc.registerInventory(context, user.assignmentId, observation);
                  if(success){
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}