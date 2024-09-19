import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MaintainceMofdel {
  String ConId;
  String maintain;

  MaintainceMofdel(
    this.ConId,
    this.maintain,
  );

  factory MaintainceMofdel.fromJson(Map<String, dynamic> json) =>
      _$MaintainceMofdelFromJson(json);

  Map<String, dynamic> toJson() => _$MaintainceMofdelToJson(this);
}

MaintainceMofdel _$MaintainceMofdelFromJson(Map<String, dynamic> json) {
  return MaintainceMofdel(
    json['ConId'] as String,
    json['maintain'] as String,
  );
}

Map<String, dynamic> _$MaintainceMofdelToJson(MaintainceMofdel instance) =>
    <String, dynamic>{'ConId': instance.ConId, 'maintain': instance.maintain};
