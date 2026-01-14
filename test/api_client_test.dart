import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cbr_data_app/data/datasources/remote/api_client.dart';

void main() {
  late ApiClient apiClient;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient((request) async {
      if (request.url.path == '/publications') {
        return http.Response('[]', 200);
      } else if (request.url.path == '/datasets') {
        return http.Response('[]', 200);
      } else if (request.url.path == '/measures') {
        return http.Response('{"measure": []}', 200);
      } else if (request.url.path == '/years') {
        return http.Response('{"min_year": 2020, "max_year": 2023}', 200);
      } else if (request.url.path == '/data') {
        return http.Response('{"RawData": []}', 200);
      }
      return http.Response('Not Found', 404);
    });
    apiClient = ApiClient(mockClient);
  });

  test('getPublications returns List<Publication>', () async {
    final result = await apiClient.getPublications();
    expect(result, isA<List<Publication>>());
  });

  test('getDatasets returns List<Dataset>', () async {
    final result = await apiClient.getDatasets('id');
    expect(result, isA<List<Dataset>>());
  });

  test('getMeasures returns MeasuresResponse', () async {
    final result = await apiClient.getMeasures('id');
    expect(result, isA<MeasuresResponse>());
  });

  test('getYears returns YearsResponse', () async {
    final result = await apiClient.getYears('id', 'mid');
    expect(result, isA<YearsResponse>());
  });

  test('getData returns DataResponse', () async {
    final result = await apiClient.getData(2020, 2023, 'pid', 'did', 'mid');
    expect(result, isA<DataResponse>());
  });

  test('handles 404 error', () async {
    expect(() => apiClient.getPublications(), throwsException);  // Для mock с 404
  });
}
