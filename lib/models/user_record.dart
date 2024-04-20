import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'user_record.g.dart';

@JsonSerializable()
class UserRecord extends RecordModel {
  final String email;
  final String? username;
  final String? name;
  final String? avatar;

  UserRecord({
    this.email = '',
    this.username,
    this.name,
    this.avatar,
  }) : super();

  factory UserRecord.fromJson(Map<String, dynamic> json) =>
      _$UserRecordFromJson(json);
  
  factory UserRecord.fromRecordModel(RecordModel record) =>
      UserRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$UserRecordToJson(this);
}
