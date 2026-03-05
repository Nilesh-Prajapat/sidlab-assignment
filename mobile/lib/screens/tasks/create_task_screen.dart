import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api_service/task_bloc.dart';
import '../../utils/theme/colors.dart';
import '../../widget/app_button.dart';
import '../../widget/app_input.dart';
import '../../widget/app_top_bar.dart';
import '../../widget/priority_selector.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {

  final _title = TextEditingController();
  final _desc = TextEditingController();

  String _priority = "MEDIUM";
  DateTime? _dueDate;

  Future<void> _pickDate() async {

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  String _dateText() {
    if (_dueDate == null) return "mm/dd/yyyy";
    return "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}";
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _showSuccess() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Task created successfully"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close dialog

              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop(); // go back to task list
              }
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _createTask() {

    /// hide keyboard
    FocusScope.of(context).unfocus();

    if (_title.text.trim().isEmpty) {
      _showError("Task title is required");
      return;
    }

    if (_desc.text.trim().isEmpty) {
      _showError("Task description is required");
      return;
    }

    if (_dueDate == null) {
      _showError("Please select a due date");
      return;
    }

    context.read<TaskBloc>().add(
      TaskCreateRequested(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        priority: _priority,
        dueDate: _dueDate!.toIso8601String(),
      ),
    );

    /// clear form
    _title.clear();
    _desc.clear();

    setState(() {
      _priority = "MEDIUM";
      _dueDate = null;
    });

    /// show success dialog
    _showSuccess();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.topBar,

      body: Column(
        children: [

          const AppTopBar(
            title: "Create Task",
            subtitle: "Add a new task",
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),

              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TITLE
                    AppInput(
                      label: 'Title',
                      placeholder: 'Task name',
                      controller: _title,
                    ),

                    const SizedBox(height: 20),

                    /// DESCRIPTION
                    Text(
                      'DESCRIPTION',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textDim,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: _desc,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Add a description...",
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// DUE DATE
                    Text(
                      'DUE DATE',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textDim,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 6),

                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.layer1,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_dateText()),
                            const Icon(Icons.calendar_today_outlined),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PRIORITY
                    Text(
                      'PRIORITY',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.textDim,
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    PrioritySelector(
                      selected: _priority,
                      onChanged: (v) {
                        setState(() => _priority = v);
                      },
                    ),

                    const SizedBox(height: 40),

                    /// CREATE BUTTON
                    AppButton(
                      label: "Create task",
                      onTap: _createTask,
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