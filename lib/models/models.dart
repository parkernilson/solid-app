import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'models.g.dart';

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

@JsonSerializable()
class SharedGoalRecord extends GoalRecord {
  final String viewer;
  @JsonKey(name: 'share_accepted')
  final bool shareAccepted;

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

@JsonSerializable()
class EntryRecord extends RecordModel {
  // final String title;
  // final DateTime date;
  @JsonKey(name: 'text_content')
  final String textContent;
  final String goal;

  // EntryRecord({
  //   this.title = '',
  //   DateTime? date,
  //   this.textContent = '',
  // }) : date = date ?? DateTime.now(), super();
  EntryRecord({
    // this.title = '',
    this.textContent = '',
    this.goal = '',
  }) : super();

  factory EntryRecord.fromJson(Map<String, dynamic> json) =>
      _$EntryRecordFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$EntryRecordToJson(this);

  String get dateFormatted => DateTime.tryParse(created) is DateTime
      ? DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.tryParse(created)!)
      : 'Invalid date';
}

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
  @override
  Map<String, dynamic> toJson() => _$UserRecordToJson(this);
}
