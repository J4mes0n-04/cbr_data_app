// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'years.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearsResponse _$YearsResponseFromJson(Map<String, dynamic> json) =>
    YearsResponse(
      minYear: (json['minYear'] as num).toInt(),
      maxYear: (json['maxYear'] as num).toInt(),
    );

Map<String, dynamic> _$YearsResponseToJson(YearsResponse instance) =>
    <String, dynamic>{
      'minYear': instance.minYear,
      'maxYear': instance.maxYear,
    };
