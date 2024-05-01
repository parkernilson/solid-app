import 'package:flutter/material.dart';
import 'package:solid_app/models/goal_record.dart';
import 'package:solid_app/models/user_record.dart';
import 'package:solid_app/services/entries.dart';

class CreateEntryModal extends StatelessWidget {
  final UserRecord user;
  final GoalRecord goal;

  const CreateEntryModal({super.key, required this.user, required this.goal});

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
                await EntryService().createEntry(
                    textContent: contentController.text, goal: goal.id);
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