// character_type_service.dart
import 'package:dio/dio.dart';

// Dio instance
final Dio _dio = Dio();

// Replace with your actual backend base URL
const String _baseUrl = 'https://api.guftagu.net';
const String _selectCharacterTypeEndpoint = '/api/userservice/user/selectcharactertype/';

// Replace with real auth logic in production
const Map<String, String> defaultHeaders = {
  'Content-Type': 'application/json',
};

const Map<String, String> authHeader = {
  'Authorization': 'Bearer token',
};

// Function to call the character type selection API
Future<Response> selectCharacterType({
  required String userId,
  required List<String> characterTypeIds,
  Map<String, String>? customHeaders,
}) async {
  final Map<String, dynamic> requestData = {
    'user_id': userId,
    'charactertype_id': characterTypeIds,
  };

  final Map<String, String> headersToSend = {
    ...defaultHeaders,
    ...authHeader,
    if (customHeaders != null) ...customHeaders,
  };

  try {
    final response = await _dio.post(
      '$_baseUrl$_selectCharacterTypeEndpoint',
      data: requestData,
      options: Options(headers: headersToSend),
    );
    return response;
  } catch (e) {
    rethrow; // Handle with try-catch where called
  }
}
