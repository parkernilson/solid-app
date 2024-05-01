import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:solid_app/models/goal_record.dart';
import 'package:solid_app/models/shared_goal_record.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';

class GoalLists {
  final List<GoalRecord> goals;
  final List<SharedGoalRecord> sharedGoals;
  GoalLists({required this.goals, required this.sharedGoals});
}

class GoalPreviews {
  final List<GoalPreview<GoalRecord>> goalsPreviews;
  final List<GoalPreview<SharedGoalRecord>> sharedGoalPreviews;
  GoalPreviews({required this.goalsPreviews, required this.sharedGoalPreviews});
}

class GoalService {
  late PocketBase client;
  StreamController<GoalLists>? _goalsStreamController;
  List<GoalRecord> _goals = [];
  List<SharedGoalRecord> _sharedGoals = [];

  GoalService._internal({required this.client});

  static final GoalService _singleton =
      GoalService._internal(client: PocketBaseApp().pb);

  factory GoalService() => _singleton;

  Future<List<GoalRecord>> getGoals({String? userId}) async {
    final result = userId != null
        ? await PocketBaseApp()
            .pb
            .collection('goals')
            .getFullList(filter: "owner.id = '$userId'")
        : await PocketBaseApp().pb.collection('goals').getFullList();
    return result.map(GoalRecord.fromRecordModel).toList();
  }

  Stream<GoalLists> getGoalListsStream({String? userId}) async* {
    _goals = await getGoals(userId: userId);
    _sharedGoals = await getSharedGoals();
    _goalsStreamController ??= StreamController<GoalLists>.broadcast();
    yield* _goalsStreamController!.stream
        .startWith(GoalLists(goals: _goals, sharedGoals: _sharedGoals));
  }

  Stream<GoalPreviews> getGoalPreviewsStream({String? userId}) async* {
    final goalListsStream = getGoalListsStream(userId: userId);
    yield* goalListsStream.asyncMap((goalLists) async {
      final goalPreviews =
          await Future.wait(goalLists.goals.map(getGoalPreview));
      final sharedGoalPreviews =
          await Future.wait(goalLists.sharedGoals.map(getGoalPreview));
      return GoalPreviews(
          goalsPreviews: goalPreviews, sharedGoalPreviews: sharedGoalPreviews);
    });
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

  Future<GoalPreviewData> getGoalPreviewData({required String goalId}) async {
    final entries = await EntryService().getEntries(goalId: goalId);
    final streak = await getStreak(goalId);
    return GoalPreviewData(entries: entries, streak: streak);
  }

  Future<GoalPreview<T>> getGoalPreview<T extends GoalRecord>(T goal) async {
    final previewData = await getGoalPreviewData(goalId: goal.id);
    return GoalPreview(goal: goal, previewData: previewData);
  }

  Future<GoalRecord> createGoal({
    required String title,
    required String owner,
  }) async {
    final result = await client
        .collection('goals')
        .create(body: {'title': title, 'owner': owner});

    final newGoalRecord = GoalRecord.fromRecordModel(result);
    _goalsStreamController?.add(GoalLists(
        goals: _goals..add(newGoalRecord), sharedGoals: _sharedGoals));
    return newGoalRecord;
  }

  Future<void> deleteGoal({required String id}) async {
    await client.collection('goals').delete(id);
    _goals.removeWhere((element) => element.id == id);
    _goalsStreamController
        ?.add(GoalLists(goals: _goals, sharedGoals: _sharedGoals));
  }

  Future<void> shareGoal(
      {required String goalId, required String email}) async {
    final shareWithUser =
        await client.collection('users').getFirstListItem("email = '$email'");
    await client.collection('share_records').create(body: {
      'goal': goalId,
      'viewer': shareWithUser.id,
      'accepted': false,
    });
  }

  Future<void> acceptShareRequest({required String goalId}) async {
    final shareRecord = await client
        .collection('share_records')
        .getFirstListItem("goal = '$goalId'");
    await client
        .collection('share_records')
        .update(shareRecord.id, body: {'accepted': true});
    _sharedGoals.firstWhere((goal) => goal.id == goalId).shareAccepted = true;
    _goalsStreamController
        ?.add(GoalLists(goals: _goals, sharedGoals: _sharedGoals));
  }

  Future<void> rejectShareRequest({required String goalId}) async {
    final shareRecord = await client
        .collection('share_records')
        .getFirstListItem("goal = '$goalId'");
    await client.collection('share_records').delete(shareRecord.id);
    _sharedGoals.removeWhere((goal) => goal.id == goalId);
    _goalsStreamController
        ?.add(GoalLists(goals: _goals, sharedGoals: _sharedGoals));
  }

  Future<int> getStreak(String goalId) async {
    try {
      final streakRecord = await client
          .collection('streaks')
          .getFirstListItem("goal = '$goalId'");
      final endDateString = streakRecord.getStringValue('end_date');
      final endDate = DateTime.tryParse(endDateString);
      if (endDate != null && endDate.isAfter(DateTime.now().subtract(const Duration(days: 2)))) {
        return streakRecord.getDataValue<int>('days');
      } else {
        return 0;
      }
    } on ClientException catch (_, e) {
      if (_.statusCode == 404) return 0;
      throw e;
    }
  }
}
