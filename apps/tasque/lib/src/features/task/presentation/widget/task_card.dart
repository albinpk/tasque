import '../../../../shared/common_export.dart';
import '../../model/task.dart';

/// Widget to display a task in the task screen.
class TaskCard extends StatelessWidget {
  const TaskCard({required this.task, super.key});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return SolidShadow(
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black87),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              Row(
                children: [
                  Expanded(child: Text(task.title, style: context.bodyLarge)),

                  // task status
                  Card.filled(
                    color:
                        task.status.isPending
                            ? Colors.orangeAccent
                            : Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        task.status.name.capitalize,
                        style: context.labelSmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        if (task.description != null)
                          Text(
                            task.description!,
                            style: context.bodySmall.fade(),
                          ),

                        // task due date
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Icons.access_time, size: 12),
                            Text(
                              '3 days left',
                              style: context.labelSmall.fade(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // task priority
                  Card.outlined(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: task.priority.color),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Icon(
                            task.priority.icon,
                            size: 12,
                            color: task.priority.color,
                          ),
                          Text(
                            task.priority.name.capitalize,
                            style: context.labelSmall.copyWith(
                              fontSize: 8,
                              color: task.priority.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
