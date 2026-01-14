import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../../core/constants/constants.dart.dart';
import '../../models/publication.dart';
import '../../models/dataset.dart';
import '../../models/measure.dart';
import '../../models/years.dart';
import '../../models/data_response.dart';

class ApiClient {
  final http.Client _client;
  final Duration timeout = Constants.timeout;
  final bool useMockData;

  ApiClient(this._client, {this.useMockData = false});

  Future<List<Publication>> getPublications() async {
    if (useMockData) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      return _getMockPublications();
    }
    final response = await _get('/publications');
    return (response as List).map((e) => Publication.fromJson(e)).toList();
  }

  Future<List<Dataset>> getDatasets(String publicationId) async {
    if (useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockDatasets();
    }
    final response = await _get('/datasets?publicationId=$publicationId');
    return (response as List).map((e) => Dataset.fromJson(e)).toList();
  }

  Future<YearsResponse> getYears(String datasetId) async {
    if (useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockYears();
    }
    final response = await _get('/years?datasetId=$datasetId');
    return YearsResponse.fromJson(response);
  }

  Future<DataResponse> getData(int y1, int y2, String publicationId, String datasetId) async {
    if (useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockData();
    }
    final response = await _get('/data/?y1=$y1&y2=$y2&datasetId=$datasetId&publicationId=$publicationId');
    return DataResponse.fromJson(response);
  }

  Future<DataResponse> getDataEx(int y1, int y2, String publicationId, String datasetId) async {
    if (useMockData) {
      await Future.delayed(const Duration(seconds: 1));
      return _getMockDataEx();
    }
    final response = await _get('/dataEx/?y1=$y1&y2=$y2&publicationId=$publicationId&i_ids[]=$datasetId');
    return DataResponse.fromJson(response);
  }

  Future<dynamic> _get(String endpoint) async {
    final url = Uri.parse('${Constants.baseUrl}$endpoint');
    
    try {
      final response = await _client.get(url, headers: {'Accept-Encoding': 'gzip'}).timeout(timeout);
      
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

  // Mock data methods
  List<Publication> _getMockPublications() {
    return [
      Publication(id: 1, categoryName: 'Курсы валют'),
      Publication(id: 2, categoryName: 'Ставки'),
      Publication(id: 3, categoryName: 'Показатели'),
    ];
  }

  List<Dataset> _getMockDatasets() {
    return [
      Dataset(id: 1, name: 'Дневные курсы', type: 1),
      Dataset(id: 2, name: 'Месячные курсы', type: 2),
    ];
  }

  YearsResponse _getMockYears() {
    return YearsResponse(minYear: 2020, maxYear: 2025);
  }

  DataResponse _getMockData() {
    return DataResponse(rawData: [
      RawData(dt: '2024-01-01', obsVal: 90.5),
      RawData(dt: '2024-01-02', obsVal: 95.2),
      RawData(dt: '2024-01-03', obsVal: 92.8),
    ]);
  }

  DataResponse _getMockDataEx() {
    return DataResponse(rawData: [
      RawData(dt: '2024-01-01', obsVal: 85.0),
      RawData(dt: '2024-01-02', obsVal: 87.3),
    ]);
  }
}

class ApiError extends Error {
  final String message;
  final int? statusCode;

  ApiError(this.message, {this.statusCode});

  @override
  String toString() => 'ApiError: $message (status: $statusCode)';
}
