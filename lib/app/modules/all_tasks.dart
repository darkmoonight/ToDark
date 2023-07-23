import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
              labelText: 'searchTodo'.tr,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'allTasks'.tr,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                thumbIcon: service.thumbIconTodo,
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
        Expanded(
          child: TodosList(
            calendare: false,
            allTask: true,
            toggle: service.toggleValue.value,
          ),
        ),
      ],
    );
  }
}
