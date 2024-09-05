import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.labelText,
    required this.type,
    required this.icon,
    required this.controller,
    required this.margin,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.validator,
    this.iconButton,
    this.elevation,
    this.focusNode,
    this.maxLine = 1,
  });
  final String labelText;
  final TextInputType type;
  final Icon icon;
  final IconButton? iconButton;
  final TextEditingController controller;
  final Function()? onTap;
  final Function(String)? onChanged;
  final EdgeInsets margin;
  final String? Function(String?)? validator;
  final bool readOnly;
  final double? elevation;
  final FocusNode? focusNode;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: margin,
      child: TextFormField(
        focusNode: focusNode,
        readOnly: readOnly,
        onChanged: onChanged,
        onTap: readOnly ? onTap : null,
        controller: controller,
        keyboardType: type,
        style: context.textTheme.labelLarge,
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: iconButton,
          labelText: labelText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        validator: validator,
        maxLines: maxLine,
      ),
    );
  }
}
