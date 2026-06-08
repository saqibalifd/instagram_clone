// // ============================================================
// //  WHAT GOES HERE
// //  Concrete AuthRepository implementation.
// //  Constructor-inject AuthSource.
// //  Catch source-level exceptions and rethrow as AppExceptions
// //  so controllers receive clean, typed errors.
// // ============================================================

// import '../../../core/errors/app_exceptions.dart';
// import '../../models/user_model.dart';
// import '../../sources/auth_source.dart';
// import '../interfaces/auth_repository.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthSource _source;
//   AuthRepositoryImpl(this._source);

//   @override
//   Future<UserModel> signInWithEmail(String email, String password) async {
//     try {
//       return await _source.signInWithEmail(email, password);
//     } on AuthException {
//       rethrow;
//     } catch (e) {
//       throw AuthException('Sign-in failed: $e');
//     }
//   }

//   @override
//   Future<UserModel> signUpWithEmail(String email, String password, String username) =>
//       _source.signUpWithEmail(email, password, username);

//   @override
//   Future<void>       signOut()          => _source.signOut();
//   @override
//   Future<UserModel?> getCurrentUser()   => _source.getCurrentUser();
//   @override
//   Stream<UserModel?> get authStateChanges => _source.authStateChanges;
// }
