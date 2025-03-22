import '../../../shared/common_export.dart';
import 'create_task_view.dart';
import 'widget/task_card.dart';

/// The main screen of the app.
class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),

          // grid - in progress, urgent, completed, overdue
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                spacing: 15,
                children: [
                  Row(
                    spacing: 15,
                    children: [
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          title: 'In Progress',
                          subtitle: '5 tasks',
                          icon: Icons.sync,
                          color: Colors.blue,
                        ),
                      ),
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          title: 'Urgent',
                          subtitle: '2 tasks',
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
                          subtitle: '14 tasks',
                          icon: Icons.check,
                          color: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildGridCard(
                          context: context,
                          title: 'Overdue',
                          subtitle: '1 tasks',
                          icon: Icons.date_range_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 0),
              child: Text('Recent Tasks', style: context.titleMedium),
            ),
          ),

          // recent tasks list
          SliverPadding(
            padding: const EdgeInsets.all(15).copyWith(bottom: 120), // for FAB
            sliver: SliverList.separated(
              itemCount: 20,
              separatorBuilder: (_, _) => const SizedBox(height: 20),
              itemBuilder: (_, index) => const TaskCard(),
            ),
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

  Widget _buildGridCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
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
                  Text(subtitle, style: context.labelSmall.fade()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
