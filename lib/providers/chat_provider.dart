import 'package:flutter/material.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/services/chat_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/chat_provider.gen.dart';

@Riverpod(keepAlive: true)
class Chat extends _$Chat {
  @override
  ChatState build() {
    final initialState = ChatState(
      messageController: TextEditingController(),
      hasMessage: false,
      messages: [ChatMessage(isMe: false, text: "Hey, What's up?")],
    );

    // Add listener
    initialState.messageController.addListener(_handleTextChange);
    initialState.messageController.addListener(() {
      state = state._updateWith(
        messageController: initialState.messageController,
      );
    });

    // Dispose controller when provider is disposed
    ref.onDispose(() {
      initialState.messageController.removeListener(_handleTextChange);
      initialState.messageController.dispose();
    });

    return initialState;
  }

  void _handleTextChange() {
    final hasText = state.messageController.text.trim().isNotEmpty;
    if (hasText != state.hasMessage) {
      state = state._updateWith(hasMessage: hasText);
    }
  }

  void chatWithCharacter() async {
    try {
      appendChat(isMe: true, text: state.messageController.text);
      String message = state.messageController.text;
      state.messageController.clear();
      final response = await ref
          .read(chatServiceProvider)
          .chat(
            characterId: state.character!.id,
            message: message,
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
          );

      String reply = response.data["reply"];

      appendChat(isMe: false, text: reply);
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isTyping: false);
    }
  }

  void fetchChatHistory() async {
    try {
      final response = await ref
          .read(chatServiceProvider)
          .chatHistory(
            characterId: state.character!.id,
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
          );

      final List<dynamic> chats = response.data["chats"];
      final List<ChatMessage> parsedChats =
          chats.map((e) {
            return ChatMessage(
              isMe: e["sender"] == "user" ? true : false,
              text: e['message'],
            );
          }).toList();
      if (chats.isNotEmpty) {
        state = state._updateWith(
          messages: [
            ChatMessage(isMe: false, text: "Hey, What's up?"),
            ...parsedChats,
          ],
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isFetchingHistory: false);
    }
  }

  void clearHistory() {
    state = state._updateWith(
      messages: [ChatMessage(isMe: false, text: "Hey, What's up?")],
      isFetchingHistory: true,
      isTyping: false,
    );
  }

  void setCharacter(Character character) {
    state = state._updateWith(character: character);
  }

  void appendChat({required bool isMe, required String text}) {
    state = state._updateWith(
      messages: [...state.messages, ChatMessage(isMe: isMe, text: text)],
      isTyping: isMe,
    );
  }
}

class ChatState {
  ChatState({
    required this.messageController,
    this.hasMessage = false,
    this.isTyping = false,
    this.isFetchingHistory = true,
    this.character,
    required this.messages,
  });
  final bool hasMessage, isTyping, isFetchingHistory;
  final TextEditingController messageController;
  final List<ChatMessage> messages;

  final Character? character;

  // ignore: unused_element
  ChatState _updateWith({
    bool? hasMessage,
    bool? isTyping,
    bool? isFetchingHistory,
    TextEditingController? messageController,
    Character? character,
    List<ChatMessage>? messages,
  }) {
    return ChatState(
      hasMessage: hasMessage ?? this.hasMessage,
      isTyping: isTyping ?? this.isTyping,
      isFetchingHistory: isFetchingHistory ?? this.isFetchingHistory,
      messageController: messageController ?? this.messageController,
      character: character ?? this.character,
      messages: messages ?? this.messages,
    );
  }
}

class ChatMessage {
  final bool isMe;
  final String text;

  ChatMessage({required this.isMe, required this.text});

  factory ChatMessage.fromMap(Map<String, dynamic> json) =>
      ChatMessage(isMe: json["isMe"], text: json["text"]);

  Map<String, dynamic> toMap() => {"isMe": isMe, "text": text};
}
