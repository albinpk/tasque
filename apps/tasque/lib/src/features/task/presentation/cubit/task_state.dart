part of 'task_cubit.dart';

@freezed
sealed class TaskState with _$TaskState {
  const factory TaskState.initial() = TaskStateInitial;
  const factory TaskState.loading() = TaskStateLoading;
  const factory TaskState.loaded({
    required List<Task> tasks,
    required List<Task> recentTasks,
    required TaskSummary summary,
  }) = TaskStateLoaded;
  const factory TaskState.error({required String message}) = TaskStateError;
}

typedef TaskSummary = ({int pending, int urgent, int completed, int overdue});
