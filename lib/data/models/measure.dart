import 'package:json_annotation/json_annotation.dart';

part 'measure.g.dart';

@JsonSerializable()
class Measure {
  final String id;
  final String name;

  Measure({required this.id, required this.name});

  factory Measure.fromJson(Map<String, dynamic> json) => _$MeasureFromJson(json);
  Map<String, dynamic> toJson() => _$MeasureToJson(this);
}

@JsonSerializable()
class MeasuresResponse {
  final List<Measure> measure;

  MeasuresResponse({required this.measure});

  factory MeasuresResponse.fromJson(Map<String, dynamic> json) => _$MeasuresResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MeasuresResponseToJson(this);
}
