import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:guftagu_mobile/enums/chat_type.dart';
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
import 'package:guftagu_mobile/utils/print_debug.dart';
import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/providers/chat_provider.gen.dart';

@Riverpod(keepAlive: true)
class Chat extends _$Chat {
  @override
  ChatState build() {
    final initialState = ChatState(
      messageController: TextEditingController(),
      searchController: TextEditingController(),
      recordController:
          RecorderController()
            ..androidEncoder = AndroidEncoder.aac
            ..androidOutputFormat = AndroidOutputFormat.mpeg4
            ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
            ..sampleRate = 44100
            ..bitRate = 256000,
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

      appendChat(
        isMe: false,
        type: ChatType.text,
        text: reply,
        time: DateTime.now(),
      );
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
        type: ChatType.text,
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

      appendChat(
        isMe: false,
        type: ChatType.text,
        text: reply,
        time: DateTime.now(),
      );
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isTyping: false);
    }
  }

  void fileChatWithCharacter({bool isImage = false}) async {
    try {
      if (state.uploadFile != null) {
        String fileName = basename(state.uploadFile!.path);
        appendChat(
          isMe: true,
          type: isImage ? ChatType.image : ChatType.file,
          text: state.messageController.text,
          time: DateTime.now(),
          filePath: state.uploadFile?.path,
          fileName: fileName,
        );
        state = state._updateWith(isTyping: true);
        String message = state.messageController.text;
        File? file = state.uploadFile;
        dettachFile();
        state.messageController.clear();
        final response = await ref
            .read(chatServiceProvider)
            .sendFileChatMessage(
              file: file!,
              fileName: fileName,
              characterId: state.character!.id,
              creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
              message: message,
            );

        String reply = response.data["assistant_response"];

        appendChat(
          isMe: false,
          type: ChatType.text,
          text: reply,
          time: DateTime.now(),
        );
      }
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

    state = state._updateWith(
      character: character,
      chatList: chatList,
      messages: [],
    );
  }

  void appendChat({
    required bool isMe,
    required ChatType type,
    String? text,
    required DateTime time,
    String? audioPath,
    String? voiceUrl,
    String? fileUrl,
    String? filePath,
    String? fileName,
  }) {
    ChatMessage newMessage = ChatMessage(
      chatType: type.name,
      id: UniqueKey().toString(),
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
      voiceUrl: voiceUrl,
      fileUrl: fileUrl,
      filePath: filePath,
      fileName: fileName,
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
          printDebug(path);
          printDebug("Recorded file size: ${File(path).lengthSync()}");
          appendChat(
            isMe: true,
            type: ChatType.audio,
            time: DateTime.now(),
            audioPath: path,
          );
          state = state._updateWith(isTyping: true);
          state.messageController.clear();
          final response = await ref
              .read(chatServiceProvider)
              .sendAudioChatMessage(
                audioFile: File(path),
                sessionId:
                    state.character!.id +
                    ref.read(hiveServiceProvider.notifier).getUserId()!,
                characterId: state.character!.id,
                creatorId: ref.read(hiveServiceProvider.notifier).getUserId()!,
              );

          String replyUrl = response.data["tts_audio_url"];
          final file = await downloadAssetFromUrl(replyUrl);

          appendChat(
            isMe: false,
            type: ChatType.audio,
            time: DateTime.now(),
            audioPath: file.filePath,
          );
        }
      } else {
        state.recordController.record();
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state._updateWith(isTyping: false);
    }
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
      final file = await downloadAssetFromUrl(url!);
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

  Future<void> startPlayer() async {
    await state.playerController.startPlayer();
  }

  Future<void> pausePlayer() async {
    await state.playerController.pausePlayer();
  }

  Future<void> stopPlayer() async {
    await state.playerController.stopPlayer();
  }

  void attachFile(File file, {bool isImage = false}) {
    state = state._updateWith(uploadFile: file, isAttachmentImage: isImage);
  }

  void dettachFile() {
    state.uploadFile = null;
    state = state._copyWith(state);
  }
}

class ChatState {
  ChatState({
    required this.messageController,
    required this.recordController,
    required this.playerController,
    required this.searchController,
    this.playerStatus = PlayerStatus.stopped,
    this.hasMessage = false,
    this.isTyping = false,
    this.isFetchingHistory = true,
    this.isFetchingChatList = true,
    this.isRecording = false,
    this.isSearching = false,
    this.uploadFile,
    this.isAttachmentImage = false,
    this.character,
    this.characterDetail,
    required this.messages,
    required this.chatList,
  });
  bool hasMessage,
      isTyping,
      isFetchingHistory,
      isFetchingChatList,
      isRecording,
      isSearching,
      isAttachmentImage;
  TextEditingController searchController;
  TextEditingController messageController;
  RecorderController recordController;
  PlayerController playerController;
  PlayerStatus playerStatus;
  List<ChatMessage> messages;
  List<ChatListItem> chatList;
  File? uploadFile;

  Character? character;
  CharacterDetail? characterDetail;

  // ignore: unused_element
  ChatState _updateWith({
    bool? hasMessage,
    bool? isTyping,
    bool? isFetchingHistory,
    bool? isFetchingChatList,
    bool? isRecording,
    bool? isSearching,
    TextEditingController? messageController,
    TextEditingController? searchController,
    RecorderController? recordController,
    PlayerController? playerController,
    PlayerStatus? playerStatus,
    File? uploadFile,
    bool? isAttachmentImage,
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
      searchController: searchController ?? this.searchController,
      isSearching: isSearching ?? this.isSearching,
      uploadFile: uploadFile ?? this.uploadFile,
      isAttachmentImage: isAttachmentImage ?? this.isAttachmentImage,
      character: character ?? this.character,
      characterDetail: characterDetail ?? this.characterDetail,
      messages: messages ?? this.messages,
      chatList: chatList ?? this.chatList,
    );
  }

  ChatState _copyWith(ChatState state) {
    return ChatState(
      hasMessage: state.hasMessage,
      isTyping: state.isTyping,
      isFetchingHistory: state.isFetchingHistory,
      isFetchingChatList: state.isFetchingChatList,
      messageController: state.messageController,
      recordController: state.recordController,
      playerController: state.playerController,
      playerStatus: state.playerStatus,
      isRecording: state.isRecording,
      searchController: state.searchController,
      isSearching: state.isSearching,
      uploadFile: state.uploadFile,
      isAttachmentImage: state.isAttachmentImage,
      character: state.character,
      characterDetail: state.characterDetail,
      messages: state.messages,
      chatList: state.chatList,
    );
  }
}
