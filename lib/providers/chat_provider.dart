import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:guftagu_mobile/enums/player_status.dart';
import 'package:guftagu_mobile/models/character.dart';
import 'package:guftagu_mobile/models/chat_list_item.dart';
import 'package:guftagu_mobile/models/gen_image.dart';
import 'package:guftagu_mobile/models/master/chat_message.dart';
import 'package:guftagu_mobile/models/character_details.dart';
import 'package:guftagu_mobile/services/chat_service.dart';
import 'package:guftagu_mobile/services/hive_service.dart';
import 'package:guftagu_mobile/utils/download_audio.dart';
import 'package:guftagu_mobile/utils/extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/chat_provider.gen.dart';

@Riverpod(keepAlive: true)
class Chat extends _$Chat {
  @override
  ChatState build() {
    final initialState = ChatState(
      messageController: TextEditingController(),
      recordController:
          RecorderController()
            ..androidEncoder = AndroidEncoder.aac
            ..androidOutputFormat = AndroidOutputFormat.mpeg4
            ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
            ..sampleRate = 44100,
      playerController: PlayerController(),
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
    initialState.recordController.onRecorderStateChanged.listen((recState) {
      state = state._updateWith(isRecording: recState.isRecording);
    });
    initialState.playerController.onPlayerStateChanged.listen((playerState) {
      late PlayerStatus status;
      if (playerState == PlayerState.playing) {
        status = PlayerStatus.playing;
      } else if (playerState == PlayerState.paused) {
        status = PlayerStatus.paused;
      } else if (playerState == PlayerState.stopped) {
        status = PlayerStatus.stopped;
      }
      state = state._updateWith(playerStatus: status);
    });

    // Dispose controller when provider is disposed
    ref.onDispose(() {
      initialState.messageController.removeListener(_handleTextChange);
      initialState.messageController.dispose();
      initialState.recordController.dispose();
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
    if (chatIndex != -1) {
      chatList[chatIndex] = chatList[chatIndex].copyWith(hasNewMessage: false);
    }

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

  Future<void> startOrStopRecording() async {
    try {
      if (state.isRecording) {
        final path = await state.recordController.stop();
        if (path != null) {
          print(path);
          print("Recorded file size: ${File(path).lengthSync()}");
          appendChat(isMe: true, time: DateTime.now(), audioPath: path);
        }
      } else {
        state.recordController.record();
      }
    } catch (e) {
      rethrow;
    }

    // Future.delayed(const Duration(milliseconds: 500), () {
    //   appendChat(
    //     isMe: false,
    //     text: "🤖 Got your voice message!",
    //     time: DateTime.now(),
    //   );
    // });
  }

  Future<void> preparePlayer({
    required ChatMessage message,
    String? url,
    String? path,
    int samples = 100,
  }) async {
    assert(url != null || path != null, "either url or path must be provided");

    // Stop and clean up previous player if it exists
    if (state.playerStatus != PlayerStatus.stopped) {
      await state.playerController.stopPlayer();
    }

    // Release resources from previous playback
    // if (message.audioPath != path) {
    await state.playerController.release();
    // }

    String filePath = "";

    if (path.hasValue) {
      filePath = path!;
    } else if (url.hasValue) {
      final file = await downloadAudio(url!);
      filePath = file.filePath;
    }

    if (filePath.hasValue) {
      await state.playerController.preparePlayer(
        path: filePath,
        shouldExtractWaveform: true,
        noOfSamples: samples,
      );

      state.playerController.setFinishMode(finishMode: FinishMode.pause);

      // state.playerStatus = PlayerStatus.stopped;
      state.playerController.startPlayer();
      state = state._updateWith();
    }
  }

  // Future<void> preparePlayer({
  //   String? url,
  //   String? path,
  //   int samples = 100,
  // }) async {
  //   assert(url != null || path != null, "either url or path must be provided");
  //   // Skip if we're already preparing/playing the same voice
  //   if (state.selectedVoice?.id == voice.id &&
  //       state.playerStatus != PlayerStatus.stopped) {
  //     return;
  //   }

  //   // Stop and clean up previous player if it exists
  //   if (state.playerStatus != PlayerStatus.stopped) {
  //     await state.playerController.stopPlayer();
  //   }

  //   // Release resources from previous playback
  //   if (state.downloadedFilePath != null) {
  //     await state.playerController.release();
  //   }

  //   state.selectedVoice = voice;
  //   state.playerStatus = PlayerStatus.loading;
  //   state = state.updateWith(state);

  //   final res = await ref
  //       .read(audioServiceProvider)
  //       .generateAudio(
  //         text:
  //             "Hello, ${ref.read(hiveServiceProvider.notifier).getUserInfo()?.profile.fullName ?? ""}! It's nice to meet you! How are you?",
  //         languageId: voice.languageId,
  //         vocalId: voice.vocalId,
  //       );

  //   final String voiceUrl = res.data["tts_audio_url"];

  //   state.currentPath = voiceUrl ?? path;
  //   state = state.updateWith(state);

  //   try {
  //     if (voiceUrl.hasValue) {
  //       String filePath = voiceUrl;

  //       if (state.downloadedFilePath != null) {
  //         try {
  //           final file = File(state.downloadedFilePath!);
  //           if (file.existsSync()) {
  //             file.deleteSync();
  //           }
  //         } catch (e) {
  //           print('Error deleting audio file: $e');
  //         }
  //       }
  //       await _downloadAudio(voiceUrl);
  //       filePath = state.downloadedFilePath!;
  //       await state.playerController.preparePlayer(
  //         path: filePath,
  //         shouldExtractWaveform: true,
  //         noOfSamples: samples,
  //       );
  //       state.playerController.setFinishMode(finishMode: FinishMode.pause);

  //       // state.playerStatus = PlayerStatus.stopped;
  //       state.playerController.startPlayer();
  //       state = state.updateWith(state);
  //     }
  //   } catch (e) {
  //     state.playerStatus = PlayerStatus.error;
  //     state = state.updateWith(state);
  //     rethrow;
  //   }
  // }

  Future<void> startPlayer() async {
    await state.playerController.startPlayer();
  }

  Future<void> pausePlayer() async {
    await state.playerController.pausePlayer();
  }

  Future<void> stopPlayer() async {
    await state.playerController.stopPlayer();
  }
}

class ChatState {
  ChatState({
    required this.messageController,
    required this.recordController,
    required this.playerController,
    this.playerStatus = PlayerStatus.stopped,
    this.hasMessage = false,
    this.isTyping = false,
    this.isFetchingHistory = true,
    this.isFetchingChatList = true,
    this.isRecording = false,
    this.character,
    this.characterDetail,
    required this.messages,
    required this.chatList,
  });
  final bool hasMessage,
      isTyping,
      isFetchingHistory,
      isFetchingChatList,
      isRecording;
  final TextEditingController messageController;
  final RecorderController recordController;
  final PlayerController playerController;
  final PlayerStatus playerStatus;
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
    bool? isRecording,
    TextEditingController? messageController,
    RecorderController? recordController,
    PlayerController? playerController,
    PlayerStatus? playerStatus,
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
      recordController: recordController ?? this.recordController,
      playerController: playerController ?? this.playerController,
      playerStatus: playerStatus ?? this.playerStatus,
      isRecording: isRecording ?? this.isRecording,
      character: character ?? this.character,
      characterDetail: characterDetail ?? this.characterDetail,
      messages: messages ?? this.messages,
      chatList: chatList ?? this.chatList,
    );
  }
}
