import 'package:flutter/material.dart';
import 'package:round2/Map/MapView.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({Key? key}) : super(key: key);

  @override
  TripHistoryState createState() => TripHistoryState();
}

class Hist {
  String id;
  // ignore: non_constant_identifier_names
  String info;
  Hist({required this.id, required this.info});
}

class TripHistoryState extends State<TripHistory> {
  List<Hist> history = [];

  @override
  void initState() {
    super.initState();
    history
        .add(Hist(id: 'Trip 1', info: '29/10/22 13:34:23 - 29/10/22 14:23:21'));
    history
        .add(Hist(id: 'Trip 2', info: '28/10/22 08:10:43 - 28/10/22 10:32:19'));
    history
        .add(Hist(id: 'Trip 3', info: '26/10/22 19:21:41 - 26/10/22 21:13:16'));
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
                children: history.map<Widget>((doc) {
                  return ExpansionTile(
                    title: Text(doc.id),
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Text(doc.info))
                    ],
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}
