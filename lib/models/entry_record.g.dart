// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntryRecord _$EntryRecordFromJson(Map<String, dynamic> json) => EntryRecord(
      title: json['title'] as String? ?? '',
      textContent: json['text_content'] as String? ?? '',
      goal: json['goal'] as String? ?? '',
    )
      ..id = json['id'] as String
      ..created = json['created'] as String
      ..updated = json['updated'] as String
      ..collectionId = json['collectionId'] as String
      ..collectionName = json['collectionName'] as String;

Map<String, dynamic> _$EntryRecordToJson(EntryRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'updated': instance.updated,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'title': instance.title,
      'text_content': instance.textContent,
      'goal': instance.goal,
    };
