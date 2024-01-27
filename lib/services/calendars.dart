import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/models/models.dart';

class CalendarService {
  late PocketBase client;

  CalendarService({ required this.client });

  static CalendarService instance = CalendarService(client: PocketBaseApp().pb);

  Future<List<CalendarRecord>> getCalendars() async {
    final result = await PocketBaseApp().pb.collection('calendars').getFullList();
    return result.map((e) => CalendarRecord.fromJson(e.toJson())).toList();
  }

  Stream<List<CalendarRecord>> getCalendarsStream() async* {
    final streamController = StreamController<List<CalendarRecord>>();
    List<CalendarRecord> list = await getCalendars();
    yield list;

    client.collection('calendars').subscribe(
      "*", (e) {
        final calendarRecord = CalendarRecord.fromJson(e.record!.toJson());
        switch(e.action) {
          case 'create':
            streamController.add(list..add(calendarRecord));
          case 'update':
            streamController.add(list..removeWhere((element) => element.id == calendarRecord.id)..add(calendarRecord));
          case 'delete':
            streamController.add(list..removeWhere((element) => element.id == calendarRecord.id));
        }
      }
    );

    streamController.onCancel = () {
      client.collection('calendars').unsubscribe("*");
    };

    yield* streamController.stream;
  }

  Future<CalendarRecord> createCalendar({ required String title, required String owner, List<String> viewers = const [] }) async {
    final result = await client.collection('calendars').create(body: {
      'title': title,
      'owner': owner,
      'viewers': viewers
    });
    return CalendarRecord.fromJson(result.toJson());
  }

  Future<CalendarRecord> updateCalendar({ required String id, required Map<String, dynamic> body }) async {
    final result = await client.collection('calendars').update(id, body: body);
    return CalendarRecord.fromJson(result.toJson());
  }

  Future<void> deleteCalendar({ required String id }) async {
    await client.collection('calendars').delete(id);
  }

}