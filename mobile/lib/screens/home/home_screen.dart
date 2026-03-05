import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api_service/task_bloc.dart';
import '../../api_service/auth_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/section_header.dart';
import '../../widget/status_badge.dart';
import '../../widget/task_tile.dart';
import '../tasks/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onSeeAll;
  final VoidCallback onAddTask;

  const HomeScreen({
    super.key,
    required this.onSeeAll,
    required this.onAddTask,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();

    /// Load tasks when Home opens
    Future.microtask(() {
      context.read<TaskBloc>().add(TaskLoadRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.topBar,
      body: Column(
        children: [

          /// LINEAR LOADER
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: state is TaskLoading
                    ? const LinearProgressIndicator(minHeight: 2)
                    : const SizedBox(height: 2),
              );
            },
          ),

          /// TOP BAR
          BlocSelector<AuthBloc, AuthState, String>(
            selector: (state) {
              if (state is AuthAuthenticated) {
                return state.user['name'] ?? "User";
              }
              return "User";
            },
            builder: (context, name) {
              return AppTopBar(
                title: name,
                subtitle: "Welcome",
              );
            },
          ),

          /// CONTENT CARD
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// STATS
                    BlocSelector<TaskBloc, TaskState, List<dynamic>>(
                      selector: (state) {
                        if (state is TaskLoaded) return state.tasks;
                        return [];
                      },
                      builder: (context, tasks) {

                        final total = tasks.length;
                        final done = tasks.where((t) => t['completed'] == true).length;
                        final pending = total - done;

                        return StatStrip(
                          stats: [
                            (label: 'Total', value: total.toString()),
                            (label: 'Done', value: done.toString()),
                            (label: 'Pending', value: pending.toString()),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    SectionHeader(
                      title: 'Recent tasks',
                      action: 'See all',
                      onAction: widget.onSeeAll,
                    ),

                    const SizedBox(height: 8),

                    Expanded(
                      child: BlocSelector<TaskBloc, TaskState, List<dynamic>>(
                        selector: (state) {
                          if (state is TaskLoaded) return state.tasks;
                          return [];
                        },
                        builder: (context, tasks) {

                          final state = context.watch<TaskBloc>().state;

                          if (state is TaskLoading) {
                            return Center(
                              child: SizedBox(
                                width: 200,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [

                                    Text(
                                      "Loading tasks...",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textDim,
                                      ),
                                    ),

                                    SizedBox(height: 12),

                                    LinearProgressIndicator(
                                      minHeight: 3,
                                      backgroundColor: AppColors.layer2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(AppColors.textMain),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          /// EMPTY STATE
                          if (tasks.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Icon(
                                    Icons.task_alt_outlined,
                                    size: 48,
                                    color: AppColors.textDead,
                                  ),

                                  const SizedBox(height: 12),

                                  const Text(
                                    "No tasks yet",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.textDim,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.textMain,
                                      foregroundColor: AppColors.base,
                                    ),
                                    onPressed: widget.onAddTask,
                                    child: const Text("Add Task"),
                                  ),
                                ],
                              ),
                            );
                          }

                          final recent = tasks.take(3).toList();

                          return ListView.separated(
                            padding: const EdgeInsets.only(top: 6),
                            itemCount: recent.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),

                            itemBuilder: (context, i) {

                              final task = recent[i];

                              return Dismissible(
                                key: Key(task['_id']),
                                direction: DismissDirection.endToStart,

                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  color: Colors.red.shade400,
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
                                        title: const Text("Delete Task"),
                                        content: const Text(
                                            "Are you sure you want to delete this task?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
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
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}