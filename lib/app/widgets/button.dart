import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.buttonName,
    required this.onTap,
    required this.bgColor,
  });
  final String buttonName;
  final Function() onTap;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          buttonName,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
