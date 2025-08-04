import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/chat_service.gen.dart';

@riverpod
ChatSerice chatService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatSericeImpl(apiClient);
}

abstract class ChatSerice {
  Future<Response> initChat({
    required String characterId,
    // required String sessionId,
    required String creatorId,
  });
  Future<Response> chat({
    required String characterId,
    required String message,
    // required String sessionId,
    required String creatorId,
  });
  Future<Response> chatHistory({
    required String characterId,
    required String creatorId,
    required int page,
  });
  Future<Response> chatList({required String creatorId});

  Future<Response> fetchCharacterDetails({required String characterId});

  Future<Response> sendAudioChatMessage({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  });

  Future<Response> voiceCall({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  });

  Future<Response> sendFileChatMessage({
    required File file,
    required String characterId,
    required String creatorId,
    required String fileName,
    String? message,
  });
}

class ChatSericeImpl implements ChatSerice {
  final ApiClient _apiClient;
  ChatSericeImpl(this._apiClient);

  @override
  Future<Response> initChat({
    required String characterId,
    // required String sessionId,
    required String creatorId,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.initiateChatWithCharacter.url,
      data: {
        "character_id": characterId,
        "session_id": '$characterId$creatorId',
        "creator_id": creatorId,
      },
    );
    return response;
  }

  @override
  Future<Response> chat({
    required String characterId,
    required String message,
    // required String sessionId,
    required String creatorId,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.chatWithCharacter.url,
      data: {
        "character_id": characterId,
        "message": message,
        "session_id": '$characterId$creatorId',
        "creator_id": creatorId,
      },
      timeout: const Duration(seconds: 10),
    );
    return response;
  }

  @override
  Future<Response> chatHistory({
    required String characterId,
    required String creatorId,
    required int page,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.chatHistory.url,
      data: {
        "character_id": characterId,
        "session_id": '$characterId$creatorId',
        "page": page,
      },
    );
    return response;
  }

  @override
  Future<Response> chatList({required String creatorId}) async {
    final response = await _apiClient.post(
      RemoteEndpoint.chatList.url,
      data: {"creator_id": creatorId},
    );
    return response;
  }

  @override
  Future<Response> fetchCharacterDetails({required String characterId}) async {
    final response = await _apiClient.post(
      RemoteEndpoint.charactersDetails.url,
      data: {"character_id": characterId},
    );
    return response;
  }

  @override
  Future<Response> sendAudioChatMessage({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  }) async {
    return _apiClient.post(
      RemoteEndpoint.audioMessage.url,
      data: FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(audioFile.path),
        'character_id': characterId,
        'session_id': sessionId,
        'creator_id': creatorId,
      }),
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  Future<Response> voiceCall({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  }) async {
    return _apiClient.post(
      RemoteEndpoint.voiceCall.url,
      data: FormData.fromMap({
        'audio_file': await MultipartFile.fromFile(audioFile.path),
        'character_id': characterId,
        'session_id': sessionId,
        'creator_id': creatorId,
      }),
      timeout: const Duration(seconds: 30),
      responseType: ResponseType.bytes,
    );
  }

  @override
  Future<Response> sendFileChatMessage({
    required File file,
    required String characterId,
    required String creatorId,
    required String fileName,
    String? message,
  }) async {
    return _apiClient.post(
      RemoteEndpoint.fileMessage.url,
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'character_id': characterId,
        'session_id': '$characterId$creatorId',
        'creator_id': creatorId,
        'message': message,
        "file_name": fileName,
      }),
      timeout: const Duration(seconds: 30),
    );
  }
}
