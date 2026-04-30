import 'package:activos_empresa_app/common/data/data.dart';
import 'package:activos_empresa_app/common/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isPassword;
  final bool disabled;
  final TextEditingController controller;
  final FieldController fieldController;
  final TextInputType keyboardType;
  final String? prefix;
  final VoidCallback? onTap;
  final IconData? iconSuffix;
  final VoidCallback? onSuffix;
  final bool readonly;
  final int lines;
  final FocusNode? focusNode;
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText = DefaultData.string,
    this.isPassword = DefaultData.bool,
    this.disabled = DefaultData.bool,
    required this.fieldController,
    this.keyboardType = TextInputType.text,
    this.iconSuffix,
    this.prefix,
    this.onTap,
    this.onSuffix,
    this.readonly = DefaultData.bool,
    this.lines = 1,
    this.focusNode,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscure;

  @override
  void initState() {
    isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            ...(widget.fieldController.required 
                  ? [
                      Text(
                        '*',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    ]
                  : []
              ),
          ],
        ),
        const SizedBox(height: 4),
        TextFormField(
          focusNode: widget.focusNode,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: widget.lines,
          minLines: widget.lines,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          maxLength: widget.fieldController.max,
          enabled: !widget.disabled,
          obscureText: isObscure,
          validator: (value) =>
              widget.fieldController.validate(value.toString()),
          readOnly: widget.readonly,
          decoration: InputDecoration(
            errorMaxLines: 3,
            contentPadding: const EdgeInsets.all(8),
            hintText: widget.hintText,
            counterText: DefaultData.string,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(120),
            ),
            prefix: widget.prefix == null
                ? null
                : Text(
                    '${widget.prefix!} ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
            suffixIcon: widget.isPassword || widget.onSuffix != null
                ? IconButton(
                    onPressed: widget.onSuffix ?? () => setState(() => isObscure = !isObscure),
                    icon: Icon(
                      widget.iconSuffix ?? (isObscure ? Icons.visibility : Icons.visibility_off),
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(20),
              ),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.onSurface.withAlpha(16),
          ),
          onTap: widget.onTap,
        ),
      ],
    );
  }
}
