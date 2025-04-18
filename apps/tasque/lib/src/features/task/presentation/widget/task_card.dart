import 'dart:math';

import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../../../../shared/common_export.dart';
import '../../model/task.dart';
import 'priority_chip.dart';
import 'status_chip.dart';

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
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => TaskDetailsRoute(taskId: task.id).push<void>(context),
          child: Stack(
            children: [
              _WaveAnimation(task: task),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 6,
                  children: [
                    // title and status
                    Row(
                      children: [
                        Expanded(
                          child: Text(task.title, style: context.bodyLarge),
                        ),
                        StatusChip(status: task.status, size: 10),
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
                        PriorityChip(priority: task.priority, size: 8),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color:
                              task.dueDate.isToday
                                  ? context.colorScheme.error
                                  : null,
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Background wave animation for the [TaskCard].
class _WaveAnimation extends StatelessWidget {
  const _WaveAnimation({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Transform(
          alignment: Alignment.bottomRight,
          transform:
              Matrix4.identity()
                ..translate(30.0)
                ..rotateZ(-12 * pi / 180),
          child: SizedBox(
            height: 40,
            child: WaveWidget(
              config: CustomConfig(
                colors: [task.priority.color.fade(0.4)],
                durations: const [7500],
                heightPercentages: const [0],
              ),
              size: Size.infinite,
              waveAmplitude: -5,
            ),
          ),
        ),
      ),
    );
  }
}
