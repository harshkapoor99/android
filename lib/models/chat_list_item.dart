import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';

class ChatListItem {
  final String sessionId;
  final String creatorId;
  final Character character;
  final ChatMessage lastChat;
  final bool hasNewMessage;

  ChatListItem({
    required this.sessionId,
    required this.creatorId,
    required this.character,
    required this.lastChat,
    this.hasNewMessage = false,
  });

  factory ChatListItem.fromMap(Map<String, dynamic> json) => ChatListItem(
    sessionId: json["session_id"],
    creatorId: json["creator_id"],
    character: Character.fromMap(json["character"]),
    lastChat: ChatMessage.fromMap(json["latest_chat"]),
  );

  Map<String, dynamic> toMap() => {
    "session_id": sessionId,
    "creator_id": creatorId,
    "character": character.toMap(),
    "latest_chat": lastChat.toMap(),
  };

  ChatListItem copyWith({
    String? sessionId,
    String? creatorId,
    Character? character,
    ChatMessage? lastChat,
    bool? hasNewMessage,
  }) {
    return ChatListItem(
      sessionId: sessionId ?? this.sessionId,
      creatorId: creatorId ?? this.creatorId,
      character: character ?? this.character,
      lastChat: lastChat ?? this.lastChat,
      hasNewMessage: hasNewMessage ?? this.hasNewMessage,
    );
  }
}
