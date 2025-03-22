import '../../../../shared/common_export.dart';
import '../../model/task_priority_enum.dart';

/// Widget to display a task priority with icon and color.
class PriorityChip extends StatelessWidget {
  const PriorityChip({required this.priority, this.size = 14.0, super.key});

  final TaskPriority priority;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: priority.color),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(priority.icon, size: size + 4, color: priority.color),
            Text(
              priority.name.capitalize,
              style: context.labelSmall.copyWith(
                fontSize: size,
                color: priority.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
