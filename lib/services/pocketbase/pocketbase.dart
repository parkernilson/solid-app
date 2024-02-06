import 'package:pocketbase/pocketbase.dart';

class PocketBaseApp {
  final String url = 'http://localhost';
  final String port = '8090';
  late final PocketBase _pb;

  PocketBase get pb => _pb;

  PocketBaseApp._internal() {
    _pb = PocketBase('$url:$port');
  }

  static final PocketBaseApp _instance = PocketBaseApp._internal();

  factory PocketBaseApp() {
    return _instance;
  }
}