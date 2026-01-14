import 'package:json_annotation/json_annotation.dart';

part 'years_dto.g.dart';

@JsonSerializable()
class YearsDto {
  final int minYear;
  final int maxYear;

  YearsDto({required this.minYear, required this.maxYear});

  factory YearsDto.fromJson(Map<String, dynamic> json) =>
      _$YearsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$YearsDtoToJson(this);
}
