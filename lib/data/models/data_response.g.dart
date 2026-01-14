// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RawData _$RawDataFromJson(Map<String, dynamic> json) => RawData(
      dt: json['dt'] as String,
      obsVal: (json['obs_val'] as num).toDouble(),
    );

Map<String, dynamic> _$RawDataToJson(RawData instance) => <String, dynamic>{
      'dt': instance.dt,
      'obs_val': instance.obsVal,
    };

DataResponse _$DataResponseFromJson(Map<String, dynamic> json) => DataResponse(
      rawData: (json['RawData'] as List<dynamic>)
          .map((e) => RawData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataResponseToJson(DataResponse instance) =>
    <String, dynamic>{
      'RawData': instance.rawData,
    };
