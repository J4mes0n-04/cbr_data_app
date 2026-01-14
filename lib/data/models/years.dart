import 'package:json_annotation/json_annotation.dart';

part 'years.g.dart';

@JsonSerializable()
class YearsResponse {
  final int minYear;
  final int maxYear;

  YearsResponse({required this.minYear, required this.maxYear});

  factory YearsResponse.fromJson(Map<String, dynamic> json) => _$YearsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$YearsResponseToJson(this);
}
