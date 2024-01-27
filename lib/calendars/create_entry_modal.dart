import 'package:flutter/material.dart';
import 'package:solid_app/services/entries.dart';
import 'package:solid_app/services/models/models.dart';

class CreateEntryModal extends StatelessWidget {
  final UserRecord user;
  final CalendarRecord calendar;

  const CreateEntryModal({super.key, required this.user, required this.calendar});

  @override
  Widget build(BuildContext context) {
    final contentController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('Create Entry'),
          TextFormField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await EntryService.instance.createEntry(
                    textContent: contentController.text, calendar: calendar.id);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
            child: const Text('Create'),
          )
        ],
      ),
    );
  }
}