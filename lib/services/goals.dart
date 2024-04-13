import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';

class SendShareRequestResponse {
  final bool success;
  SendShareRequestResponse({required this.success});
}

class GoalService {
  late PocketBase client;

  GoalService._internal({required this.client});

  factory GoalService() => GoalService._internal(client: PocketBaseApp().pb);

  Future<List<GoalRecord>> getGoals({String? userId}) async {
    final result = userId != null
        ? await PocketBaseApp()
            .pb
            .collection('goals')
            .getFullList(filter: "owner.id = '$userId'")
        : await PocketBaseApp().pb.collection('goals').getFullList();
    return result.map(GoalRecord.fromRecordModel).toList();
  }

  Future<List<SharedGoalRecord>> getSharedGoals() async {
    final result =
        await PocketBaseApp().pb.collection('shared_goals').getFullList();
    return result.map(SharedGoalRecord.fromRecordModel).toList();
  }

  Future<GoalRecord> getGoal({required String id}) async {
    final result = await PocketBaseApp().pb.collection('goals').getOne(id);
    return GoalRecord.fromRecordModel(result);
  }

  Future<GoalRecord> createGoal({
    required String title,
    required String owner,
  }) async {
    final result = await client
        .collection('goals')
        .create(body: {'title': title, 'owner': owner});

    return GoalRecord.fromRecordModel(result);
  }

  Future<GoalRecord> updateGoal(
      {required String id, required Map<String, dynamic> body}) async {
    final result = await client.collection('goals').update(id, body: body);
    return GoalRecord.fromRecordModel(result);
  }

  Future<void> deleteGoal({required String id}) async {
    await client.collection('goals').delete(id);
  }
}
