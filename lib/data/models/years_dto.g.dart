// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'years_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearsDto _$YearsDtoFromJson(Map<String, dynamic> json) => YearsDto(
      minYear: (json['minYear'] as num).toInt(),
      maxYear: (json['maxYear'] as num).toInt(),
    );

Map<String, dynamic> _$YearsDtoToJson(YearsDto instance) => <String, dynamic>{
      'minYear': instance.minYear,
      'maxYear': instance.maxYear,
    };
