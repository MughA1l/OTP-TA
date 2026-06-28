import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../core/error/failures.dart';
import '../models/chat_model.dart';
import 'chat_repository.dart';

class ChatRepositoryImpl implements IChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, void>> createRoomIfNotExists(String roomId, List<String> participants) async {
    try {
      final docRef = _firestore.collection('chat_rooms').doc(roomId);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        final newRoom = ChatRoomModel(
          roomId: roomId,
          participants: participants,
          lastMessage: '',
          lastMessageTime: DateTime.now(),
          hasEmergency: false,
        );
        await docRef.set(newRoom.toMap());
      }
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to create chat room.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String roomId, MessageModel message) async {
    try {
      final batch = _firestore.batch();
      
      final roomRef = _firestore.collection('chat_rooms').doc(roomId);
      final messageRef = roomRef.collection('messages').doc(message.messageId);

      // We handle dynamic messageId creation if it's empty
      final String idToUse = message.messageId.isEmpty ? roomRef.collection('messages').doc().id : message.messageId;
      
      final messageData = message.copyWith(messageId: idToUse).toMap();
      
      batch.set(roomRef.collection('messages').doc(idToUse), messageData);
      
      batch.update(roomRef, {
        'lastMessage': message.text,
        'lastMessageTime': Timestamp.fromDate(message.timestamp),
      });

      await batch.commit();
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to send message.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MessageModel.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Stream<List<ChatRoomModel>> watchUserRooms(String userId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatRoomModel.fromMap(doc.data(), doc.id)).toList());
  }

  @override
  Future<Either<Failure, void>> markAsRead(String roomId, String messageId) async {
    try {
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .update({'status': MessageStatus.read.name});
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to mark message as read.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> searchMessages(String roomId, String query) async {
    try {
      final snapshot = await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .get();
      
      final messages = snapshot.docs.map((doc) => MessageModel.fromMap(doc.data(), doc.id)).toList();
      final filteredMessages = messages.where((m) => m.text.toLowerCase().contains(query.toLowerCase())).toList();
      
      return Right(filteredMessages);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to search messages.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, void>> triggerEmergencyAlert(String roomId, List<String> fcmTokens) async {
    try {
      // 1. Update Firestore Document
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'hasEmergency': true,
      });

      // 2. Mock HTTP call to Render server for push notification dispatch
      final url = Uri.parse('https://otpta-backend.onrender.com/api/notify/emergency');
      try {
        await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'roomId': roomId,
            'tokens': fcmTokens,
            'message': 'EMERGENCY: Immediate attention required in chat room $roomId',
          }),
        ).timeout(const Duration(seconds: 5)); // Ignore timeout/failure since it's a mock endpoint
      } catch (e) {
        // Suppress HTTP errors since Render.com backend is just mocked for this assignment step.
      }

      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirestoreFailure(message: e.message ?? 'Failed to trigger emergency alert.'));
    } catch (e) {
      return Left(FirestoreFailure(message: 'An unexpected error occurred.'));
    }
  }
}
