import 'package:flutter/material.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/pocketbase/pocketbase.dart';
import 'package:solid_app/services/auth.dart';
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(calendar: calendar)));
                    },
                    child: ListTile(
                      title: Text(calendar.title),
                      subtitle: Text(calendar.id),
                    )
                  );
                }
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

class CalendarScreen extends StatelessWidget {
  final CalendarRecord calendar;

  const CalendarScreen({super.key, required this.calendar});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EntryService(client: PocketBaseApp().pb).getEntries(calendarId: calendar.id),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          print(snapshot.error?.toString());
          return const Center(child: Text("There was an error"));
        } else if (snapshot.hasData) {
          final entries = snapshot.data as List<EntryRecord>;
          return Scaffold(
            appBar: AppBar(
              title: Text(calendar.title),
            ),
            body: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen(entry: entry)));
                  },
                  child: ListTile(
                    title: Text(entry.id),
                  )
                );
              }
            )
          );
        } else {
          return const Center(child: Text("There was an error"),);
        }
      }
    );
  }
}