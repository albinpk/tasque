import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/common_export.dart';
import '../../data/task_repository.dart';
import '../../model/task.dart';
import '../../model/task_priority_enum.dart';
import '../../model/task_status_enum.dart';

part 'task_cubit.freezed.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({required TaskRepository taskRepository})
    : _taskRepository = taskRepository,
      super(const TaskState.initial());

  final TaskRepository _taskRepository;

  Future<void> loadTasks() async {
    try {
      emit(const TaskState.loading());
      emit(await _getTaskData());
    } on Exception catch (e) {
      emit(TaskState.error(message: e.toString()));
    }
  }

  Future<void> createTask({
    required String title,
    required String? description,
    required DateTime dueDate,
    required TaskPriority priority,
    TaskStatus? status,
  }) async {
    try {
      await _taskRepository.createTask(
        title: title,
        description: description?.nullIfEmpty,
        dueDate: dueDate,
        status: status ?? TaskStatus.pending,
        priority: priority,
      );
      emit(await _getTaskData());
    } on Exception catch (e) {
      emit(TaskState.error(message: e.toString()));
    }
  }

  Future<TaskStateLoaded> _getTaskData() async {
    final tasks = await _taskRepository.getTasks();
    final now = DateTime.now();
    return TaskStateLoaded(
      tasks: tasks,
      // recent 15 tasks
      recentTasks:
          tasks
              .sorted((a, b) => b.createdAt.compareTo(a.createdAt))
              .take(15)
              .toList(),
      summary: (
        inProgress: tasks.where((t) => t.status.isPending).length,
        // urgent tasks are tasks that are due in the next 3 days
        urgent:
            tasks.where((t) => t.dueDate.difference(now).inDays <= 3).length,
        completed: tasks.where((t) => t.status.isCompleted).length,
        overdue:
            tasks
                .where((t) => t.dueDate.endOfDay.isBefore(now.endOfDay))
                .length,
      ),
    );
  }
}
