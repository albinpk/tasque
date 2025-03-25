import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'src/app.dart';
import 'src/core/db/object_box.dart';
import 'src/core/notifications/notification_service.dart';

/// Global ObjectBox instance.
late final ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  tz.initializeTimeZones();
  await NotificationService.i.init();

  objectbox = await ObjectBox.create();

  runApp(const App());
}
