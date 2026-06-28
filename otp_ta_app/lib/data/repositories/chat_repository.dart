import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/chat_model.dart';

abstract class IChatRepository {
  /// Ensures a chat room exists between the participants.
  Future<Either<Failure, void>> createRoomIfNotExists(String roomId, List<String> participants);

  /// Sends a new message and updates the room's lastMessage.
  Future<Either<Failure, void>> sendMessage(String roomId, MessageModel message);

  /// Streams real-time messages for a given room.
  Stream<List<MessageModel>> watchMessages(String roomId);

  /// Streams real-time chat rooms for a specific user.
  Stream<List<ChatRoomModel>> watchUserRooms(String userId);

  /// Streams real-time updates for a single chat room.
  Stream<ChatRoomModel> watchRoom(String roomId);

  /// Marks a specific message as read (SRS-90).
  Future<Either<Failure, void>> markAsRead(String roomId, String messageId);

  /// Searches messages in a room by query (SRS-90).
  Future<Either<Failure, List<MessageModel>>> searchMessages(String roomId, String query);

  /// Triggers an emergency alert for a specific room (SRS-92).
  Future<Either<Failure, void>> triggerEmergencyAlert(String roomId, String triggeredById, List<String> fcmTokens);

  /// Acknowledges an active emergency alert (SRS-93).
  Future<Either<Failure, void>> acknowledgeEmergency(String roomId);
}
