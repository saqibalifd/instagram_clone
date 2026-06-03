// ============================================================
//  WHAT GOES HERE
//  Abstract class — the CONTRACT controllers code against.
//  Controllers depend on THIS interface, never on the impl.
//  Swap Firebase → Supabase without touching a single controller.
// ============================================================

import '../../models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel>  signInWithEmail(String email, String password);
  Future<UserModel>  signUpWithEmail(String email, String password, String username);
  Future<void>       signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}
