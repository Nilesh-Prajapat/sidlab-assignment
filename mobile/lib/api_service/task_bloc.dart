import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow/api_service/task_service.dart';

/// EVENTS
sealed class TaskEvent {}

class TaskLoadRequested extends TaskEvent {}

class TaskCreateRequested extends TaskEvent {
  final String title;
  final String description;
  final String priority;
  final String? dueDate;

  TaskCreateRequested({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
  });
}

class TaskUpdateRequested extends TaskEvent {
  final String id;
  final Map<String, dynamic> data;

  TaskUpdateRequested({
    required this.id,
    required this.data,
  });
}

class TaskDeleteRequested extends TaskEvent {
  final String id;

  TaskDeleteRequested(this.id);
}

class TaskToggleRequested extends TaskEvent {
  final String id;

  TaskToggleRequested(this.id);
}

/// STATES
sealed class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<dynamic> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}

/// BLOC
class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final TaskService _service;

  TaskBloc(this._service) : super(TaskInitial()) {

    on<TaskLoadRequested>(_onLoad);
    on<TaskCreateRequested>(_onCreate);
    on<TaskUpdateRequested>(_onUpdate);
    on<TaskDeleteRequested>(_onDelete);
    on<TaskToggleRequested>(_onToggle);
  }

  /// SORT TASKS
  List<dynamic> _sortTasks(List<dynamic> tasks) {

    final now = DateTime.now();

    int priorityScore(String? p) {
      switch (p) {
        case "HIGH":
          return 3;
        case "MEDIUM":
          return 2;
        case "LOW":
          return 1;
        default:
          return 0;
      }
    }

    tasks.sort((a, b) {

      /// 1️⃣ incomplete first
      final completedA = a['completed'] ?? false;
      final completedB = b['completed'] ?? false;

      if (completedA != completedB) {
        return completedA ? 1 : -1;
      }

      /// parse due date
      final dueA = a['dueDate'] != null
          ? DateTime.tryParse(a['dueDate'])
          : null;

      final dueB = b['dueDate'] != null
          ? DateTime.tryParse(b['dueDate'])
          : null;

      /// 2️⃣ overdue
      final overdueA = dueA != null && dueA.isBefore(now);
      final overdueB = dueB != null && dueB.isBefore(now);

      if (overdueA != overdueB) {
        return overdueA ? -1 : 1;
      }

      /// 3️⃣ priority
      final pa = priorityScore(a['priority']);
      final pb = priorityScore(b['priority']);

      if (pa != pb) {
        return pb.compareTo(pa);
      }

      /// 4️⃣ due date
      if (dueA != null && dueB != null) {
        return dueA.compareTo(dueB);
      }

      return 0;
    });

    return tasks;
  }
  Future<void> _onLoad(
      TaskLoadRequested e,
      Emitter emit,
      ) async {

    emit(TaskLoading());

    try {

      final tasks = await _service.getTasks();

      emit(TaskLoaded(_sortTasks(tasks)));

    } catch (err) {

      emit(
        TaskError(
          err.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  /// CREATE TASK
  Future<void> _onCreate(
      TaskCreateRequested e,
      Emitter emit,
      ) async {

    try {

      final newTask = await _service.createTask(
        title: e.title,
        description: e.description,
        priority: e.priority,
        dueDate: e.dueDate,
      );

      if (state is TaskLoaded) {

        final tasks = List.from((state as TaskLoaded).tasks);

        tasks.add(newTask);

        emit(TaskLoaded(_sortTasks(tasks)));
      }

    } catch (err) {

      emit(
        TaskError(
          err.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  /// UPDATE TASK
  Future<void> _onUpdate(
      TaskUpdateRequested e,
      Emitter emit,
      ) async {

    try {

      final updatedTask = await _service.updateTask(
        id: e.id,
        data: e.data,
      );

      if (state is TaskLoaded) {

        final tasks = (state as TaskLoaded)
            .tasks
            .map((task) {

          if (task['_id'] == e.id) {
            return updatedTask;
          }

          return task;

        }).toList();

        emit(TaskLoaded(_sortTasks(tasks)));
      }

    } catch (err) {

      emit(
        TaskError(
          err.toString().replaceFirst("Exception: ", ""),
        ),
      );
    }
  }

  /// DELETE TASK
  Future<void> _onDelete(
      TaskDeleteRequested e,
      Emitter emit,
      ) async {

    if (state is! TaskLoaded) return;

    final currentTasks = (state as TaskLoaded).tasks;

    final updatedTasks =
    currentTasks.where((task) => task['_id'] != e.id).toList();

    emit(TaskLoaded(_sortTasks(updatedTasks)));

    try {
      await _service.deleteTask(e.id);
    } catch (_) {}
  }

  /// TOGGLE COMPLETE
  Future<void> _onToggle(
      TaskToggleRequested e,
      Emitter emit,
      ) async {

    if (state is! TaskLoaded) return;

    final currentTasks = (state as TaskLoaded).tasks;

    final updatedTasks =
    currentTasks.map((task) {

      if (task['_id'] == e.id) {

        final newTask = Map<String, dynamic>.from(task);

        newTask['completed'] =
        !(task['completed'] ?? false);

        return newTask;
      }

      return task;

    }).toList();

    emit(TaskLoaded(_sortTasks(updatedTasks)));

    try {
      await _service.toggleComplete(e.id);
    } catch (_) {}
  }
}