import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/models/entry_record.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';

class EntryService {
  late PocketBase client;
  StreamController<List<EntryRecord>> _entriesStreamController = StreamController<List<EntryRecord>>();
  String _goalId = '';
  List<EntryRecord> _entries = [];

  EntryService._internal({ required this.client });

  static final EntryService _singleton = EntryService._internal(client: PocketBaseApp().pb);

  factory EntryService() => _singleton;

  Future<List<EntryRecord>> getEntries({ required String goalId }) async {
    final entries = await client.collection('entries').getFullList(filter: "goal = '$goalId'");
    return entries.map((e) => EntryRecord.fromRecordModel(e)).toList();
  }

  Stream<List<EntryRecord>> getEntriesStream({ required String goalId }) async* {
    _entriesStreamController = StreamController<List<EntryRecord>>();
    _goalId = goalId;
    _entries = await getEntries(goalId: _goalId);
    _entriesStreamController.add(_entries);
    yield* _entriesStreamController.stream;
  }

  Future<EntryRecord> createEntry({ required String textContent, required String goal }) async {
    final result = await client.collection('entries').create(body: {
      'text_content': textContent,
      'goal': goal
    });
    final newEntryRecord = EntryRecord.fromJson(result.toJson());
    _entriesStreamController.add(_entries..add(newEntryRecord));
   return newEntryRecord;
  }

  Future<void> deleteEntry({ required String id }) async {
    await client.collection('entries').delete(id);
    _entries.removeWhere((element) => element.id == id);
    _entriesStreamController.add(_entries);
  }
}