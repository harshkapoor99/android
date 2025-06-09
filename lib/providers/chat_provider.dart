import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/chat_list_item.dart';
import 'package:guftagu_mobile/models/gen_image.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/models/character_details.dart';
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
      messages: [],
      chatList: [],
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

  void initiateChatWithCharacter() async {
    try {
      Future.microtask(() {
        state = state._updateWith(isFetchingChatList: true);
      });
      state.messageController.clear();
      final response = await ref
          .read(chatServiceProvider)
          .initChat(
            characterId: state.character!.id,
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
          );

      String reply = response.data["reply"];

      appendChat(isMe: false, text: reply, time: DateTime.now());
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isTyping: false);
    }
  }

  void chatWithCharacter() async {
    try {
      appendChat(
        isMe: true,
        text: state.messageController.text,
        time: DateTime.now(),
      );
      state = state._updateWith(isTyping: true);
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

      appendChat(isMe: false, text: reply, time: DateTime.now());
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isTyping: false);
    }
  }

  void sendStaticVoiceMessage() {
    appendSvgChat(
      isMe: true,
      svgWidget: SvgPicture.asset(
        'assets/svgs/wavesmic.svg',
        // height: 50,
        // width: 150,
        fit: BoxFit.contain,
      ),
      time: DateTime.now(),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      appendChat(
        isMe: false,
        text: "🤖 Got your voice message!",
        time: DateTime.now(),
      );
    });
  }

  void fetchChatList() async {
    try {
      state = state._updateWith(isFetchingChatList: true);
      final response = await ref
          .read(chatServiceProvider)
          .chatList(
            creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
          );

      final List<dynamic> chatsList = response.data["chats"];
      final List<ChatListItem> parsedChatsList =
          chatsList.map((e) {
            return ChatListItem.fromMap(e);
          }).toList();
      if (chatsList.isNotEmpty) {
        if (state.chatList.isNotEmpty) {
          var chatList = state.chatList;
          for (var i = 0; i < parsedChatsList.length; i++) {
            var chat = chatList.firstWhereOrNull(
              (element) => element.sessionId == parsedChatsList[i].sessionId,
            );
            if (chat != null) {
              bool hasNewMessage =
                  chat.lastChat.message != parsedChatsList[i].lastChat.message;
              if (hasNewMessage || chat.hasNewMessage) {
                parsedChatsList[i] = parsedChatsList[i].copyWith(
                  hasNewMessage: hasNewMessage || chat.hasNewMessage,
                );
              }
            }
          }
        }
        state = state._updateWith(chatList: parsedChatsList);
      } else {}
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isFetchingChatList: false);
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
            return ChatMessage.fromMap(e);
          }).toList();
      if (chats.isNotEmpty) {
        state = state._updateWith(messages: parsedChats);
      } else {
        initiateChatWithCharacter();
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isFetchingHistory: false);
    }
  }

  void clearHistory() {
    state.messageController.clear();
    state = state._updateWith(
      messages: [],
      isFetchingHistory: true,
      isTyping: false,
    );
  }

  void clearChatList() {
    state = state._updateWith(chatList: []);
  }

  void setCharacter(Character character) {
    var chatList = state.chatList;
    var chatIndex = chatList.indexWhere(
      (element) => element.character.id == character.id,
    );

    chatList[chatIndex] = chatList[chatIndex].copyWith(hasNewMessage: false);

    state = state._updateWith(character: character, chatList: chatList);
  }

  void appendChat({
    required bool isMe,
    String? text,
    required DateTime time,
    String? audioPath,
  }) {
    ChatMessage newMessage = ChatMessage(
      characterId: state.character!.id,
      sender: isMe ? "user" : "ai",
      creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
      sessionId:
          state.character!.id +
          ref.read(hiveServiceProvider.notifier).getUserId()!,

      isMe: isMe,
      message: text,
      timestamp: time,
      audioPath: audioPath,
    );

    updateChatList(newMessage, state.messages.isEmpty);

    state = state._updateWith(messages: [newMessage, ...state.messages]);
  }

  void updateChatList(ChatMessage message, bool isNew) {
    var list = state.chatList;
    for (var i = 0; i < list.length; i++) {
      if (list[i].character.id == state.character?.id) {
        list[i] = list[i].copyWith(lastChat: message, hasNewMessage: isNew);
      }
    }
    state = state._updateWith(chatList: list);
  }

  void updateImage(GenImage image) {
    if (state.character != null) {
      state = state._updateWith(
        character: state.character!.updateWith(imageGallery: [image]),
      );
    }
  }
}

class ChatState {
  ChatState({
    required this.messageController,
    this.hasMessage = false,
    this.isTyping = false,
    this.isFetchingHistory = true,
    this.isFetchingChatList = true,
    this.character,
    this.characterDetail,
    required this.messages,
    required this.chatList,
  });
  final bool hasMessage, isTyping, isFetchingHistory, isFetchingChatList;
  final TextEditingController messageController;
  final List<ChatMessage> messages;
  final List<ChatListItem> chatList;

  final Character? character;
  final CharacterDetail? characterDetail;

  // ignore: unused_element
  ChatState _updateWith({
    bool? hasMessage,
    bool? isTyping,
    bool? isFetchingHistory,
    bool? isFetchingChatList,
    TextEditingController? messageController,
    Character? character,
    CharacterDetail? characterDetail,
    List<ChatMessage>? messages,
    List<ChatListItem>? chatList,
  }) {
    return ChatState(
      hasMessage: hasMessage ?? this.hasMessage,
      isTyping: isTyping ?? this.isTyping,
      isFetchingHistory: isFetchingHistory ?? this.isFetchingHistory,
      isFetchingChatList: isFetchingChatList ?? this.isFetchingChatList,
      messageController: messageController ?? this.messageController,
      character: character ?? this.character,
      characterDetail: characterDetail ?? this.characterDetail,
      messages: messages ?? this.messages,
      chatList: chatList ?? this.chatList,
    );
  }
}
