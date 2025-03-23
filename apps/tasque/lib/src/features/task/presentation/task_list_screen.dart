import '../../../shared/common_export.dart';
import 'cubit/task_cubit.dart';
import 'widget/task_card.dart';

/// Task list and search screen.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({this.showSearch = false, super.key});

  final bool showSearch;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late bool _showSearch = widget.showSearch;
  String? _searchQuery;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _showSearch
              ? _SearchAppBar(
                onChange: (value) {
                  setState(() => _searchQuery = value.trim().nullIfEmpty);
                },
                onClose:
                    () => setState(() {
                      _showSearch = false;
                      _searchQuery = null;
                    }),
              )
              : AppBar(
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
              if (state case TaskStateLoaded(:final tasks)) {
                var filtered = tasks;
                if (_searchQuery case final q?) {
                  filtered =
                      filtered.where((element) {
                        return '${element.title}${element.description ?? ''}'
                            .toLowerCase()
                            .contains(q.toLowerCase());
                      }).toList();
                }

                if (filtered.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No tasks found')),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(15),
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
}

class _SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  const _SearchAppBar({
    required this.onChange,
    required this.onClose,
    super.key,
  });

  final ValueChanged<String> onChange;
  final VoidCallback onClose;

  @override
  State<_SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends State<_SearchAppBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      borderSide: BorderSide.none,
    );
    return AppBar(
      automaticallyImplyLeading: false,
      title: TextField(
        controller: _controller,
        autofocus: true,
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
          suffixIcon:
              _controller.text.isEmpty
                  ? null
                  : IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _controller.clear();
                      widget.onChange('');
                      setState(() {});
                    },
                  ),
        ),
        onChanged: (value) {
          widget.onChange(value);
          setState(() {});
        },
      ),
    );
  }
}
