import 'package:activos_nfc_app/common/data/data.dart';
import 'package:activos_nfc_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class InventoryForm extends StatefulWidget {

  final Function(String observation)? onSubmit;

  const InventoryForm({
    super.key,
    this.onSubmit,
  });

  @override
  State<InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<InventoryForm> {

  late GlobalKey<FormState> _formKey;
  late TextEditingController _observation;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _observation = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _observation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextFormField(
            label: 'Observación',
            controller: _observation,
            fieldController: FieldData.observation,
            disabled: _loading,
            lines: 3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: 'Registrar',
              onTap: _onSubmit,
              color: Theme.of(context).colorScheme.primary,
              disabled: _loading,
              loading: _loading,
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (widget.onSubmit != null) {
        setState(() => _loading = true);
        await widget.onSubmit!.call(_observation.text);
        setState(() => _loading = false);
      }
    }
  }

}