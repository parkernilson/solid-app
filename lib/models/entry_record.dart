import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'entry_record.g.dart';

@JsonSerializable()
class EntryRecord extends RecordModel {
  final String title;
  @JsonKey(name: 'text_content')
  final String textContent;
  final String goal;

  EntryRecord({
    this.title = '',
    this.textContent = '',
    this.goal = '',
  });

  factory EntryRecord.fromJson(Map<String, dynamic> json) =>
      _$EntryRecordFromJson(json);

  factory EntryRecord.fromRecordModel(RecordModel record) =>
      EntryRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$EntryRecordToJson(this);

  String get dateFormatted => DateTime.tryParse(created) is DateTime
      ? DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.tryParse(created)!)
      : 'Invalid date';

  DateTime get createdDate => DateTime.tryParse(created) ?? DateTime.now();
}
