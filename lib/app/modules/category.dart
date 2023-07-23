import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/statistics.dart';
import 'package:todark/app/widgets/task_type_list.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final service = IsarServices();
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodos();
    final countDone = await service.getCountDoneTodos();
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: TextField(
            style: context.textTheme.labelLarge,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Iconsax.search_normal_1,
                size: 20,
              ),
              labelText: 'searchTask'.tr,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
        Statistics(
          countTotalTodos: countTotalTodos,
          countDoneTodos: countDoneTodos,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 15, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'categories'.tr,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                thumbIcon: service.thumbIconTask,
                value: service.toggleValue.value,
                onChanged: (value) {
                  setState(() {
                    service.toggleValue.value = value;
                  });
                },
              ),
            ],
          ),
        ),
        TaskTypeList(
          toggle: service.toggleValue.value,
        ),
      ],
    );
  }
}
