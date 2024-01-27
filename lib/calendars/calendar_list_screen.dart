import 'package:flutter/material.dart';
import 'package:solid_app/calendars/calendar_screen.dart';
import 'package:solid_app/calendars/create_calendar_modal.dart';
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
            child: StreamBuilder(
              stream: CalendarService.instance.getCalendarsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingScreen();
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("There was an error"),
                  );
                } else if (snapshot.hasData) {
                  final calendars = snapshot.data as List<CalendarRecord>;
                  final myCalendars = calendars
                      .where((element) => element.owner == user.id)
                      .toList();
                  final sharedWithMeCalendars = calendars
                      .where((element) => element.viewers.contains(user.id))
                      .toList();
                  final items = [
                    'My Calendars',
                    ...myCalendars,
                    'Shared with me',
                    ...sharedWithMeCalendars
                  ];
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item is String) {
                        return ListTile(
                          title: Text(item, textScaler: const TextScaler.linear(2)),
                        );
                      } else if (item is CalendarRecord) {
                        return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CalendarScreen(calendar: item, user: user)));
                            },
                            child: ListTile(
                              title: Text(item.title),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  try {
                                    await CalendarService.instance
                                        .deleteCalendar(id: item.id);
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                              ),
                            ));
                      } else {
                        return const Center(
                          child: Text("There was an error"),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: Text("There was an error"),
                  );
                }
              },
            )
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CreateCalendarModal(user: user);
                });
          },
          child: const Icon(Icons.add),
        )
    );
  }
}
