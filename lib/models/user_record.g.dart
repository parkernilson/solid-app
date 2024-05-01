// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
