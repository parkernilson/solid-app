import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/models/models.dart';

class CalendarService {
  Future<List<CalendarRecord>> getCalendars() async {
    final result = await PocketBaseApp().pb.collection('calendars').getFullList();
    return result.map((e) => CalendarRecord.fromJson(e.toJson())).toList();
  }
}