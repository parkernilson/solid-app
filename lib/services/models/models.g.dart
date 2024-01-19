// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarRecord _$CalendarRecordFromJson(Map<String, dynamic> json) =>
    CalendarRecord(
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      viewers: (json['viewers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    )
      ..id = json['id'] as String
      ..created = json['created'] as String
      ..updated = json['updated'] as String
      ..collectionId = json['collectionId'] as String
      ..collectionName = json['collectionName'] as String;

Map<String, dynamic> _$CalendarRecordToJson(CalendarRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'updated': instance.updated,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'title': instance.title,
      'owner': instance.owner,
      'viewers': instance.viewers,
    };

EntryRecord _$EntryRecordFromJson(Map<String, dynamic> json) => EntryRecord(
      textContent: json['text_content'] as String? ?? '',
      calendar: json['calendar'] as String? ?? '',
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
      'text_content': instance.textContent,
      'calendar': instance.calendar,
    };

UserRecord _$UserRecordFromJson(Map<String, dynamic> json) => UserRecord(
      email: json['email'] as String? ?? '',
      username: json['username'] as String?,
      name: json['name'] as String?,
      avatar: json['avatar'] as String?,
    )
      ..id = json['id'] as String
      ..created = json['created'] as String
      ..updated = json['updated'] as String
      ..collectionId = json['collectionId'] as String
      ..collectionName = json['collectionName'] as String;

Map<String, dynamic> _$UserRecordToJson(UserRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'updated': instance.updated,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'email': instance.email,
      'username': instance.username,
      'name': instance.name,
      'avatar': instance.avatar,
    };
