import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api_service/task_bloc.dart';
import '../utils/theme/colors.dart';

class TaskTile extends StatelessWidget {
  final Map task;
  final VoidCallback? onTap;

  const TaskTile({
    super.key,
    required this.task,
    this.onTap,
  });

  String formatDate(String? date) {
    if (date == null) return "No due date";
    final d = DateTime.tryParse(date);
    if (d == null) return "No due date";
    return "${d.day}/${d.month}/${d.year}";
  }

  bool isOverdue() {
    if (task['completed'] == true) return false;
    if (task['dueDate'] == null) return false;

    final due = DateTime.tryParse(task['dueDate']);
    if (due == null) return false;

    return DateTime.now().isAfter(due);
  }

  @override
  Widget build(BuildContext context) {
    final completed = task['completed'] ?? false;
    final overdue = isOverdue();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),

      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: completed ? 0.55 : 1,

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.layer1,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderMuted),
          ),

          child: Row(
            children: [

              /// CHECKBOX
              Checkbox(
                value: completed,
                onChanged: (_) {
                  context.read<TaskBloc>().add(
                    TaskToggleRequested(task['_id']),
                  );
                },
              ),

              const SizedBox(width: 8),

              /// CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    Text(
                      task['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: completed
                            ? AppColors.textDim
                            : AppColors.textMain,
                      ),
                    ),

                    /// DESCRIPTION
                    if ((task['description'] ?? "").isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          task['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textDim,
                          ),
                        ),
                      ),

                    const SizedBox(height: 4),

                    /// DUE DATE
                    Text(
                      overdue
                          ? "OVERDUE • ${formatDate(task['dueDate'])}"
                          : "Due ${formatDate(task['dueDate'])}",
                      style: TextStyle(
                        fontSize: 12,
                        color: overdue
                            ? Colors.red
                            : AppColors.textDim,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              /// PRIORITY BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.layer2,
                ),
                child: Text(
                  task['priority'] ?? "MEDIUM",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}