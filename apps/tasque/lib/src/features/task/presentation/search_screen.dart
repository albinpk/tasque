import '../../../shared/common_export.dart';

/// Task list and search screen.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('All Tasks')),
    );
  }
}
