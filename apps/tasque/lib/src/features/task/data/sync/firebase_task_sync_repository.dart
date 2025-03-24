import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/repository/auth_repository.dart';
import '../../model/task.dart';
import 'task_sync_repository.dart';

class FirebaseTaskSyncRepository implements TaskSyncRepository {
  const FirebaseTaskSyncRepository({
    required AuthRepository authRepo,
    required FirebaseFirestore db,
  }) : _authRepo = authRepo,
       _db = db;

  final FirebaseFirestore _db;
  final AuthRepository _authRepo;

  bool get _isLoggedIn => _authRepo.isLoggedIn();

  CollectionReference<Map<String, dynamic>> get _taskCollection =>
      _db.collection('users').doc(_authRepo.getUser()!.uid).collection('tasks');

  @override
  Future<List<Task>> getAllTasks() async {
    if (!_isLoggedIn) return [];
    final snapshot = await _taskCollection.get();
    return snapshot.docs.map((e) => Task.fromJson(e.data())).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    await _taskCollection.doc(task.uid).set(task.toFirestoreJson());
  }

  @override
  Future<void> updateTask(Task task) async {
    await _taskCollection.doc(task.uid).update(task.toFirestoreJson());
  }

  @override
  Future<void> deleteTask(Task task) async {
    await _taskCollection.doc(task.uid).delete();
  }
}
