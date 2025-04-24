import 'package:guftagu_mobile/models/character.dart';

class ChatListItem {
  final String sessionId;
  final String creatorId;
  final Character character;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatListItem({
    required this.sessionId,
    required this.creatorId,
    required this.character,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory ChatListItem.fromMap(Map<String, dynamic> json) => ChatListItem(
    sessionId: json["session_id"],
    creatorId: json["creator_id"],
    character: Character.fromMap(json["character"]),
    lastMessage: json["last_message"],
    lastMessageTime: DateTime.parse(json["last_message_time"]),
  );

  Map<String, dynamic> toMap() => {
    "session_id": sessionId,
    "creator_id": creatorId,
    "character": character.toMap(),
    "last_message": lastMessage,
    "last_message_time": lastMessageTime.toIso8601String(),
  };
}
