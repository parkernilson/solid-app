import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'entry_record.g.dart';

@JsonSerializable()
class EntryRecord extends RecordModel {
  final String title;
  @JsonKey(name: 'text_content')
  final String textContent;
  final bool checked;
  @JsonKey(name: 'date')
  final String dateString;
  final String goal;

  EntryRecord({
    this.title = '',
    this.textContent = '',
    this.checked = false,
    this.dateString = '',
    this.goal = '',
  });

  factory EntryRecord.fromJson(Map<String, dynamic> json) =>
      _$EntryRecordFromJson(json);

  factory EntryRecord.fromRecordModel(RecordModel record) =>
      EntryRecord.fromJson(record.toJson());

  @override
  Map<String, dynamic> toJson() => _$EntryRecordToJson(this);

  String get dateFormatted => DateTime.tryParse(dateString) is DateTime
      ? DateFormat(DateFormat.ABBR_MONTH_WEEKDAY_DAY)
          .format(DateTime.tryParse(dateString)!)
      : 'Invalid date';

  DateTime get date => DateTime.tryParse(dateString) ?? createdDate;
  DateTime get createdDate => DateTime.tryParse(created) ?? DateTime.now();
}
