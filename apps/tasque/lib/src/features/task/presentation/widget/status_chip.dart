import '../../../../shared/common_export.dart';
import '../../model/task_status_enum.dart';

/// Widget to display a task status with color.
class StatusChip extends StatelessWidget {
  const StatusChip({required this.status, this.size = 14.0, super.key});

  final TaskStatus status;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: status.isPending ? Colors.orangeAccent : Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          status.name.capitalize,
          style: context.labelSmall.copyWith(
            color: Colors.white,
            fontSize: size,
          ),
        ),
      ),
    );
  }
}
