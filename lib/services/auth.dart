import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/rxdart.dart';
import 'package:solid_app/services/pocketbase/pocketbase.dart';
import 'package:solid_app/models/models.dart';
import 'dart:async';

class AuthService {
  final BehaviorSubject<UserRecord?> userSubject =
      BehaviorSubject<UserRecord?>.seeded(null);

  AuthService._internal() {
    PocketBaseApp().pb.authStore.onChange.listen((event) {
      if (event.model is RecordModel) {
        // convert the event record model to json so that we can re convert it to a user record using our own DTO
        userSubject.add(UserRecord.fromJson((event.model as RecordModel).toJson()));
      } else {
        userSubject.add(null);
      }
    });
  }
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  Future<void> login(String username, String password) async {
    await PocketBaseApp().pb
        .collection('users')
        .authWithPassword(username, password);
  }

  void logout() {
    PocketBaseApp().pb.authStore.clear();
  }
}
