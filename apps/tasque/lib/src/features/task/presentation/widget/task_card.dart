import '../../../../shared/common_export.dart';

/// Widget to display a task in the task screen.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key});

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
            children: [
              Row(
                children: [
                  Expanded(child: Text('Task title', style: context.bodyLarge)),

                  // task status
                  Card.filled(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text('Completed', style: context.labelSmall),
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
                        Text('Description', style: context.bodySmall.fade()),

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
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.keyboard_double_arrow_up_rounded,
                            size: 12,
                          ),
                          Text(
                            'High',
                            style: context.labelSmall.copyWith(fontSize: 8),
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
