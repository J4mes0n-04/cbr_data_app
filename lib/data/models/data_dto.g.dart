// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataDto _$DataDtoFromJson(Map<String, dynamic> json) => DataDto(
      rawData: (json['rawData'] as List<dynamic>)
          .map((e) => RawDataDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataDtoToJson(DataDto instance) => <String, dynamic>{
      'rawData': instance.rawData,
    };

RawDataDto _$RawDataDtoFromJson(Map<String, dynamic> json) => RawDataDto(
      dt: json['dt'] as String,
      obsVal: (json['obsVal'] as num).toDouble(),
    );

Map<String, dynamic> _$RawDataDtoToJson(RawDataDto instance) =>
    <String, dynamic>{
      'dt': instance.dt,
      'obsVal': instance.obsVal,
    };
