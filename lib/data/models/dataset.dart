import 'package:json_annotation/json_annotation.dart';

part 'dataset.g.dart';

@JsonSerializable()
class Dataset {
  final String id;
  final String name;
  final int type;

  Dataset({required this.id, required this.name, required this.type});

  factory Dataset.fromJson(Map<String, dynamic> json) => _$DatasetFromJson(json);
  Map<String, dynamic> toJson() => _$DatasetToJson(this);
}

@JsonSerializable()
class DatasetsResponse {
  final List<Dataset> datasets;

  DatasetsResponse({required this.datasets});

  factory DatasetsResponse.fromJson(Map<String, dynamic> json) => _$DatasetsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DatasetsResponseToJson(this);
}
