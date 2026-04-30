import 'package:activos_empresa_app/common/data/data.dart';
import 'package:activos_empresa_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {

  final Function(String username, String password)? onSubmit;

  const LoginForm({
    super.key,
    this.onSubmit,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {

  late GlobalKey<FormState> _formKey;
  late TextEditingController _username;
  late TextEditingController _password;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _username = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _username.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Usuario',
            controller: _username,
            fieldController: FieldData.username,
            disabled: _loading,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            label: 'Contraseña',
            controller: _password,
            fieldController: FieldData.password,
            isPassword: true,
            disabled: _loading,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomFilledButton(
              text: 'Ingresar',
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
        await widget.onSubmit!.call(_username.text, _password.text);
        setState(() => _loading = false);
      }
    }
  }

}