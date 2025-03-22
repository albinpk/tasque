import '../../../../shared/common_export.dart';
import '../../model/task_priority_enum.dart';

/// Widget to display a task priority button.
/// Used in create and edit task screens.
class PriorityButton extends StatelessWidget {
  const PriorityButton({
    required this.priority,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final TaskPriority priority;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final color = selected ? Colors.white : cs.onSurface;
    return SolidShadow(
      child: Card(
        color: selected ? priority.color : cs.surface,
        shape: RoundedRectangleBorder(
          side: const BorderSide(),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: FittedBox(
                child: Row(
                  children: [
                    Icon(priority.icon, color: color),
                    Text(
                      priority.name.capitalize,
                      style: context.bodyLarge.copyWith(color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
