import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'goal_record.g.dart';

@JsonSerializable()
class GoalRecord extends RecordModel {
  final String title;
  final String owner;

  GoalRecord({
    this.title = '',
    this.owner = '',
  });

  factory GoalRecord.fromJson(Map<String, dynamic> json) =>
      _$GoalRecordFromJson(json);

  factory GoalRecord.fromRecordModel(RecordModel record) =>
      GoalRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$GoalRecordToJson(this);
}
