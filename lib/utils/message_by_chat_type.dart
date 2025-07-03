import 'package:guftagu_mobile/enums/chat_type.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';

String getMessageFromChatType(ChatMessage message) {
  String? text;
  switch (ChatType.fromString(message.chatType)) {
    case ChatType.text:
      text = message.message?.replaceAll(RegExp(r'\n+'), '');
      break;

    case ChatType.audio:
      text = "Sent a audio message.";
      break;
    case ChatType.file:
      text = "Sent a file.";
      break;
    case ChatType.image:
      text = "Sent an image.";
      break;

    default:
      text = "";
  }
  return "${message.isMe ? "You: " : ""}$text";
}
