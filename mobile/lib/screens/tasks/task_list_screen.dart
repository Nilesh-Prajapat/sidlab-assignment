import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api_service/task_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/task_tile.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  String _search = "";
  String? _priorityFilter;
  bool _showOverdue = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<TaskBloc>();

    if (bloc.state is! TaskLoaded) {
      bloc.add(TaskLoadRequested());
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _refresh() async {
    context.read<TaskBloc>().add(TaskLoadRequested());
  }

  String _formatDate(DateTime d) {
    return "${d.day}/${d.month}/${d.year}";
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {

        String? tempPriority = _priorityFilter;
        bool tempOverdue = _showOverdue;
        DateTime? tempDate = _selectedDate;

        return StatefulBuilder(
          builder: (context, setDialog) {

            return AlertDialog(
              backgroundColor: AppColors.layer1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),

              title: const Text(
                "Filter Tasks",
                style: TextStyle(
                  color: AppColors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  /// PRIORITY
                  DropdownButtonFormField<String>(
                    dropdownColor: AppColors.layer1,
                    value: tempPriority,
                    hint: const Text("Priority"),
                    iconEnabledColor: AppColors.textDim,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.layer1,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(value: "HIGH", child: Text("High")),
                      DropdownMenuItem(value: "MEDIUM", child: Text("Medium")),
                      DropdownMenuItem(value: "LOW", child: Text("Low")),
                    ],

                    onChanged: (v) {
                      setDialog(() => tempPriority = v);
                    },
                  ),

                  const SizedBox(height: 14),

                  /// DATE PICKER
                  InkWell(
                    onTap: () async {

                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tempDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        setDialog(() => tempDate = picked);
                      }
                    },

                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.layer1,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            tempDate == null
                                ? "Select due date"
                                : _formatDate(tempDate!),
                            style: const TextStyle(
                              color: AppColors.textMain,
                            ),
                          ),

                          const Icon(Icons.calendar_today, size: 18),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// OVERDUE
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.base,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),

                    child: SwitchListTile(
                      title: const Text(
                        "Show overdue only",
                        style: TextStyle(color: AppColors.textMain),
                      ),

                      value: tempOverdue,
                      activeColor: AppColors.textMain,

                      onChanged: (v) {
                        setDialog(() => tempOverdue = v);
                      },
                    ),
                  ),
                ],
              ),

              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),

              actions: [

                /// CLEAR
                OutlinedButton(
                  onPressed: () {

                    setState(() {
                      _priorityFilter = null;
                      _showOverdue = false;
                      _selectedDate = null;
                    });

                    Navigator.pop(context);
                  },

                  child: const Text("Clear"),
                ),

                /// APPLY
                ElevatedButton(
                  onPressed: () {

                    setState(() {
                      _priorityFilter = tempPriority;
                      _showOverdue = tempOverdue;
                      _selectedDate = tempDate;
                    });

                    Navigator.pop(context);
                  },

                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.topBar,

      body: Column(
        children: [

          const AppTopBar(
            title: "Tasks",
            subtitle: "Manage your tasks",
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),

              child: Column(
                children: [

                  /// SEARCH + FILTER
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: Row(
                      children: [

                        Expanded(
                          child: TextField(
                            onChanged: (v) {
                              setState(() => _search = v.toLowerCase());
                            },

                            decoration: InputDecoration(
                              hintText: "Search tasks",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: AppColors.layer1,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        GestureDetector(
                          onTap: _openFilterDialog,

                          child: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.layer1,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.tune),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// TASK LIST
                  Expanded(
                    child: BlocBuilder<TaskBloc, TaskState>(
                      builder: (context, state) {

                        if (state is TaskLoading) {
                          return const Center(
                            child: SizedBox(
                              width: 180,
                              child: LinearProgressIndicator(minHeight: 3),
                            ),
                          );
                        }

                        if (state is TaskLoaded) {

                          final now = DateTime.now();

                          final tasks = state.tasks.where((task) {

                            /// SEARCH
                            if (_search.isNotEmpty) {
                              final title =
                              (task['title'] ?? "").toLowerCase();

                              if (!title.contains(_search)) {
                                return false;
                              }
                            }

                            /// PRIORITY
                            if (_priorityFilter != null) {
                              if (task['priority'] != _priorityFilter) {
                                return false;
                              }
                            }

                            /// DATE FILTER
                            if (_selectedDate != null) {

                              final due = DateTime.tryParse(
                                  task['dueDate'] ?? "");

                              if (due == null ||
                                  due.year != _selectedDate!.year ||
                                  due.month != _selectedDate!.month ||
                                  due.day != _selectedDate!.day) {
                                return false;
                              }
                            }

                            /// OVERDUE
                            if (_showOverdue) {

                              final due = DateTime.tryParse(
                                  task['dueDate'] ?? "");

                              if (due == null || !due.isBefore(now)) {
                                return false;
                              }
                            }

                            return true;

                          }).toList();

                          if (tasks.isEmpty) {
                            return const Center(
                              child: Text("No matching tasks"),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _refresh,

                            child: ListView.separated(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),

                              physics:
                              const AlwaysScrollableScrollPhysics(),

                              itemCount: tasks.length,

                              separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),

                              itemBuilder: (context, i) {

                                final task = tasks[i];

                                return Dismissible(
                                  key: Key(task['_id']),
                                  direction: DismissDirection.endToStart,

                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                    const EdgeInsets.only(right: 20),

                                    decoration: BoxDecoration(
                                      color: Colors.red.shade400,
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),

                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),

                                  confirmDismiss: (_) async {

                                    return await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                          const Text("Delete Task"),

                                          content: const Text(
                                            "Are you sure you want to delete this task?",
                                          ),

                                          actions: [

                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, false),
                                              child: const Text("Cancel"),
                                            ),

                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, true),
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },

                                  onDismissed: (_) {

                                    context.read<TaskBloc>().add(
                                      TaskDeleteRequested(task['_id']),
                                    );
                                  },

                                  child: TaskTile(
                                    task: task,
                                    onTap: () {

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              TaskDetailScreen(task: task),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }

                        if (state is TaskError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, top: 6),
                    child: Text(
                      "Pull down to refresh • Swipe left to delete",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textDim,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}