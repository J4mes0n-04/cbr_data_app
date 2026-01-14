import 'package:json_annotation/json_annotation.dart';

part 'data_response.g.dart';

@JsonSerializable()
class RawData {
  final String dt;
  @JsonKey(name: 'obs_val')
  final double obsVal;

  RawData({required this.dt, required this.obsVal});

  factory RawData.fromJson(Map<String, dynamic> json) => _$RawDataFromJson(json);
  Map<String, dynamic> toJson() => _$RawDataToJson(this);
}

@JsonSerializable()
class DataResponse {
  @JsonKey(name: 'RawData')
  final List<RawData> rawData;

  DataResponse({required this.rawData});

  factory DataResponse.fromJson(Map<String, dynamic> json) => _$DataResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DataResponseToJson(this);
}
