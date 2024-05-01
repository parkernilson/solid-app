import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solid_app/components/goals/goal_screen.dart';
import 'package:solid_app/components/goals/share_requests_screen.dart';
import 'package:solid_app/components/login/profile_screen.dart';
import 'package:solid_app/models/entry_record.dart';
import 'package:solid_app/models/goal_record.dart';
import 'package:solid_app/models/shared_goal_record.dart';
import 'package:solid_app/models/user_record.dart';
import 'package:solid_app/shared/dates.dart';

class Dashboard extends StatefulWidget {
  final UserRecord user;
  final List<GoalPreview> goalPreviews;
  final List<GoalPreview<SharedGoalRecord>> sharedGoalPreviews;

  final List<GoalPreview> acceptedSharedGoalPreviews;
  final List<GoalPreview> unacceptedSharedGoalPreviews;

  Dashboard({
    super.key,
    required this.user,
    required this.goalPreviews,
    required this.sharedGoalPreviews,
  })  : acceptedSharedGoalPreviews = sharedGoalPreviews
            .where((goalPreview) => goalPreview.goal.shareAccepted)
            .toList(),
        unacceptedSharedGoalPreviews = sharedGoalPreviews
            .where((goalPreview) => goalPreview.goal.shareAccepted == false)
            .toList();

  @override
  State<Dashboard> createState() => _DashboardState();
}

enum FilterMode { all, mine, shared }

class _DashboardState extends State<Dashboard> {
  FilterMode filterMode = FilterMode.all;

  @override
  Widget build(BuildContext context) {
    List<GoalPreview> filteredGoalPreviews = ((filterMode == FilterMode.all ||
                    filterMode == FilterMode.mine
                ? widget.goalPreviews
                : List<GoalPreview>.empty())
            .toSet()
          ..addAll(
              (filterMode == FilterMode.all || filterMode == FilterMode.shared
                  ? widget.sharedGoalPreviews
                  : List<GoalPreview>.empty())))
        .toList()
      ..sort((previewA, previewB) =>
          previewB.previewData.streak - previewA.previewData.streak);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/solid_logo.png',
          height: 32,
        ),
        centerTitle: false,
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.solidCircleUser,
                  color: Theme.of(context).colorScheme.onPrimary),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ProfileScreen(),
                  ),
                );
              })
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Container(
              height: 128,
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              color: Theme.of(context).colorScheme.primary,
              child: Text("Tasks",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary))),
          Container(
            padding: const EdgeInsets.all(12),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Goals'),
                widget.unacceptedSharedGoalPreviews.isNotEmpty
                    ? ShareRequestsButton(
                        count: widget.unacceptedSharedGoalPreviews.length)
                    : const SizedBox()
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                FilterButton(
                    onPressed: () =>
                        setState(() => filterMode = FilterMode.all),
                    name: 'All',
                    selected: filterMode == FilterMode.all),
                FilterButton(
                    onPressed: () =>
                        setState(() => filterMode = FilterMode.mine),
                    name: 'Mine',
                    selected: filterMode == FilterMode.mine),
                FilterButton(
                    onPressed: () =>
                        setState(() => filterMode = FilterMode.shared),
                    name: 'Shared',
                    selected: filterMode == FilterMode.shared),
              ])
            ]),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: filteredGoalPreviews.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final goalPreview = filteredGoalPreviews[index];
                return GoalListItem(goalPreview: goalPreview);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton(
      {super.key,
      required this.onPressed,
      required this.name,
      required this.selected});

  final Function() onPressed;
  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.onSecondaryContainer),
            backgroundColor: MaterialStatePropertyAll<Color?>(selected
                ? Theme.of(context).colorScheme.secondaryContainer
                : null),
            shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))))),
        child: Text(name));
  }
}

class GoalListItem extends StatelessWidget {
  const GoalListItem(
      {super.key, required this.goalPreview, this.editable = true});

  final GoalPreview goalPreview;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                blurRadius: 6,
                offset: Offset(0, 3),
                color: Color.fromARGB(40, 0, 0, 0))
          ],
          color: Colors.white),
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    GoalScreen(goalId: goalPreview.goal.id),
              ),
            );
          },
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(goalPreview.goal.title,
                  style: const TextStyle(fontSize: 20)),
              Row(children: [
                goalPreview.previewData.streak > 0
                    ? Container(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 4, left: 8, right: 8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(100)),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 3),
                              child: FaIcon(FontAwesomeIcons.fireFlameCurved,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onTertiary),
                            ),
                            Text("${goalPreview.previewData.streak}",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiary))
                          ],
                        ))
                    : const SizedBox.shrink(),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                  onPressed: () {
                    // TODO: open options
                  },
                )
              ])
            ]),
            Row(
                children: List.generate(7, (i) {
              final today = DateTime.now();
              final date = today.subtract(Duration(days: i));
              EntryRecord? correspondingEntry;
              try {
                correspondingEntry = goalPreview.previewData.entries.firstWhere((entry) => sameDay(entry.date, date));
              // ignore: empty_catches
              } on StateError {}
              final color = correspondingEntry != null && correspondingEntry.checked ? Colors.green[50] : Colors.grey[300];
              return Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.only(right: 4),
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: Text(getWeekdayName(date.weekday)));
            }, growable: false)
                    .reversed
                    .toList())
          ])),
    );
  }
}

class ShareRequestsButton extends StatelessWidget {
  const ShareRequestsButton({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShareRequestsScreen()));
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
              padding: const EdgeInsets.only(right: 8),
              child: Text('$count share requests')),
          Text('View',
              style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ]),
      ),
    );
  }
}
