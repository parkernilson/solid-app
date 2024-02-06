import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';
part 'models.g.dart';

@JsonSerializable()
class ShareRecord extends RecordModel {
  final List<String> viewers;

  ShareRecord({this.viewers = const []}) : super();

  factory ShareRecord.fromJson(Map<String, dynamic> json) =>
      _$ShareRecordFromJson(json);
  @override

  factory ShareRecord.fromRecordModel(RecordModel record) =>
      ShareRecord.fromJson(record.toJson());

  Map<String, dynamic> toJson() => _$ShareRecordToJson(this);
}

@JsonSerializable()
class CalendarRecord extends RecordModel {
  final String title;
  final String owner;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ShareRecord shareRecord;

  CalendarRecord({
    this.title = '',
    this.owner = '',
  })  : shareRecord = ShareRecord(),
        super();

  factory CalendarRecord.fromJson(Map<String, dynamic> json) =>
      _$CalendarRecordFromJson(json)
        ..shareRecord = json['expand']?['share_record'] != null
            ? ShareRecord.fromJson(json['expand']?['share_record'])
            : ShareRecord();

  factory CalendarRecord.fromRecordModel(RecordModel record) =>
      CalendarRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$CalendarRecordToJson(this)
    ..['expand'] = {
      'share_record': shareRecord.toJson(),
    };
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
