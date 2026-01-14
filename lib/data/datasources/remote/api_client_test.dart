import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:cbr_data_app/data/datasources/remote/api_client.dart';


// Мокируем http.Client
class MockHttpClient extends Mock implements http.Client {}


void main() {
  late ApiClient apiClient;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    apiClient = ApiClient(mockHttpClient);
  });

  test('Успешный запрос возвращает данные', () async {
    // Подготавливаем ответ
    final mockResponse = http.Response('{"id": "1", "categoryName": "Тест"}', 200);
    
    when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

    // Выполняем запрос
    final result = await apiClient.get('/publications');

    
    // Проверяем результат
    expect(result['id'], '1');
    expect(result['categoryName'], 'Тест');
  });

  test('Ошибка 404 вызывает ApiError', () async {
    final mockResponse = http.Response('Not Found', 404);
    when(mockHttpClient.get(any)).thenAnswer((_) async => mockResponse);

    
    try {
      await apiClient.get('/publications');
      fail('Должно быть выброшено ApiError');
    } on ApiError catch (e) {
      expect(e.statusCode, 404);
      expect(e.message, 'Ресурс не найден');
    }
  });

  test('Таймаут вызывает ApiError', () async {
    when(mockHttpClient.get(any))
        .thenThrow(TimeoutException('Превышен таймаут'));

    try {
      await apiClient.get('/publications');
      fail('Должно быть выброшено ApiError');
    } on ApiError catch (e) {
      expect(e.message, 'Превышен таймаут запроса (0:00:30.000000)');
    }
  });
}
