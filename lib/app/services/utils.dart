import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool> showAdaptiveDialogTextIsNotEmpty(
    {required BuildContext context, required Function onPressed}) async {
  return await showAdaptiveDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog.adaptive(
        title: Text(
          'clearText'.tr,
          style: context.textTheme.titleLarge,
        ),
        content:
            Text('clearTextWarning'.tr, style: context.textTheme.titleMedium),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('cancel'.tr,
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.blueAccent))),
          TextButton(
              onPressed: () => onPressed(),
              child: Text('delete'.tr,
                  style: context.theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.red))),
        ],
      );
    },
  );
}
