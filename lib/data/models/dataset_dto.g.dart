// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DatasetDto _$DatasetDtoFromJson(Map<String, dynamic> json) => DatasetDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$DatasetDtoToJson(DatasetDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };
