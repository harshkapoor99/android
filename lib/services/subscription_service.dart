import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guftagu_mobile/configs/endpoint.dart';
import 'package:guftagu_mobile/services/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../gen/services/subscription_service.gen.dart';

@riverpod
SubscriptionService subscriptionService(Ref ref) {
  final apiClient = ref.read(apiClientProvider);
  return SubscriptionServiceImpl(apiClient);
}

abstract class SubscriptionService {
  Future<Response> fetchSubscriptions();
  Future<Response> fetchWallet(String userId);
}

class SubscriptionServiceImpl implements SubscriptionService {
  final ApiClient _apiClient;
  SubscriptionServiceImpl(this._apiClient);

  @override
  Future<Response> fetchSubscriptions() async {
    return await _apiClient.get(RemoteEndpoint.fetchSubscriptions.url);
  }

  @override
  Future<Response> fetchWallet(String userId) async {
    return await _apiClient.post(
      RemoteEndpoint.fetchWallet.url,
      data: {"user_id": userId},
    );
  }
}
