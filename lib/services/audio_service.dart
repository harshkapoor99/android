import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/audio_service.gen.dart';

@riverpod
AudioService audioService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AudioServiceImpl(apiClient);
}

abstract class AudioService {
  Future<Response> generateAudio({
    required String text,
    required String vocalId,
    required String languageId,
  });
  Future<Response> sendAudioChatMessage({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  });
}

class AudioServiceImpl implements AudioService {
  final ApiClient _apiClient;
  AudioServiceImpl(this._apiClient);

  @override
  Future<Response> generateAudio({
    required String text,
    required String vocalId,
    required String languageId,
  }) async {
    final response = await _apiClient.post(
      RemoteEndpoint.generateAudio.url,
      data: {"text": text, "vocal_id": vocalId, "language_id": languageId},
    );
    return response;
  }

  @override
  Future<Response> sendAudioChatMessage({
    required File audioFile,
    required String characterId,
    required String sessionId,
    required String creatorId,
  }) {
    // TODO: implement sendAudioChatMessage
    throw UnimplementedError();
  }
}
