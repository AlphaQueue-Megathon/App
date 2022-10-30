import 'package:flutter/material.dart';
import 'package:round2/Map/MapView.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  LeaderboardState createState() => LeaderboardState();
}

class RankItem {
  String rank;
  // ignore: non_constant_identifier_names
  String Name;
  RankItem({required this.rank, required this.Name});
}

class LeaderboardState extends State<Leaderboard> {
  List<RankItem> leaderboard = [];

  @override
  void initState() {
    super.initState();
    leaderboard.add(RankItem(rank: '🥇 1', Name: 'AlphaQRomeo - 12932'));
    leaderboard.add(RankItem(rank: '🥈 2', Name: 'Lite - 2332'));
    leaderboard.add(RankItem(rank: '🥉 3', Name: 'does nt matter yaar - 92'));
    leaderboard.add(RankItem(rank: ' # 4', Name: 'rainboy - 10'));
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
                children: leaderboard.map<Widget>((doc) {
                  return ExpansionTile(
                    title: Text("${doc.rank} - ${doc.Name}"),
                    children: [
                      const Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Text("xd"))
                    ],
                  );
                }).toList()),
          ),
        ),
      ],
    );
  }
}
