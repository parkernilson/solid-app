import 'package:flutter/material.dart';
import 'package:solid_app/models/user_record.dart';
import 'package:solid_app/services/goals.dart';

class CreateGoalModal extends StatelessWidget {
  final UserRecord user;

  const CreateGoalModal({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('Create Goal'),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await GoalService().createGoal(
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