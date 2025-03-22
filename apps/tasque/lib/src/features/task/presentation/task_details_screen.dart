import '../../../shared/common_export.dart';
import '../model/task.dart';
import 'cubit/task_cubit.dart';
import 'widget/priority_chip.dart';
import 'widget/status_chip.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({required this.taskId, super.key});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskCubit value) {
      if (value.state case TaskStateLoaded(:final tasks)) {
        return tasks.firstWhere((t) => t.id == taskId);
      }
    });
    return Scaffold(
      appBar: AppBar(
        // TODO(albin): edit
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.edit))],
      ),
      body:
          task == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(15),
                        children: [
                          // title
                          Text(task.title, style: context.displaySmall),
                          const SizedBox(height: 10),

                          // status and priority
                          Row(
                            spacing: 10,
                            children: [
                              StatusChip(status: task.status),
                              PriorityChip(priority: task.priority),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // description
                          if (task.description != null)
                            Text(task.description!, style: context.bodyLarge),
                          const SizedBox(height: 20),

                          // due date
                          Text('Due date: ', style: context.bodyMedium.bold),
                          const SizedBox(height: 5),
                          Text(
                            '${task.dueDate.format()} - ${task.relativeDueDate}',
                            style: context.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child:
                            task.status.isPending
                                ? FilledButton(
                                  onPressed:
                                      () => _onUpdateStatus(context, task),
                                  child: const Text('Mark as done'),
                                )
                                : OutlinedButton(
                                  onPressed:
                                      () => _onUpdateStatus(context, task),
                                  child: const Text('Mark as pending'),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _onUpdateStatus(BuildContext context, Task task) {
    if (task.status.isPending) {
      context.read<TaskCubit>().markAsDone(task);
    } else {
      context.read<TaskCubit>().markAsPending(task);
    }
  }
}
