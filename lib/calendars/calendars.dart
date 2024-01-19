import 'package:flutter/material.dart';
import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/auth.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:solid_app/services/calendars.dart';
import 'package:solid_app/services/models/models.dart';
import 'package:provider/provider.dart';
import 'package:solid_app/shared/loading.dart';

class CalendarsScreen extends StatelessWidget {
  const CalendarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserRecord>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService().logout();
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          future: CalendarService().getCalendars(),
          builder:(context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return const Center(child: Text("There was an error"),);
            } else if (snapshot.hasData) {
              final calendars = snapshot.data as List<CalendarRecord>;
              return ListView.builder(
                itemCount: calendars.length,
                itemBuilder: (context, index) {
                  final calendar = calendars[index];
                  return ListTile(
                    title: Text(calendar.title),
                    subtitle: Text(calendar.id),
                  );
                },
              );
            } else {
              return const Center(child: Text("There was an error"),);
            }
          },
        )
      )
    );
  }
}