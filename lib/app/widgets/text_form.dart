import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.labelText,
    required this.type,
    required this.icon,
    required this.controller,
    required this.padding,
    this.onTap,
    this.readOnly = false,
    this.validator,
    this.iconButton,
  });
  final String labelText;
  final TextInputType type;
  final Icon icon;
  final IconButton? iconButton;
  final TextEditingController controller;
  final Function()? onTap;
  final EdgeInsets padding;
  final String? Function(String?)? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        readOnly: readOnly,
        onTap: readOnly == true ? onTap : null,
        controller: controller,
        keyboardType: type,
        style: context.textTheme.titleMedium,
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: iconButton,
          labelText: labelText,
        ),
        validator: validator,
      ),
    );
  }
}
