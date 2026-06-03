// ============================================================
//  WHAT GOES HERE
//  Custom exception / failure classes.
//  Throw from Sources, catch in Repositories,
//  surface user-friendly messages in Controllers.
//  Never let raw FirebaseException escape past the source layer.
// ============================================================

class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([String msg = 'No internet connection']) : super(msg);
}

class AuthException extends AppException {
  const AuthException(super.message);
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}
