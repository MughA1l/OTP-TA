import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageStatus { sent, delivered, read }

class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final MessageStatus status;
  final DateTime timestamp;
  final List<String> sharedFiles;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.status,
    required this.timestamp,
    required this.sharedFiles,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    return MessageModel(
      messageId: docId,
      senderId: map['senderId'] as String? ?? '',
      text: map['text'] as String? ?? '',
      status: _statusFromString(map['status'] as String?),
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      sharedFiles: List<String>.from(map['sharedFiles'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'status': status.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'sharedFiles': sharedFiles,
    };
  }

  static MessageStatus _statusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }

  MessageModel copyWith({
    String? messageId,
    String? senderId,
    String? text,
    MessageStatus? status,
    DateTime? timestamp,
    List<String>? sharedFiles,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      sharedFiles: sharedFiles ?? this.sharedFiles,
    );
  }
}

class ChatRoomModel {
  final String roomId;
  final List<String> participants;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool hasEmergency;
  final String? emergencyTriggeredBy;
  final bool? emergencyAcknowledged;

  ChatRoomModel({
    required this.roomId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.hasEmergency,
    this.emergencyTriggeredBy,
    this.emergencyAcknowledged,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatRoomModel(
      roomId: docId,
      participants: List<String>.from(map['participants'] as List? ?? []),
      lastMessage: map['lastMessage'] as String? ?? '',
      lastMessageTime:
          (map['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      hasEmergency: map['hasEmergency'] as bool? ?? false,
      emergencyTriggeredBy: map['emergencyTriggeredBy'] as String?,
      emergencyAcknowledged: map['emergencyAcknowledged'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'hasEmergency': hasEmergency,
      if (emergencyTriggeredBy != null)
        'emergencyTriggeredBy': emergencyTriggeredBy,
      if (emergencyAcknowledged != null)
        'emergencyAcknowledged': emergencyAcknowledged,
    };
  }

  ChatRoomModel copyWith({
    String? roomId,
    List<String>? participants,
    String? lastMessage,
    DateTime? lastMessageTime,
    bool? hasEmergency,
    String? emergencyTriggeredBy,
    bool? emergencyAcknowledged,
  }) {
    return ChatRoomModel(
      roomId: roomId ?? this.roomId,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      hasEmergency: hasEmergency ?? this.hasEmergency,
      emergencyTriggeredBy: emergencyTriggeredBy ?? this.emergencyTriggeredBy,
      emergencyAcknowledged:
          emergencyAcknowledged ?? this.emergencyAcknowledged,
    );
  }
}
