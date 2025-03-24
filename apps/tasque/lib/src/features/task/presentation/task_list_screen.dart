import '../../../shared/common_export.dart';
import '../model/task_priority_enum.dart';
import '../model/task_status_enum.dart';
import 'cubit/task_cubit.dart';
import 'widget/task_card.dart';

// TODO(albin): need a dedicated bloc ??

/// Task list and search screen.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({
    super.key,
    this.searchQuery,
    this.status,
    this.priority,
  });

  final String? searchQuery;
  final TaskStatus? status;
  final TaskPriority? priority;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // filter values
  late String? _searchQuery = widget.searchQuery;
  late TaskStatus? _status = widget.status;
  late TaskPriority? _priority = widget.priority;

  late bool _showSearch =
      _searchQuery != null || _status != null || _priority != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _showSearch
              ? _buildSearchAppBar()
              : AppBar(
                title: const Text('Your tasks'),
                actions: [
                  IconButton(
                    tooltip: 'Search',
                    icon: const Icon(Icons.search_rounded),
                    onPressed: () => setState(() => _showSearch = true),
                  ),
                ],
              ),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              // TODO(albin): lift state
              if (state case TaskStateLoaded(:final tasks)) {
                var filtered = tasks;
                if (_searchQuery case final q?) {
                  filtered =
                      filtered.where((e) {
                        return '${e.title}${e.description ?? ''}'
                            .toLowerCase()
                            .contains(q.toLowerCase());
                      }).toList();
                }

                if (_status != null) {
                  filtered =
                      filtered.where((e) => e.status == _status).toList();
                }
                if (_priority != null) {
                  filtered =
                      filtered.where((e) => e.priority == _priority).toList();
                }

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No tasks found')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(15).copyWith(bottom: 80),
                  sliver: SliverList.separated(
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemCount: filtered.length,
                    itemBuilder: (_, index) {
                      return TaskCard(task: filtered[index]);
                    },
                  ),
                );
              }
              return const SliverToBoxAdapter();
            },
          ),
        ],
      ),
    );
  }

  _SearchAndFilterAppBar _buildSearchAppBar() {
    return _SearchAndFilterAppBar(
      initialSearchQuery: _searchQuery,
      initialFilter: (status: _status, priority: _priority),
      onSearchChange: (value) {
        setState(() => _searchQuery = value.trim().nullIfEmpty);
      },
      onFilterChange: (value) {
        setState(() {
          _status = value.status;
          _priority = value.priority;
        });
      },
      onClose:
          () => setState(() {
            _showSearch = false;
            _searchQuery = null;
            _status = null;
            _priority = null;
          }),
    );
  }
}

class _SearchAndFilterAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const _SearchAndFilterAppBar({
    required this.onSearchChange,
    required this.onClose,
    required this.onFilterChange,
    this.initialSearchQuery,
    this.initialFilter,
  });

  final String? initialSearchQuery;
  final _FilterSheetResult? initialFilter;

  final ValueChanged<String> onSearchChange;
  final ValueChanged<_FilterSheetResult> onFilterChange;
  final VoidCallback onClose;

  @override
  State<_SearchAndFilterAppBar> createState() => _SearchAndFilterAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAndFilterAppBarState extends State<_SearchAndFilterAppBar> {
  // filter values
  late final _controller = TextEditingController(
    text: widget.initialSearchQuery,
  );
  late TaskStatus? _status = widget.initialFilter?.status;
  late TaskPriority? _priority = widget.initialFilter?.priority;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasFilter => _status != null || _priority != null;

  @override
  Widget build(BuildContext context) {
    // no border
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide.none,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, _) => widget.onClose(),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: context.colorScheme.onSurface.fade(0.1),
            border: border,
            errorBorder: border,
            focusedBorder: border,
            enabledBorder: border,
            disabledBorder: border,
            focusedErrorBorder: border,
            hintText: 'Search...',
            prefixIconConstraints: const BoxConstraints.tightFor(),
            prefixIcon: IconButton(
              style: IconButton.styleFrom(backgroundColor: Colors.transparent),
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: widget.onClose,
            ),
            suffixIconConstraints: const BoxConstraints.tightFor(),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    key: const Key('clear'), // for default animation
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      widget.onSearchChange('');
                      setState(() {});
                    },
                  ),

                // filer button
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor:
                        _hasFilter ? context.colorScheme.primary : null,
                  ),
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: _showFilterSheet,
                ),
              ],
            ),
          ),
          onChanged: (value) {
            widget.onSearchChange(value);
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _showFilterSheet() async {
    final filter = await showModalBottomSheet<_FilterSheetResult>(
      context: context,
      builder: (context) {
        return _FilterSheet(initial: (status: _status, priority: _priority));
      },
    );
    if (filter == null) return;

    setState(() {
      _status = filter.status;
      _priority = filter.priority;
    });
    widget.onFilterChange(filter);
  }
}

/// Navigator result of [_FilterSheet].
typedef _FilterSheetResult = ({TaskStatus? status, TaskPriority? priority});

/// Filter sheet. Will pop with a result of type [_FilterSheetResult]
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({this.initial});

  final _FilterSheetResult? initial;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late TaskStatus? _status = widget.initial?.status;
  late TaskPriority? _priority = widget.initial?.priority;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15).copyWith(top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Status'),
            Row(
              spacing: 8,
              children: [
                for (final e in TaskStatus.values)
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(e.name.capitalize),
                    selected: _status == e,
                    onSelected: (v) => setState(() => _status = !v ? null : e),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Priority'),
            Row(
              spacing: 8,
              children: [
                for (final e in TaskPriority.values)
                  ChoiceChip(
                    showCheckmark: false,
                    label: Text(e.name.capitalize),
                    avatar: Icon(e.icon, color: context.colorScheme.onSurface),
                    selected: _priority == e,
                    onSelected: (v) {
                      setState(() => _priority = !v ? null : e);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _onApply,
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onApply() {
    context.pop<_FilterSheetResult>((status: _status, priority: _priority));
  }
}
