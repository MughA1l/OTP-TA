import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../core/constants/firebase_constants.dart';
import '../../core/error/failures.dart';
import '../models/staff_model.dart';
import 'staff_repository.dart';

class StaffRepositoryImpl implements IStaffRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> createStaff(StaffModel staff, String uid) async {
    try {
      // In this setup, we store staff data in the 'users' collection 
      // where role = admin, doctor, or receptionist.
      // Alternatively, keeping a dedicated 'staff' collection.
      // Roadmap says: "Create `staff` Firestore collection schema"
      
      // We'll store basic user data in 'users' collection via Firebase Cloud Function
      // For now, we manually write to 'users' collection to keep them consistent
      
      final batch = _firestore.batch();
      
      // Update/Create user doc
      final userRef = _firestore.collection(FirebaseConstants.users).doc(uid);
      batch.set(userRef, {
        'email': staff.email,
        'role': staff.role,
        'status': 'active',
        'displayName': staff.name,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Depending on role, we might store extra data in doctors collection
      if (staff.role == 'doctor') {
        final doctorRef = _firestore.collection(FirebaseConstants.doctors).doc(uid);
        batch.set(doctorRef, staff.toMap());
      } else {
        // We'll just use a 'staff' collection for admin/receptionists as per roadmap
        final staffRef = _firestore.collection('staff').doc(uid);
        batch.set(staffRef, staff.toMap());
      }

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to create staff.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateStaff(StaffModel staff) async {
    try {
      if (staff.role == 'doctor') {
        await _firestore
            .collection(FirebaseConstants.doctors)
            .doc(staff.staffId)
            .update(staff.toMap());
      } else {
        await _firestore
            .collection('staff')
            .doc(staff.staffId)
            .update(staff.toMap());
      }
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to update staff.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<StaffModel>> watchAllStaff() {
    // Note: Since doctors are in `doctors` and others in `staff`, 
    // a real app would merge streams or use a single `users` collection.
    // For simplicity following the roadmap, we fetch all from 'users' collection 
    // where role != 'patient' and map them.
    
    return _firestore
        .collection(FirebaseConstants.users)
        .where('role', whereIn: ['admin', 'doctor', 'receptionist'])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StaffModel(
          staffId: doc.id,
          name: data['displayName'] as String? ?? 'Unknown',
          email: data['email'] as String? ?? '',
          phone: data['phone'] as String? ?? 'N/A', // Assuming phone might be saved here
          role: data['role'] as String? ?? 'doctor',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }
}
