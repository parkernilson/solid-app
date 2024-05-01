import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/models/entry_record.dart';
import 'package:solid_app/models/goal_record.dart';

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

class GoalPreviewData {
  final List<EntryRecord> entries;
  final int streak;

  GoalPreviewData({
    required this.entries,
    required this.streak,
  });
}

class GoalPreview<T extends GoalRecord> {
  final T goal;
  final GoalPreviewData previewData;

  GoalPreview({
    required this.goal,
    required this.previewData,
  });
}
