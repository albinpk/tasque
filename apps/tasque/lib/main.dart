import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/core/db/object_box.dart';

/// Global ObjectBox instance.
late final ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectbox = await ObjectBox.create();

  runApp(const App());
}
