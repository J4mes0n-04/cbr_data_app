// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dataset _$DatasetFromJson(Map<String, dynamic> json) => Dataset(
      id: json['id'] as String,
      name: json['name'] as String,
      type: (json['type'] as num).toInt(),
    );

Map<String, dynamic> _$DatasetToJson(Dataset instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

DatasetsResponse _$DatasetsResponseFromJson(Map<String, dynamic> json) =>
    DatasetsResponse(
      datasets: (json['datasets'] as List<dynamic>)
          .map((e) => Dataset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DatasetsResponseToJson(DatasetsResponse instance) =>
    <String, dynamic>{
      'datasets': instance.datasets,
    };
