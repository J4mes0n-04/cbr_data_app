import 'package:json_annotation/json_annotation.dart';

part 'measure_dto.g.dart';

@JsonSerializable()
class MeasureDto {
  final String id;
  final String name;

  MeasureDto({required this.id, required this.name});

  factory MeasureDto.fromJson(Map<String, dynamic> json) =>
      _$MeasureDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MeasureDtoToJson(this);
}
