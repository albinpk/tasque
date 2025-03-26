import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_service.dart';
import '../../../shared/common_export.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/task_status_enum.dart';
import 'create_task_view.dart';
import 'cubit/task_cubit.dart';
import 'widget/task_card.dart';

/// The main screen of the app.
class TaskSummaryScreen extends StatefulWidget {
  const TaskSummaryScreen({super.key});

  @override
  State<TaskSummaryScreen> createState() => _TaskSummaryScreenState();
}

class _TaskSummaryScreenState extends State<TaskSummaryScreen> {
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivityStreamSubscription;

  @override
  void initState() {
    super.initState();
    _listenConnection();
    _requestNotificationPermission();
  }

  @override
  void dispose() {
    _connectivityStreamSubscription.cancel();
    super.dispose();
  }

  /// Listen to connectivity changes and show a snackbar.
  void _listenConnection() {
    _connectivityStreamSubscription = Connectivity().onConnectivityChanged
        .listen((event) {
          if (!mounted) return;
          final offline = event.contains(ConnectivityResult.none);
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  offline ? 'You are offline' : 'You are online',
                  style:
                      offline
                          ? context.bodyMedium.copyWith(
                            color: context.colorScheme.onError,
                          )
                          : null,
                ),
                backgroundColor: offline ? context.colorScheme.error : null,
              ),
            );
        });
  }

  Future<void> _requestNotificationPermission() async {
    final granted = await NotificationService.i.requestPermissions();
    if (granted) await _showOneTimeNotification();
  }

  /// Show a welcome notification once.
  Future<void> _showOneTimeNotification() async {
    try {
      final pref = await SharedPreferences.getInstance();
      if (pref.getBool('isFirstRun') != null) return;
      await NotificationService.i.show(
        title: 'Welcome to Tasque! 🎉',
        body:
            'Notifications are enabled! '
            'Stay on top of your tasks with timely reminders and updates. ✅',
      );
      await pref.setBool('isFirstRun', false);
    } catch (e) {
      log('one time notification', e);
    }
  }

  /// Padding for the page.
  static const _padding = 15.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const _AppBar(),

          // grid - in progress, urgent, completed, overdue
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(_padding),
              child: _TaskSummary(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _padding),
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
                        onPressed: () => const TaskListRoute().go(context),
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
                        padding: const EdgeInsets.only(
                          left: _padding,
                          right: _padding,
                          top: 5,
                          bottom: 120, // 120 for FAB
                        ),
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

/// App bar with user details.
class _AppBar extends StatefulWidget {
  const _AppBar();

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late final _userStream = context.read<AuthRepository>().userStream();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userStream,
      builder: (context, snapshot) {
        final user = snapshot.data;
        return SliverAppBar(
          centerTitle: false,
          titleSpacing: 0,
          snap: true,
          floating: true,
          leading: Center(
            child: GestureDetector(
              onTap: user == null ? null : () => _showUserDialog(user),
              child: CircleAvatar(
                foregroundImage:
                    user?.photoURL == null
                        ? null
                        : NetworkImage(user!.photoURL!),
                child: const Icon(Icons.person),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi${user?.displayName != null ? ', ${user!.displayName}' : ''}',
                style: context.titleMedium.bold,
              ),
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
              onPressed: () => const TaskListRoute(searchQuery: '').go(context),
            ),
          ],
        );
      },
    );
  }

  void _showUserDialog(User user) {
    showDialog<void>(
      context: context,
      builder: (context) => _UserDialog(user: user),
    );
  }
}

/// Dialog to show user details and sign out button.
class _UserDialog extends StatelessWidget {
  const _UserDialog({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 30,
              foregroundImage:
                  user.photoURL == null ? null : NetworkImage(user.photoURL!),
              child: const Icon(Icons.person),
            ),
            const SizedBox(height: 10),

            Text(user.displayName ?? 'Hello', style: context.titleMedium),
            if (user.email != null) Text(user.email!),

            TextButton(
              onPressed: () => _onSignOut(context),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSignOut(BuildContext context) async {
    try {
      await context.read<AuthRepository>().signOut();
      if (context.mounted) {
        context.read<TaskCubit>().clearState();
        LoginRoute().go(context);
      }
    } catch (e) {
      log(e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Something went wrong.')));
      }
    }
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
                title: 'Pending',
                count: summary?.pending,
                icon: Icons.sync,
                color: Colors.blue,
                onTap: () {
                  const TaskListRoute(status: TaskStatus.pending).go(context);
                },
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
                onTap: () {
                  const TaskListRoute(status: TaskStatus.completed).go(context);
                },
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
    VoidCallback? onTap,
  }) {
    return Card(
      color: color.lighten(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
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
                    Text(
                      '${count ?? 0} tasks',
                      style: context.labelSmall.fade(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
