import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api_service/task_bloc.dart';
import '../../utils/theme/colors.dart';

class TaskDetailScreen extends StatelessWidget {

  final Map task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  String formatDate(String? date) {
    if (date == null) return "";
    final d = DateTime.tryParse(date);
    if (d == null) return "";
    return "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {

    final completed = task['completed'] ?? false;

    return Scaffold(
      backgroundColor: AppColors.topBar,

      body: Column(
        children: [

          /// HEADER (same as home)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            color: AppColors.topBar,

            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Task Details",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          /// CONTENT CARD
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    Text(
                      task['title'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// DESCRIPTION
                    if ((task['description'] ?? "").isNotEmpty)
                      Text(
                        task['description'],
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textMuted,
                        ),
                      ),

                    const SizedBox(height: 24),

                    /// PRIORITY
                    Row(
                      children: [
                        const Text(
                          "Priority: ",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(task['priority'] ?? "MEDIUM"),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// DUE DATE
                    if (task['dueDate'] != null)
                      Row(
                        children: [
                          const Text(
                            "Due Date: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(formatDate(task['dueDate'])),
                        ],
                      ),

                    const Spacer(),

                    /// ACTION BUTTONS
                    /// ACTION BUTTONS
                    Row(
                      children: [

                        /// DELETE
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: AppColors.textMain,
                              elevation: 0,
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              context.read<TaskBloc>().add(
                                TaskDeleteRequested(task['_id']),
                              );

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TOGGLE COMPLETE
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.textMain,
                              foregroundColor: AppColors.base,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              context.read<TaskBloc>().add(
                                TaskToggleRequested(task['_id']),
                              );

                              Navigator.pop(context);
                            },
                            child: Text(
                              completed ? "Mark Pending" : "Mark Complete",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}