import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ErrorService {
  
  void alertUser(BuildContext context, Object e, {String? message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message ?? e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void reportError(Object e, {String? message}) {
    if (kDebugMode) {
      print("ErrorService.reportError: $message");
      print(e);
    }
  }
}