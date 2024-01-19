import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/services/models/models.dart';

class EntryService {
  late PocketBase client;

  EntryService({ required this.client });

  Future<List<EntryRecord>> getEntries({ required String calendarId }) async {
    final entries = await client.collection('entries').getFullList(filter: "calendar = '$calendarId'");
    return entries.map((e) => EntryRecord.fromJson(e.toJson())).toList();
  }
}