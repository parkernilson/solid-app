import 'dart:async';

import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:solid_app/models/models.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';

class AuthService {
  final userStream = PocketBaseApp()
      .pb
      .authStore
      .onChange
      .map((event) => event.model is RecordModel
          ? UserRecord.fromRecordModel(event.model)
          : null)
      .startWith(null);

  // final otherStream = PocketBaseApp().pb.authStore.onChange.startWith(startValue)
  final user = PocketBaseApp().pb.authStore.model != null
      ? UserRecord.fromRecordModel(PocketBaseApp().pb.authStore.model)
      : null;

  Future<void> login(String username, String password) async {
    await PocketBaseApp()
        .pb
        .collection('users')
        .authWithPassword(username, password);
  }

  void logout() {
    PocketBaseApp().pb.authStore.clear();
  }
}
