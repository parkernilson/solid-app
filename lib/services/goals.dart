import 'dart:async';
import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';
import 'package:solid_app/models/models.dart';
import 'package:http/http.dart' as http;

class SendShareRequestResponse {
  final bool success;
  SendShareRequestResponse({required this.success});
}

class GoalService {
  late PocketBase client;

  GoalService._internal({required this.client});

  factory GoalService() =>
      GoalService._internal(client: PocketBaseApp().pb);

  Future<List<GoalRecord>> getGoals() async {
    final result = await PocketBaseApp()
        .pb
        .collection('goals')
        .getFullList(expand: 'share_record');
    return result
        .map((goalRecord) => GoalRecord.fromRecordModel(goalRecord))
        .toList();
  }

  Future<GoalRecord> getGoal({required String id}) async {
    final result = await PocketBaseApp()
        .pb
        .collection('goals')
        .getOne(id, expand: 'share_record');
    return GoalRecord.fromRecordModel(result);
  }

  Stream<List<GoalRecord>> getGoalsStream() async* {
    final streamController = StreamController<List<GoalRecord>>();
    List<GoalRecord> list = await getGoals();
    streamController.add(list);

    client.collection('goals').subscribe("*", (e) {
      try {
        final goalRecord = GoalRecord.fromRecordModel(e.record!);
        switch (e.action) {
          case 'create':
            streamController.add(list..add(goalRecord));
          case 'update':
            streamController.add(list
              ..removeWhere((element) => element.id == goalRecord.id)
              ..add(goalRecord));
          case 'delete':
            streamController.add(
                list..removeWhere((element) => element.id == goalRecord.id));
        }
      } catch(error) {
        print('Error updating goal: $error');
      }
    }, expand: 'share_record');

    client.collection('share_records').subscribe("*", (e) async {
      // a share record will never be deleted unless a goal is deleted
      //  in which case we should let the goal handler handle it
      if (e.action == 'delete') return;

      try {
        final shareRecord = ShareRecord.fromRecordModel(e.record!);
        final index = list.indexWhere(
            (element) => element.shareRecord.id == shareRecord.id);
        final goalRecord = list[index];
        list[index] = goalRecord..shareRecord = shareRecord;
        streamController.add(list);
      } catch(error) {
        print('Error updating goal share record: $error');
      }
    });

    streamController.onCancel = () {
      client.collection('goals').unsubscribe("*");
      client.collection('share_records').unsubscribe("*");
    };

    yield* streamController.stream;
  }

  Future<GoalRecord> createGoal(
      {required String title,
      required String owner,
      List<String> viewers = const []}) async {
    final shareRecord = await client
        .collection('share_records')
        .create(body: {'viewers': viewers});

    final result = await client.collection('goals').create(
        body: {'title': title, 'owner': owner, 'share_record': shareRecord.id});

    return GoalRecord.fromRecordModel(result);
  }

  Future<GoalRecord> updateGoal(
      {required String id, required Map<String, dynamic> body}) async {
    final result = await client
        .collection('goals')
        .update(id, body: body, expand: 'share_record');
    return GoalRecord.fromJson(result.toJson());
  }

  Future<void> deleteGoal({required String id}) async {
    await client.collection('goals').delete(id);
  }

  Future<SendShareRequestResponse> sendShareRequest(
      {required String goalId, required String shareWithEmail}) async {
    // TODO: use correct url depending on environment
    final shareRequestUrl =
        Uri.http('localhost:3000', 'api/goals/share/send');
    final pbToken = PocketBaseApp().pb.authStore.token;

    final body = json
        .encode({'goalId': goalId, 'shareWithEmail': shareWithEmail});

    final result = await http.post(shareRequestUrl,
        headers: {
          'Authorization': 'Bearer $pbToken',
          'Content-Type': 'application/json'
        },
        body: body);

    return SendShareRequestResponse(success: result.statusCode == 200);
  }

  Future<void> unshareWithUser(
      {required String goalId, required String userId}) async {
    final goal = await getGoal(id: goalId);
    await client.collection('share_records').update(goal.shareRecord.id,
        body: {'viewers': goal.shareRecord.viewers..remove(userId)});
  }
}
