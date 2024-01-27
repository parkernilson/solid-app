import 'package:flutter/material.dart';
import 'package:solid_app/services/calendars.dart';
import 'package:solid_app/services/models/models.dart';

class CreateCalendarModal extends StatelessWidget {
  final UserRecord user;

  const CreateCalendarModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('Create Calendar'),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await CalendarService.instance.createCalendar(
                    title: titleController.text, owner: user.id);
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