import 'package:json_annotation/json_annotation.dart';

part 'publication.g.dart';

@JsonSerializable()
class Publication {
  final int id;
  @JsonKey(name: 'category_name')
  final String categoryName;

  Publication({required this.id, required this.categoryName});

  factory Publication.fromJson(Map<String, dynamic> json) => _$PublicationFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationToJson(this);
}

@JsonSerializable()
class PublicationsResponse {
  final List<Publication> publications;

  PublicationsResponse({required this.publications});

  factory PublicationsResponse.fromJson(Map<String, dynamic> json) => _$PublicationsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PublicationsResponseToJson(this);
}
