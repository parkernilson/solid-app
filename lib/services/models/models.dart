import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'models.g.dart';

@JsonSerializable()
class CalendarRecord extends RecordModel {
  final String title;
  final String owner;
  final List<String> viewers;

  CalendarRecord({
    this.title = '',
    this.owner = '',
    this.viewers = const [],
  }) : super();

  factory CalendarRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarRecordFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CalendarRecordToJson(this);
}

@JsonSerializable()
class EntryRecord extends RecordModel {
  // final String title;
  // final DateTime date;
  @JsonKey(name: 'text_content')
  final String textContent;
  final String calendar;

  // EntryRecord({
  //   this.title = '',
  //   DateTime? date,
  //   this.textContent = '',
  // }) : date = date ?? DateTime.now(), super();
  EntryRecord({
    // this.title = '',
    this.textContent = '',
    this.calendar = '',
  }) : super();

  factory EntryRecord.fromJson(Map<String, dynamic> json) =>
      _$EntryRecordFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$EntryRecordToJson(this);

  String get dateFormatted => DateTime.tryParse(created) is DateTime ? DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
      .format(DateTime.tryParse(created)!) : 'Invalid date';
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
