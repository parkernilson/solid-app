import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/models/models.dart';

class EntryService {
  late PocketBase client;

  EntryService({ required this.client });

  static EntryService instance = EntryService(client: PocketBaseApp().pb);

  Future<List<EntryRecord>> getEntries({ required String calendarId }) async {
    final entries = await client.collection('entries').getFullList(filter: "calendar = '$calendarId'");
    return entries.map((e) => EntryRecord.fromJson(e.toJson())).toList();
  }

  Stream<List<EntryRecord>> getEntriesStream({ required String calendarId }) async* {
    final streamController = StreamController<List<EntryRecord>>();
    List<EntryRecord> list = await getEntries(calendarId: calendarId);
    yield list;

    client.collection('entries').subscribe(
      "*", (e) {
        final entryRecord = EntryRecord.fromJson(e.record!.toJson());
        if (entryRecord.calendar != calendarId) return;

        switch(e.action) {
          case 'create':
            streamController.add(list..add(entryRecord));
          case 'update':
            streamController.add(list..removeWhere((element) => element.id == entryRecord.id)..add(entryRecord));
          case 'delete':
            streamController.add(list..removeWhere((element) => element.id == entryRecord.id));
        }
      }
    );

    streamController.onCancel = () {
      client.collection('entries').unsubscribe("*");
    };

    yield* streamController.stream;
  }

  Future<EntryRecord> createEntry({ required String textContent, required String calendar }) async {
    final result = await client.collection('entries').create(body: {
      'text_content': textContent,
      'calendar': calendar
    });
    return EntryRecord.fromJson(result.toJson());
  }

  Future<void> deleteEntry({ required String id }) async {
    await client.collection('entries').delete(id);
  }
}