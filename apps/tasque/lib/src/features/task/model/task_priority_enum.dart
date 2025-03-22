import 'package:flutter/material.dart';

/// Task priorities with icon and color.
enum TaskPriority {
  high(Icons.keyboard_double_arrow_up_rounded, Colors.deepOrange),
  medium(Icons.drag_handle_rounded, Colors.amber),
  low(Icons.keyboard_double_arrow_down_rounded, Colors.teal);

  const TaskPriority(this.icon, this.color);

  /// Priority icon.
  final IconData icon;

  /// Priority color.
  final Color color;
}
