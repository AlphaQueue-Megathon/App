import 'package:flutter/material.dart';
import 'package:round2/Map/MapView.dart';

class Incentives extends StatefulWidget {
  const Incentives({Key? key}) : super(key: key);

  @override
  IncentivesState createState() => IncentivesState();
}

class Incentive {
  String name;
  // ignore: non_constant_identifier_names
  String reward;
  Incentive({required this.name, required this.reward});
}

class IncentivesState extends State<Incentives> {
  List<Incentive> incentives = [];

  @override
  void initState() {
    super.initState();
    incentives.add(Incentive(
        name: 'Use cruise control for a minimum of 2 hours',
        reward: 'Reward: 30pts'));
    incentives.add(Incentive(
        name: 'Run autopilot on an empty road for 10 mins',
        reward: 'Reward: 10pts'));
    incentives
        .add(Incentive(name: 'Cover 22km in one day', reward: 'Reward: 40'));
    incentives.add(Incentive(
        name: 'Use intelligent cooling system for 3 hours',
        reward: 'Reward: 20'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: incentives.map<Widget>((doc) {
                  return ExpansionTile(
                    title: Text(doc.name),
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Text(doc.reward))
                    ],
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}
