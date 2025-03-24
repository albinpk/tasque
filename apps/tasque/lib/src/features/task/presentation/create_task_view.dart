import '../../../shared/common_export.dart';
import '../model/task_priority_enum.dart';
import 'cubit/task_cubit.dart';
import 'widget/priority_button.dart';

/// A view to create a new task.
class CreateTaskView extends StatefulWidget {
  const CreateTaskView({
    required this.scrollController,
    required this.padding,
    super.key,
  });

  /// Scroll controller from [DraggableScrollableSheet].
  final ScrollController scrollController;

  /// View padding.
  final EdgeInsets padding;

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _date;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: CustomScrollView(
          controller: widget.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(
                  15,
                ).copyWith(top: widget.padding.top + 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'New Task',
                              style: context.displaySmall.bold,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      Input(
                        controller: _titleController,
                        label: 'Task title',
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.required(
                          errorText: '',
                        ),
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
                        validator: FormBuilderValidators.required(
                          errorText: '',
                        ),
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
            ),

            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(
                    15,
                  ).copyWith(bottom: widget.padding.bottom + 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _onCreate,
                      child: const Text('Create'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCreate() {
    if (!_formKey.currentState!.validate()) return;
    context.read<TaskCubit>().createTask(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dueDate: _date!,
      priority: _priority,
    );
    context.pop();
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
      initialDate: _date ?? now.add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 5)), // 5 years
    );
    if (date == null) return;
    _date = date;
    _dateController.text = date.format();
  }
}
