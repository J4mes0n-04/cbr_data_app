// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publication _$PublicationFromJson(Map<String, dynamic> json) => Publication(
      id: (json['id'] as num).toInt(),
      categoryName: json['category_name'] as String,
    );

Map<String, dynamic> _$PublicationToJson(Publication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name': instance.categoryName,
    };

PublicationsResponse _$PublicationsResponseFromJson(
        Map<String, dynamic> json) =>
    PublicationsResponse(
      publications: (json['publications'] as List<dynamic>)
          .map((e) => Publication.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PublicationsResponseToJson(
        PublicationsResponse instance) =>
    <String, dynamic>{
      'publications': instance.publications,
    };
