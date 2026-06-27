import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/user_model.dart';

/// Abstract interface for all authentication operations
/// Follows the Repository Pattern as per guidelines.md
abstract class IAuthRepository {
  /// Sign in with email and password.
  /// Returns [UserModel] on success, [AuthFailure] on failure.
  Future<Either<Failure, UserModel>> signIn(String email, String password);

  /// Sign out the current user and clear local session.
  Future<Either<Failure, void>> signOut();

  /// Send a Firebase password reset email to the given address.
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Re-authenticate then update password (SRS-14 to SRS-16).
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Fetch the current user's Firestore document.
  Future<Either<Failure, UserModel>> fetchCurrentUserData();

  /// Update the user's FCM token in Firestore after each login.
  Future<Either<Failure, void>> updateFcmToken(String uid, String token);

  /// Check if a user is currently authenticated.
  bool get isAuthenticated;

  /// Get the current Firebase Auth UID (null if not signed in).
  String? get currentUid;
}
