import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../objectbox.g.dart';
import '../../task/data/local/model/task_entity.dart';

/// Repository for authentication.
class AuthRepository {
  AuthRepository({required Box<TaskEntity> taskBox}) : _taskBox = taskBox;

  final Box<TaskEntity> _taskBox;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Check if user is logged in.
  bool isLoggedIn() => _auth.currentUser != null;

  /// Get current user.
  User? getUser() => _auth.currentUser;

  /// Stream of user changes.
  Stream<User?> userStream() => _auth.userChanges();

  /// Sign in with Google and add user to firestore.
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    await _addUser(userCredential.user!);
    return userCredential;
  }

  /// Add user to firestore.
  Future<void> _addUser(User user) async {
    final doc = _db.collection('users').doc(user.uid);
    await doc.set({
      'displayName': user.displayName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
      'uid': user.uid,
    });
  }

  /// Sign out and remove all tasks from local database.
  Future<void> signOut() async {
    await _auth.signOut();
    await _taskBox.removeAllAsync();
  }
}
