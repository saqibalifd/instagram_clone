// ============================================================
//  WHAT GOES HERE
//  Direct Firebase Auth SDK calls — the ONLY file that may
//  import firebase_auth for authentication.
//  Always convert FirebaseUser → UserModel before returning.
//  Never return raw SDK objects — that leaks Firebase into upper layers.
// ============================================================

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthSource {
  final FirebaseAuth _auth;
  AuthSource(this._auth);

  Future<UserModel> signInWithEmail(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return _map(cred.user!);
  }

  Future<UserModel> signUpWithEmail(String email, String password, String username) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await cred.user!.updateDisplayName(username);
    return _map(cred.user!);
  }

  Future<void>       signOut()          => _auth.signOut();
  Future<UserModel?> getCurrentUser()   async {
    final u = _auth.currentUser; return u == null ? null : _map(u);
  }
  Stream<UserModel?> get authStateChanges =>
      _auth.authStateChanges().map((u) => u == null ? null : _map(u));

  // Private mapper — keep Firebase types out of the rest of the app
  UserModel _map(User u) => UserModel(
        id:        u.uid,
        username:  u.displayName ?? '',
        email:     u.email ?? '',
        avatarUrl: u.photoURL,
        createdAt: u.metadata.creationTime ?? DateTime.now(),
      );
}
