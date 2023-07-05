import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingLinks extends StatelessWidget {
  const SettingLinks({
    super.key,
    required this.icon,
    required this.text,
    required this.info,
    this.onPressed,
    this.textInfo,
  });
  final Widget icon;
  final String text;

  final bool info;
  final String? textInfo;

  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  icon,
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      text,
                      style: context.theme.textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            info
                ? Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      textInfo!,
                      style: context.theme.textTheme.titleMedium,
                      overflow: TextOverflow.visible,
                    ),
                  )
                : Icon(
                    Iconsax.arrow_right_3,
                    size: 18,
                    color: context.theme.iconTheme.color,
                  ),
          ],
        ),
      ),
    );
  }
}
