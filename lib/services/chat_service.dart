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
  });
  Future<Response> chatList({required String creatorId});
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
    );
    return response;
  }

  @override
  Future<Response> chatHistory({
    required String characterId,
    required String creatorId,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.chatHistory.url,
      data: {
        "character_id": characterId,
        "session_id": '$characterId$creatorId',
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
}
