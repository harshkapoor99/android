import 'package:flutter/material.dart';

class ChatMessage {
  final bool isMe;
  final String text;
  final DateTime time;

  ChatMessage({required this.isMe,required this.text, required this.time});

  factory ChatMessage.fromMap(Map<String, dynamic> json) => ChatMessage(
    isMe: json["sender"] == "user" ? true : false,
    text: json["message"],
    // TODO: remove time conversion after resolving from backend
    time: DateTime.parse(
      json["timestamp"].runtimeType == String
          ? json["timestamp"].contains("Z")
              ? json["timestamp"]
              : json["timestamp"].padRight(26, "0") + ("Z")
          : json["timestamp"],
    ),
  );

  Map<String, dynamic> toMap() => {
    "isMe": isMe,
    "message": text,
    "timestamp": time.toIso8601String(),
  };
}

// {
//   "sender": "ai",
//   "message": "Hello! I'm Don, nice to meet you! 😊 How's your day going?",
//   "timestamp": "2025-05-09T02:45:31.714"
// }
