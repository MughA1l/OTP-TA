import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/error/failures.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ─── Sign In ──────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, UserModel>> signIn(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = credential.user!.uid;
      final doc = await _firestore
          .collection(FirebaseConstants.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        return Left(
          AuthFailure(message: 'User profile not found. Contact admin.'),
        );
      }

      final user = UserModel.fromMap(doc.data()!, uid);

      // SRS-32: Check account status
      if (user.isDeactivated) {
        await _auth.signOut();
        return Left(
          AuthFailure(
            message: 'Your Account Has Been Deactivated. Please Contact Admin.',
          ),
        );
      }

      return Right(user);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _mapAuthError(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: 'An unexpected error occurred.'));
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to sign out.'));
    }
  }

  // ─── Password Reset Email ─────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _mapAuthError(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to send reset email.'));
    }
  }

  // ─── Update Password ──────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(AuthFailure(message: 'No authenticated user found.'));
      }

      // Re-authenticate first (SRS-14)
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Now update the password
      await user.updatePassword(newPassword);

      // Mark isFirstLogin = false in Firestore (SRS-96)
      await _firestore.collection(FirebaseConstants.users).doc(user.uid).update(
        {'isFirstLogin': false},
      );

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: _mapAuthError(e.code)));
    } catch (e) {
      return Left(AuthFailure(message: 'Failed to update password.'));
    }
  }

  // ─── Fetch Current User Data ──────────────────────────────────────────────
  @override
  Future<Either<Failure, UserModel>> fetchCurrentUserData() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        return Left(AuthFailure(message: 'Not authenticated.'));
      }

      final doc = await _firestore
          .collection(FirebaseConstants.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        return Left(FirestoreFailure(message: 'User profile not found.'));
      }

      return Right(UserModel.fromMap(doc.data()!, uid));
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Firestore error.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to fetch user data.'));
    }
  }

  // ─── Update FCM Token ─────────────────────────────────────────────────────
  @override
  Future<Either<Failure, void>> updateFcmToken(String uid, String token) async {
    try {
      await _firestore.collection(FirebaseConstants.users).doc(uid).update({
        'fcmToken': token,
      });
      return const Right(null);
    } catch (e) {
      return Left(FirestoreFailure(message: 'Failed to update FCM token.'));
    }
  }

  // ─── Auth State Helpers ───────────────────────────────────────────────────
  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  String? get currentUid => _auth.currentUser?.uid;

  // ─── Firebase Error Code Mapper ───────────────────────────────────────────
  String _mapAuthError(String code) {
    return switch (code) {
      'user-not-found' => 'No account found for this email.',
      'invalid-credential' => 'Invalid email or password.',
      'user-disabled' =>
        'Your Account Has Been Deactivated. Please Contact Admin.',
      'email-already-in-use' => 'An account already exists with this email.',
      'weak-password' => 'Password is too weak.',
      'invalid-email' => 'The email address is badly formatted.',
      'network-request-failed' => 'No internet connection.',
      'too-many-requests' => 'Too many login attempts. Try again later.',
      'requires-recent-login' =>
        'Please sign in again before changing your password.',
      'wrong-password' => 'Current password is incorrect.',
      _ => 'An unexpected error occurred.',
    };
  }
}
