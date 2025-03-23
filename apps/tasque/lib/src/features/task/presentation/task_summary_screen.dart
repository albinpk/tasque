import '../../../shared/common_export.dart';
import 'create_task_view.dart';
import 'cubit/task_cubit.dart';
import 'widget/task_card.dart';

/// The main screen of the app.
class TaskSummaryScreen extends StatelessWidget {
  const TaskSummaryScreen({super.key});

  /// Padding for the page.
  static const _padding = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),

          // grid - in progress, urgent, completed, overdue
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: _TaskSummary(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(_padding).copyWith(bottom: 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Recent Tasks', style: context.titleMedium),
                  ),

                  // see all (if any)
                  Builder(
                    builder: (context) {
                      final totalCount = context.select((TaskCubit cubit) {
                        if (cubit.state case TaskStateLoaded(:final tasks)) {
                          return tasks.length;
                        }
                        return 0;
                      });
                      if (totalCount == 0) return const SizedBox.shrink();
                      return TextButton(
                        onPressed: () => TaskListRoute().go(context),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text('See all ($totalCount)'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // recent tasks list
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              return switch (state) {
                TaskStateInitial() ||
                TaskStateLoading() => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                ),
                TaskStateLoaded(:final recentTasks) =>
                  recentTasks.isEmpty
                      ? const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('No tasks yet')),
                      )
                      : SliverPadding(
                        padding: const EdgeInsets.all(
                          _padding,
                        ).copyWith(bottom: 120), // 120 for FAB
                        sliver: SliverList.separated(
                          itemCount: recentTasks.length,
                          separatorBuilder:
                              (_, _) => const SizedBox(height: 20),
                          itemBuilder: (_, index) {
                            return TaskCard(task: recentTasks[index]);
                          },
                        ),
                      ),
                TaskStateError() => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Something went wrong')),
                ),
              };
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Task',
        onPressed: () => _showCreateTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      centerTitle: false,
      titleSpacing: 0,
      snap: true,
      floating: true,
      leading: const Center(child: CircleAvatar(child: Icon(Icons.person))),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hi, User', style: context.titleMedium.bold),
          Text(
            'You daily adventure starts now',
            style: context.bodySmall.fade(),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  void _showCreateTaskForm(BuildContext context) {
    // padding will not be available from the context of bottom sheet builder
    final padding = MediaQuery.paddingOf(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(
        duration: const Duration(milliseconds: 500),
        reverseDuration: const Duration(milliseconds: 500),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          snap: true,
          initialChildSize: 1,
          builder: (context, scrollController) {
            return CreateTaskView(
              scrollController: scrollController,
              padding: padding,
            );
          },
        );
      },
    );
  }
}

class _TaskSummary extends StatelessWidget {
  const _TaskSummary();

  @override
  Widget build(BuildContext context) {
    final summary = context.select((TaskCubit value) {
      if (value.state case final TaskStateLoaded data) return data.summary;
    });
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: _buildGridCard(
                context: context,
                title: 'In Progress',
                count: summary?.inProgress,
                icon: Icons.sync,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: _buildGridCard(
                context: context,
                title: 'Urgent',
                count: summary?.urgent,
                icon: Icons.priority_high_rounded,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: _buildGridCard(
                context: context,
                title: 'Completed',
                count: summary?.completed,
                icon: Icons.check,
                color: Colors.green,
              ),
            ),
            Expanded(
              child: _buildGridCard(
                context: context,
                title: 'Overdue',
                count: summary?.overdue,
                icon: Icons.date_range_rounded,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGridCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required int? count,
  }) {
    return Card(
      color: color.lighten(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          spacing: 8,
          children: [
            ClipOval(
              child: ColoredBox(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.titleSmall.bold),
                  Text('${count ?? 0} tasks', style: context.labelSmall.fade()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
