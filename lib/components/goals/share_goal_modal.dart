import 'package:flutter/material.dart';
import 'package:solid_app/services/goals.dart';
import 'package:solid_app/models/models.dart';

class ShareGoalModal extends StatelessWidget {
  final UserRecord user;
  final GoalRecord goal;

  const ShareGoalModal({super.key, required this.user, required this.goal});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const Text('Share Goal'),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Share with email',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await GoalService().shareGoal(
                  email: emailController.text,
                  goalId: goal.id
                );
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