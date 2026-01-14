import 'package:json_annotation/json_annotation.dart';

part 'dataset_dto.g.dart';

@JsonSerializable()
class DatasetDto {
  final String id;
  final String name;
  final int type;

  DatasetDto({required this.id, required this.name, required this.type});

  factory DatasetDto.fromJson(Map<String, dynamic> json) =>
      _$DatasetDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DatasetDtoToJson(this);
}
