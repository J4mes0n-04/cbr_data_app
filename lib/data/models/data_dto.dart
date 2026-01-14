import 'package:json_annotation/json_annotation.dart';

part 'data_dto.g.dart';

@JsonSerializable()
class DataDto {
  final List<RawDataDto> rawData;

  DataDto({required this.rawData});

  factory DataDto.fromJson(Map<String, dynamic> json) =>
      _$DataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataDtoToJson(this);
}

@JsonSerializable()
class RawDataDto {
  final String dt;
  final double obsVal;

  RawDataDto({required this.dt, required this.obsVal});

  factory RawDataDto.fromJson(Map<String, dynamic> json) =>
      _$RawDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RawDataDtoToJson(this);
}
