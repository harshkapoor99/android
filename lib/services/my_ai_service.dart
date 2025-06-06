import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/my_ai_service.gen.dart';

@riverpod
MyAiService myAiService(Ref ref) {
  final apiClient = ref.read(apiClientProvider);
  return MyAiServiceImpl(apiClient);
}

abstract class MyAiService {
  Future<Response> fetchMyAis({required String creatorId});
  Future<Response> deleteCharacter({required String characterId});
}

class MyAiServiceImpl implements MyAiService {
  final ApiClient _apiClient;
  MyAiServiceImpl(this._apiClient);

  @override
  Future<Response> fetchMyAis({required String creatorId}) async {
    return await _apiClient.post(
      RemoteEndpoint.charactersByUser.url,
      data: {"creator_id": creatorId},
    );
  }

  @override
  Future<Response> deleteCharacter({required String characterId}) async {
    final response = await _apiClient.post(
      RemoteEndpoint.deleteCharacter.url,
      data: {"character_id": characterId},
    );
    return response;
  }
}
