// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Measure _$MeasureFromJson(Map<String, dynamic> json) => Measure(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$MeasureToJson(Measure instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MeasuresResponse _$MeasuresResponseFromJson(Map<String, dynamic> json) =>
    MeasuresResponse(
      measure: (json['measure'] as List<dynamic>)
          .map((e) => Measure.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeasuresResponseToJson(MeasuresResponse instance) =>
    <String, dynamic>{
      'measure': instance.measure,
    };
