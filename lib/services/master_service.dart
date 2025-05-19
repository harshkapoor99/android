import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/master_service.gen.dart';

@riverpod
MasterService masterService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MasterServiceImpl(apiClient);
}

abstract class MasterService {
  Future<Response> fetchLanguages();
  Future<Response> fetchBehavious();
  Future<Response> fetchPersionalities();
  Future<Response> fetchRelationships();
  Future<Response> fetchVoices();
  Future<Response> fetchCountries();
  Future<Response> fetchCities();
  Future<Response> fetchCharacterTypes();

  // By ID
  Future<Response> fetchBehaviousByPersonality(String id);
  Future<Response> fetchPersionalitiesByRelationship(String id);
  Future<Response> fetchRelationshipsByCharactertype(String id);

  // Admin Characters
  Future<Response> fetchMasterCharacters();
}

class MasterServiceImpl implements MasterService {
  final ApiClient _apiClient;
  MasterServiceImpl(this._apiClient);

  @override
  Future<Response> fetchBehavious() async {
    final response = await _apiClient.get(RemoteEndpoint.fetchBehavious.url);
    return response;
  }

  @override
  Future<Response> fetchCharacterTypes() async {
    final response = await _apiClient.get(
      RemoteEndpoint.fetchCharacterTypes.url,
    );
    return response;
  }

  @override
  Future<Response> fetchCities() async {
    final response = await _apiClient.get(RemoteEndpoint.fetchCities.url);
    return response;
  }

  @override
  Future<Response> fetchCountries() async {
    final response = await _apiClient.get(RemoteEndpoint.fetchCountries.url);
    return response;
  }

  @override
  Future<Response> fetchLanguages() async {
    final response = await _apiClient.get(RemoteEndpoint.fetchLanguages.url);
    return response;
  }

  @override
  Future<Response> fetchPersionalities() async {
    final response = await _apiClient.get(
      RemoteEndpoint.fetchPersionalities.url,
    );
    return response;
  }

  @override
  Future<Response> fetchRelationships() async {
    final response = await _apiClient.get(
      RemoteEndpoint.fetchRelationships.url,
    );
    return response;
  }

  @override
  Future<Response> fetchVoices() async {
    final response = await _apiClient.get(RemoteEndpoint.fetchVoices.url);
    return response;
  }

  @override
  Future<Response> fetchBehaviousByPersonality(String id) async {
    final response = await _apiClient.post(
      RemoteEndpoint.fetchBehaviousByPersonality.url,
      data: {"personality_id": id},
    );
    return response;
  }

  @override
  Future<Response> fetchPersionalitiesByRelationship(String id) async {
    final response = await _apiClient.post(
      RemoteEndpoint.fetchPersionalitiesByRelationship.url,
      data: {"relationship_id": id},
    );
    return response;
  }

  @override
  Future<Response> fetchRelationshipsByCharactertype(String id) async {
    final response = await _apiClient.post(
      RemoteEndpoint.fetchRelationshipsByCharactertype.url,
      data: {"charactertype_id": id},
    );
    return response;
  }

  @override
  Future<Response> fetchMasterCharacters() async {
    final response = await _apiClient.get(
      RemoteEndpoint.fetchMasterCharacters.url,
    );
    return response;
  }
}
