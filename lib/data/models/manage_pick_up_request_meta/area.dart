import 'package:json_annotation/json_annotation.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';

part 'area.g.dart';

@JsonSerializable()
class Area extends Pair {
  final int? id;
  final String? name;
  final String? cost;
  final int? status;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  Area({this.id, this.name, this.cost, this.status, this.createdAt})
      : super(value: name.toString(), key: '$id');

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}
