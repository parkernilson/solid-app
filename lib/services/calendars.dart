import 'dart:async';
import 'dart:convert';

import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/models/models.dart';
import 'package:http/http.dart' as http;

class SendShareRequestResponse {
  final bool success;
  SendShareRequestResponse({required this.success});
}

class CalendarService {
  late PocketBase client;

  CalendarService._internal({required this.client});

  factory CalendarService() =>
      CalendarService._internal(client: PocketBaseApp().pb);

  Future<List<CalendarRecord>> getCalendars() async {
    final result = await PocketBaseApp()
        .pb
        .collection('calendars')
        .getFullList(expand: 'share_record');
    return result
        .map((calendarRecord) => CalendarRecord.fromRecordModel(calendarRecord))
        .toList();
  }

  Future<CalendarRecord> getCalendar({required String id}) async {
    final result = await PocketBaseApp()
        .pb
        .collection('calendars')
        .getOne(id, expand: 'share_record');
    return CalendarRecord.fromRecordModel(result);
  }

  Stream<List<CalendarRecord>> getCalendarsStream() async* {
    final streamController = StreamController<List<CalendarRecord>>();
    List<CalendarRecord> list = await getCalendars();
    streamController.add(list);

    client.collection('calendars').subscribe("*", (e) {
      try {
        final calendarRecord = CalendarRecord.fromRecordModel(e.record!);
        switch (e.action) {
          case 'create':
            streamController.add(list..add(calendarRecord));
          case 'update':
            streamController.add(list
              ..removeWhere((element) => element.id == calendarRecord.id)
              ..add(calendarRecord));
          case 'delete':
            streamController.add(
                list..removeWhere((element) => element.id == calendarRecord.id));
        }
      } catch(error) {
        print('Error updating calendar: $error');
      }
    }, expand: 'share_record');

    client.collection('share_records').subscribe("*", (e) async {
      // a share record will never be deleted unless a calendar is deleted
      //  in which case we should let the calendar handler handle it
      if (e.action == 'delete') return;

      try {
        final shareRecord = ShareRecord.fromRecordModel(e.record!);
        final index = list.indexWhere(
            (element) => element.shareRecord.id == shareRecord.id);
        final calendarRecord = list[index];
        list[index] = calendarRecord..shareRecord = shareRecord;
        streamController.add(list);
      } catch(error) {
        print('Error updating calendar share record: $error');
      }
    });

    streamController.onCancel = () {
      client.collection('calendars').unsubscribe("*");
      client.collection('share_records').unsubscribe("*");
    };

    yield* streamController.stream;
  }

  Future<CalendarRecord> createCalendar(
      {required String title,
      required String owner,
      List<String> viewers = const []}) async {
    final shareRecord = await client
        .collection('share_records')
        .create(body: {'viewers': viewers});

    final result = await client.collection('calendars').create(
        body: {'title': title, 'owner': owner, 'share_record': shareRecord.id});

    return CalendarRecord.fromRecordModel(result);
  }

  Future<CalendarRecord> updateCalendar(
      {required String id, required Map<String, dynamic> body}) async {
    final result = await client
        .collection('calendars')
        .update(id, body: body, expand: 'share_record');
    return CalendarRecord.fromJson(result.toJson());
  }

  Future<void> deleteCalendar({required String id}) async {
    await client.collection('calendars').delete(id);
  }

  Future<SendShareRequestResponse> sendShareRequest(
      {required String calendarId, required String shareWithEmail}) async {
    // TODO: use correct url depending on environment
    final shareRequestUrl =
        Uri.http('localhost:3000', 'api/calendars/share/send');
    final pbToken = PocketBaseApp().pb.authStore.token;

    final body = json
        .encode({'calendarId': calendarId, 'shareWithEmail': shareWithEmail});

    final result = await http.post(shareRequestUrl,
        headers: {
          'Authorization': 'Bearer $pbToken',
          'Content-Type': 'application/json'
        },
        body: body);

    return SendShareRequestResponse(success: result.statusCode == 200);
  }

  Future<void> unshareWithUser(
      {required String calendarId, required String userId}) async {
    final calendar = await getCalendar(id: calendarId);
    await client.collection('share_records').update(calendar.shareRecord.id,
        body: {'viewers': calendar.shareRecord.viewers..remove(userId)});
  }
}
