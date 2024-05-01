import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/models/goal_record.dart';

part 'shared_goal_record.g.dart';

@JsonSerializable()
class SharedGoalRecord extends GoalRecord {
  final String viewer;
  @JsonKey(name: 'share_accepted')
  bool shareAccepted;

  SharedGoalRecord({
    this.viewer = '',
    this.shareAccepted = false,
    super.title = '',
    super.owner = '',
  });

  factory SharedGoalRecord.fromJson(Map<String, dynamic> json) =>
      _$SharedGoalRecordFromJson(json);
    
  factory SharedGoalRecord.fromRecordModel(RecordModel record) =>
      SharedGoalRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$SharedGoalRecordToJson(this);
}
