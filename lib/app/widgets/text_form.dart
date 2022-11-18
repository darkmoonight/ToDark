import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextForm extends StatelessWidget {
  const MyTextForm({
    super.key,
    required this.hintText,
    required this.type,
    required this.icon,
    required this.autofocus,
    required this.password,
    required this.textEditingController,
    this.onTap,
    this.readOnly = false,
  });
  final String hintText;
  final TextInputType type;
  final Icon icon;
  final bool autofocus;
  final bool password;
  final TextEditingController textEditingController;
  final Function()? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextFormField(
        readOnly: readOnly,
        onTap: () {
          onTap!();
        },
        controller: textEditingController,
        obscureText: password,
        keyboardType: type,
        style: theme.textTheme.headline6,
        decoration: InputDecoration(
          prefixIcon: icon,
          fillColor: theme.primaryColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: theme.disabledColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: theme.disabledColor,
            ),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 15.sp,
          ),
        ),
        autofocus: autofocus,
      ),
    );
  }
}
