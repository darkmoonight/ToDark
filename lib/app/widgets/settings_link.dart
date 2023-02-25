import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SettingLinks extends StatelessWidget {
  const SettingLinks({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });
  final Icon icon;
  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        onTap: onPressed,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: context.theme.colorScheme.background,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    icon,
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        text,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
