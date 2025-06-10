// To parse this JSON data, do
//
//     final chatMessage = chatMessageFromJson(jsonString);

import 'dart:convert';

ChatMessage chatMessageFromJson(String str) =>
    ChatMessage.fromMap(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toMap());

class ChatMessage {
  bool isMe;
  String characterId;
  String sender;
  String creatorId;
  String? message;
  DateTime timestamp;
  String sessionId;
  String? voiceUrl;
  String? imageUrl;
  String? chatType;
  DateTime? createdDate;
  DateTime? updatedDate;
  int? status;
  String? audioPath;

  ChatMessage({
    required this.isMe,
    required this.characterId,
    required this.sender,
    required this.creatorId,
    this.message,
    required this.timestamp,
    required this.sessionId,
    this.voiceUrl,
    this.imageUrl,
    this.chatType,
    this.createdDate,
    this.updatedDate,
    this.status,
    this.audioPath,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> json) => ChatMessage(
    isMe: json["sender"] == "user" ? true : false,
    characterId: json["character_id"],
    sender: json["sender"],
    creatorId: json["creator_id"],
    message: json["message"],
    timestamp: DateTime.parse(
      json["timestamp"].runtimeType == String
          ? json["timestamp"].contains("Z")
              ? json["timestamp"]
              : json["timestamp"].padRight(26, "0") + ("Z")
          : json["timestamp"],
    ),
    sessionId: json["session_id"],
    voiceUrl: json["voice_url"],
    imageUrl: json["image_url"],
    chatType: json["chat_type"],
    createdDate: DateTime.parse(json["created_date"]),
    updatedDate: DateTime.parse(json["updated_date"]),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "character_id": characterId,
    "sender": sender,
    "creator_id": creatorId,
    "message": message,
    "timestamp": timestamp.toIso8601String(),
    "session_id": sessionId,
    "voice_url": voiceUrl,
    "image_url": imageUrl,
    "chat_type": chatType,
    "created_date": createdDate?.toIso8601String(),
    "updated_date": updatedDate?.toIso8601String(),
    "status": status,
  };
}
