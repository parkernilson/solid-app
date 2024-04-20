// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_goal_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SharedGoalRecord _$SharedGoalRecordFromJson(Map<String, dynamic> json) =>
    SharedGoalRecord(
      viewer: json['viewer'] as String? ?? '',
      shareAccepted: json['share_accepted'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
    )
      ..id = json['id'] as String
      ..created = json['created'] as String
      ..updated = json['updated'] as String
      ..collectionId = json['collectionId'] as String
      ..collectionName = json['collectionName'] as String;

Map<String, dynamic> _$SharedGoalRecordToJson(SharedGoalRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created,
      'updated': instance.updated,
      'collectionId': instance.collectionId,
      'collectionName': instance.collectionName,
      'title': instance.title,
      'owner': instance.owner,
      'viewer': instance.viewer,
      'share_accepted': instance.shareAccepted,
    };
