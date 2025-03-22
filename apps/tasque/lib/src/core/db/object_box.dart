import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../objectbox.g.dart';

class ObjectBox {
  const ObjectBox._create(this.store);

  /// The Store of this app.
  final Store store;

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, 'obx-tasque-dev'),
    );
    return ObjectBox._create(store);
  }
}
