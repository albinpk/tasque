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
            spacing: 6,
            children: [
              // title and status
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

              if (task.description != null)
                Text(
                  task.description!,
                  style: context.bodySmall.fade(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              // priority and due date
              Row(
                spacing: 4,
                children: [
                  _buildPriority(context),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color:
                        task.dueDate.isToday ? context.colorScheme.error : null,
                  ),
                  Text(
                    task.relativeDueDate,
                    style: context.labelSmall.fade().copyWith(
                      color:
                          task.dueDate.isToday
                              ? context.colorScheme.error
                              : context.colorScheme.onSurface.fade(),
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

  Widget _buildPriority(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: task.priority.color),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          children: [
            Icon(task.priority.icon, size: 12, color: task.priority.color),
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
    );
  }
}
