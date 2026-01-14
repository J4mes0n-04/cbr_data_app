import 'package:cbr_data_app/data/datasources/remote/api_client.dart';
import 'package:cbr_data_app/data/models/publication.dart';
import 'package:cbr_data_app/data/models/dataset.dart';
import 'package:cbr_data_app/data/models/measure.dart';
import 'package:cbr_data_app/data/models/years.dart';
import 'package:cbr_data_app/data/models/data_response.dart';

class DataRepository {
  final ApiClient apiClient;

  DataRepository({required this.apiClient});

  Future<List<Publication>> getCategories() async {
    return await apiClient.getPublications();
  }

  Future<List<Dataset>> getDatasets(String publicationId) async {
    return await apiClient.getDatasets(publicationId);
  }

  Future<YearsResponse> getYears(String datasetId) async {
    return await apiClient.getYears(datasetId);
  }

  Future<DataResponse> getData({
    required int y1,
    required int y2,
    required String publicationId,
    required String datasetId,
  }) async {
    return await apiClient.getData(y1, y2, publicationId, datasetId);
  }

  Future<DataResponse> getDataEx({
    required int y1,
    required int y2,
    required String publicationId,
    required String datasetId,
  }) async {
    return await apiClient.getDataEx(y1, y2, publicationId, datasetId);
  }
}