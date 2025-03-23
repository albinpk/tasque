import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Repository for authentication.
class AuthRepository {
  Future<UserCredential> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  Stream<User?> userStream() => FirebaseAuth.instance.userChanges();
}
