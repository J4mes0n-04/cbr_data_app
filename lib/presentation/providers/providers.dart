import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:cbr_data_app/data/datasources/remote/api_client.dart';
import 'package:cbr_data_app/data/repositories/data_repository.dart';

// Провайдер для HTTP клиента
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Провайдер для ApiClient
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ref.watch(httpClientProvider);
  return ApiClient(client, useMockData: false); // Используем реальный API
});

// Провайдер для DataRepository
final dataRepositoryProvider = Provider<DataRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DataRepository(apiClient: apiClient);
});