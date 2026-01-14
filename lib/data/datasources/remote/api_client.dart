import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_constants.dart';
import '../../models/publication.dart';
import '../../models/dataset.dart';
import '../../models/measure.dart';
import '../../models/years.dart';
import '../../models/data_response.dart';

class ApiClient {
  final http.Client _client;
  final Duration timeout = ApiConstants.timeout;

  ApiClient(this._client);

  Future<List<Publication>> getPublications() async {
    final response = await _get('/publications');
    return (response as List).map((e) => Publication.fromJson(e)).toList();
  }

  Future<List<Dataset>> getDatasets(String publicationId) async {
    final response = await _get('/datasets?publicationId=$publicationId');
    return (response as List).map((e) => Dataset.fromJson(e)).toList();
  }

  Future<MeasuresResponse> getMeasures(String datasetId) async {
    final response = await _get('/measures?datasetId=$datasetId');
    return MeasuresResponse.fromJson(response);
  }

  Future<YearsResponse> getYears(String datasetId, String measureId) async {
    final response = await _get('/years?datasetId=$datasetId&measureId=$measureId');
    return YearsResponse.fromJson(response);
  }

  Future<DataResponse> getData(int y1, int y2, String publicationId, String datasetId, String measureId) async {
    final response = await _get('/data?y1=$y1&y2=$y2&publicationId=$publicationId&datasetId=$datasetId&measureId=$measureId');
    return DataResponse.fromJson(response);
  }

  Future<dynamic> _get(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      final response = await _client.get(url).timeout(timeout);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        throw ApiError('Ресурс не найден', statusCode: response.statusCode);
      } else {
        throw ApiError('Ошибка сервера', statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw ApiError('Превышен таймаут запроса ($timeout)');
    } on SocketException {
      throw ApiError('Нет подключения к сети');
    } catch (e) {
      if (e is ApiError) throw e;
      throw ApiError('Неизвестная ошибка: $e');
    }
  }
}

class ApiError extends Error {
  final String message;
  final int? statusCode;

  ApiError(this.message, {this.statusCode});

  @override
  String toString() => 'ApiError: $message (status: $statusCode)';
}
