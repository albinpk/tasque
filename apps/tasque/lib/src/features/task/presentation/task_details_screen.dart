import 'dart:async';

import '../../../shared/common_export.dart';
import '../model/task.dart';
import '../model/task_priority_enum.dart';
import 'cubit/task_cubit.dart';
import 'widget/priority_button.dart';
import 'widget/priority_chip.dart';
import 'widget/status_chip.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({required this.taskId, super.key});

  final int taskId;

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskCubit value) {
      if (value.state case TaskStateLoaded(:final tasks)) {
        return tasks.firstWhereOrNull((t) => t.id == widget.taskId);
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (_isEditing) return setState(() => _isEditing = false);
            context.pop();
          },
        ),
        actions:
            task != null && !_isEditing
                ? [
                  IconButton(
                    tooltip: 'Edit',
                    onPressed: () => setState(() => _isEditing = true),
                    icon: const Icon(Icons.edit_rounded),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    style: IconButton.styleFrom(
                      foregroundColor: context.colorScheme.error,
                    ),
                    onPressed: () => _onDelete(task),
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ]
                : null,
      ),
      body:
          task == null
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      _isEditing
                          ? _EditForm(
                            task: task,
                            onSave: () => setState(() => _isEditing = false),
                          )
                          : _buildView(task),
                ),
              ),
    );
  }

  Future<void> _onDelete(Task task) async {
    if (!await _deleteConfirmation() || !mounted) return;
    unawaited(context.read<TaskCubit>().deleteTask(task));
    context.pop();
  }

  Future<bool> _deleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure you want to delete this task?'),
              content: const Text('This action cannot be undone'),
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => context.pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildView(Task task) {
    return Column(
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
                      onPressed: () => _onUpdateStatus(context, task),
                      child: const Text('Mark as done'),
                    )
                    : OutlinedButton(
                      onPressed: () => _onUpdateStatus(context, task),
                      child: const Text('Mark as pending'),
                    ),
          ),
        ),
      ],
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

/// A form widget to edit a task.
class _EditForm extends StatefulWidget {
  const _EditForm({required this.task, required this.onSave});

  final Task task;
  final VoidCallback onSave;

  @override
  State<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: task.title);
  late final _descriptionController = TextEditingController(
    text: task.description,
  );
  late final _dateController = TextEditingController(
    text: task.dueDate.format(),
  );
  late DateTime _date = task.dueDate;
  late TaskPriority _priority = task.priority;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Task get task => widget.task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                Input(
                  controller: _titleController,
                  label: 'Task title',
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(errorText: ''),
                ),
                const SizedBox(height: 25),

                Input(
                  controller: _descriptionController,
                  label: 'Description',
                  maxLines: 4,
                ),
                const SizedBox(height: 25),

                Input(
                  controller: _dateController,
                  label: 'End date',
                  readOnly: true,
                  onTap: _showDatePicker,
                  validator: FormBuilderValidators.required(errorText: ''),
                ),
                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Priority', style: context.bodyMedium),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    spacing: 10,
                    children: [
                      _buildPriority(TaskPriority.low),
                      _buildPriority(TaskPriority.medium),
                      _buildPriority(TaskPriority.high),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _onUpdate,
              child: const Text('Update'),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<TaskCubit>().updateTask(
      task.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().nullIfEmpty,
        dueDate: _date,
        priority: _priority,
      ),
    );
    widget.onSave();
  }

  Widget _buildPriority(TaskPriority priority) {
    return Expanded(
      child: PriorityButton(
        priority: priority,
        selected: _priority == priority,
        onTap: () {
          setState(() => _priority = priority);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)), // 5 years
    );
    if (date == null) return;
    _date = date;
    _dateController.text = date.format();
  }
}
