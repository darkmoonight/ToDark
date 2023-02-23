import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.labelText,
    required this.type,
    required this.icon,
    required this.controller,
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
  final String? Function(String?)? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextFormField(
        contextMenuBuilder:
            (BuildContext context, EditableTextState editableTextState) {
          return AdaptiveTextSelectionToolbar(
            anchors: editableTextState.contextMenuAnchors,
            children: editableTextState.contextMenuButtonItems
                .map((ContextMenuButtonItem buttonItem) {
              return MaterialButton(
                textColor: Colors.white,
                onPressed: buttonItem.onPressed,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  AdaptiveTextSelectionToolbar.getButtonLabel(
                    context,
                    buttonItem,
                  ),
                ),
              );
            }).toList(),
          );
        },
        readOnly: readOnly,
        onTap: readOnly == true ? onTap : null,
        controller: controller,
        keyboardType: type,
        style: context.theme.textTheme.titleMedium,
        decoration: InputDecoration(
          prefixIcon: icon,
          suffixIcon: iconButton,
          fillColor: context.theme.colorScheme.primaryContainer,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: context.theme.disabledColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: context.theme.disabledColor,
            ),
          ),
          labelText: labelText,
          labelStyle: context.theme.textTheme.labelLarge?.copyWith(
            color: Colors.grey,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
