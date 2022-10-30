import 'package:flutter/material.dart';
import 'package:round2/Map/MapView.dart';

class Incentives extends StatefulWidget {
  const Incentives({Key? key}) : super(key: key);

  @override
  IncentivesState createState() => IncentivesState();
}

class Incentive {
  Icon icon;
  String type;
  String name;
  // ignore: non_constant_identifier_names
  String reward;
  Incentive(
      {required this.icon,
      required this.type,
      required this.name,
      required this.reward});
}

class IncentivesState extends State<Incentives> {
  List<Incentive> incentives = [];

  @override
  void initState() {
    super.initState();
    incentives.add(Incentive(
        icon: const Icon(Icons.psychology),
        type: 'Intelligent Systems',
        name: 'Use cruise control for a minimum of 15 minutes',
        reward: '30pts'));
    incentives.add(Incentive(
        icon: const Icon(Icons.ac_unit),
        type: 'Ambience',
        name: 'Use intelligent cooling system for 1 hours',
        reward: '20pts'));
    incentives.add(Incentive(
        icon: const Icon(Icons.drive_eta),
        type: 'Intelligent Systems',
        name: 'Run autopilot-assist on a low-traffic road for 10 mins',
        reward: '10pts'));
    incentives.add(Incentive(
        icon: const Icon(Icons.psychology),
        type: 'Parking',
        name: 'Use the intelligent backing-assist',
        reward: '40pts'));
    incentives.add(Incentive(
        icon: const Icon(Icons.camera),
        type: 'Mapping',
        name: 'Explore the road less travelled!',
        reward: '80pts'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Text(
                  "Your Quests!",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: incentives.map<Widget>((doc) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ListTile(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) => ImageDialog());
                              },
                              leading: doc.icon,
                              title: Text("${doc.type} - ${doc.reward}"),
                              subtitle: Text(doc.name)),
                        ],
                      );
                    }).toList()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.infinity,
        height: 450,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/maps/1.jpeg'),
                fit: BoxFit.contain)),
      ),
    );
  }
}
