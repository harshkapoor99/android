import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/chat_list_item.dart';
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
        ref.read(hiveServiceProvider.notifier).setHasStartedChat(value: true);
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

  void fetchCharacterDetails() async {
    state = state._updateWith(isFetchingCharacterDetails: true);
    try {
      final response = await ref
          .read(chatServiceProvider)
          .fetchCharacterDetails(characterId: state.character!.id);

      if (response.statusCode == 200) {
        final characterDetail = CharacterDetail.fromMap(response.data["data"]);

        state = state._updateWith(characterDetail: characterDetail);
      } else {
        initiateChatWithCharacter();
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isFetchingCharacterDetails: false);
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
    state = state._updateWith(character: character);
  }

  void appendChat({
    required bool isMe,
    required String text,
    required DateTime time,
  }) {
    state = state._updateWith(
      messages: [
        ChatMessage(isMe: isMe, text: text, time: time),
        ...state.messages,
      ],
    );
  }

  void appendSvgChat({
    required bool isMe,
    required Widget svgWidget,
    required DateTime time,
  }) {
    state = state._updateWith(
      messages: [
        ChatMessage(isMe: isMe, text: '', customContent: svgWidget, time: time),
        ...state.messages,
      ],
    );
  }
}

class ChatState {
  ChatState({
    required this.messageController,
    this.hasMessage = false,
    this.isTyping = false,
    this.isFetchingHistory = true,
    this.isFetchingChatList = true,
    this.isFetchingCharacterDetails = true,
    this.character,
    this.characterDetail,
    required this.messages,
    required this.chatList,
  });
  final bool hasMessage,
      isTyping,
      isFetchingHistory,
      isFetchingChatList,
      isFetchingCharacterDetails;
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
    bool? isFetchingCharacterDetails,
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
      isFetchingCharacterDetails:
          isFetchingCharacterDetails ?? this.isFetchingCharacterDetails,
      messageController: messageController ?? this.messageController,
      character: character ?? this.character,
      characterDetail: characterDetail ?? this.characterDetail,
      messages: messages ?? this.messages,
      chatList: chatList ?? this.chatList,
    );
  }
}
