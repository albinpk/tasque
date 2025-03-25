import 'dart:async';
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/notifications/notification_service.dart';
import '../../../../shared/common_export.dart';
import '../../data/local/task_repository.dart';
import '../../data/sync/task_sync_repository.dart';
import '../../model/task.dart';
import '../../model/task_priority_enum.dart';
import '../../model/task_status_enum.dart';

part 'task_cubit.freezed.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({
    required TaskSyncRepository syncRepository,
    required TaskRepository taskRepository,
    required NotificationService notificationService,
  }) : _notificationService = notificationService,
       _syncRepository = syncRepository,
       _taskRepository = taskRepository,
       super(const TaskState.initial());

  final TaskRepository _taskRepository;
  final TaskSyncRepository _syncRepository;
  final NotificationService _notificationService;

  void clearState() => emit(const TaskState.initial());

  Future<void> loadTasks() async {
    try {
      emit(const TaskState.loading());

      // fetch tasks from server
      final tasks = await _syncRepository.getAllTasks();
      if (tasks.isNotEmpty) await _taskRepository.addAllTasks(tasks);

      emit(await _getTaskData());
      // TODO(albin): Schedule notifications
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
      final task = await _taskRepository.createTask(
        title: title,
        description: description?.nullIfEmpty,
        dueDate: dueDate,
        status: status ?? TaskStatus.pending,
        priority: priority,
      );
      unawaited(_syncRepository.addTask(task)); // sync to server
      emit(await _getTaskData());
      unawaited(_scheduleNotification(task));
    } on Exception catch (e) {
      emit(TaskState.error(message: e.toString()));
    }
  }

  /// Schedules a notification for a task.
  /// If the task is due today, the notification is scheduled for midnight.
  /// Otherwise, the notification is scheduled for the due date at 5pm.
  Future<void> _scheduleNotification(Task task) async {
    final now = DateTime.now();
    if (task.dueDate.isBefore(now)) return;
    await _notificationService.schedule(
      id: task.id,
      title:
          '⏰ Task Reminder: '
          '“${task.title.substring(0, min(task.title.length, 20))}…” '
          'Due Today!',
      body:
          'Your task “${task.title}” is due today. '
          'Stay on track and complete it on time. ✅',
      time:
          task.dueDate.isToday && now.hour >= 17
              ? task.dueDate.endOfDay
              : task.dueDate.copyWith(hour: 17), // 5pm
    );
  }

  /// Cancels a notification for a task.
  Future<void> _cancelNotification(int id) =>
      _notificationService.cancelSchedule(id);

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
        pending: tasks.where((t) => t.status.isPending).length,
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

  Future<void> updateTask(Task task) async {
    try {
      await _taskRepository.updateTask(task);
      unawaited(_syncRepository.updateTask(task)); // sync to server
      emit(await _getTaskData());
      // TODO(albin): update content of scheduled notification
    } on Exception catch (e) {
      emit(TaskState.error(message: e.toString()));
    }
  }

  Future<void> markAsDone(Task task) async {
    await updateTask(task.copyWith(status: TaskStatus.completed));
    unawaited(_cancelNotification(task.id));
  }

  Future<void> markAsPending(Task task) async {
    await updateTask(task.copyWith(status: TaskStatus.pending));
    unawaited(_scheduleNotification(task));
  }

  Future<void> deleteTask(Task task) async {
    try {
      await _taskRepository.deleteTask(task);
      unawaited(_syncRepository.deleteTask(task)); // sync to server
      emit(await _getTaskData());
      unawaited(_cancelNotification(task.id));
    } on Exception catch (e) {
      emit(TaskState.error(message: e.toString()));
    }
  }
}
