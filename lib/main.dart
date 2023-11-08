import 'package:flutter/material.dart';
import 'package:podosphere/league_options.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class LeagueInfo {
  final String name;
  final String logo;
  final int id;
  final String flag;

  LeagueInfo(
      {required this.name,
      required this.logo,
      required this.id,
      required this.flag});
}

final List<LeagueInfo> leagueList = [
  LeagueInfo(
    name: 'Premier League',
    logo: 'https://media-4.api-sports.io/football/leagues/39.png',
    id: 39,
    flag: 'https://media-4.api-sports.io/flags/gb.svg',
  ),
  LeagueInfo(
    name: 'La Liga',
    logo: 'https://media-4.api-sports.io/football/leagues/140.png',
    id: 140,
    flag: 'https://media-4.api-sports.io/flags/es.svg',
  ),
  LeagueInfo(
    name: 'Bundesliga',
    logo: 'https://media-4.api-sports.io/football/leagues/78.png',
    id: 78,
    flag: 'https://media-4.api-sports.io/flags/de.svg',
  ),
  LeagueInfo(
    name: 'Superleague 1',
    logo: 'https://media-4.api-sports.io/football/leagues/197.png',
    id: 197,
    flag: 'https://media-4.api-sports.io/flags/gr.svg',
  ),
  LeagueInfo(
    name: 'Ligue 1',
    logo: 'https://media-4.api-sports.io/football/leagues/61.png',
    id: 61,
    flag: 'https://media-4.api-sports.io/flags/fr.svg',
  ),
  LeagueInfo(
    name: 'Serie A',
    logo: 'https://media-4.api-sports.io/football/leagues/135.png',
    id: 135,
    flag: 'https://media-4.api-sports.io/flags/it.svg',
  ),
  LeagueInfo(
    name: 'Eredivisie',
    logo: 'https://media-4.api-sports.io/football/leagues/88.png',
    id: 88,
    flag: 'https://media-4.api-sports.io/flags/nl.svg',
  ),
  LeagueInfo(
    name: 'Jupiler Pro League',
    logo: 'https://media-4.api-sports.io/football/leagues/144.png',
    id: 144,
    flag: 'https://media-4.api-sports.io/flags/be.svg',
  ),
  // Add more leagues here
];

class _HomePageState extends State<HomePage> {
  final Map<String, int> leagueMap = {
    'Premier League': 39,
    'La Liga': 140,
    'Bundesliga': 78,
    'Superleague 1': 197,
    'Ligue 1': 61,
    'Serie A': 71,
    'Eredivisie': 88,
    'Jupiler Pro League': 144,
    // Add more leagues here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'PODOSPHERE',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                Column(
                  children: [
                    for (final leagueInfo in leagueList)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeagueOptions(
                                  leagueId: leagueInfo.id,
                                  leagueName: leagueInfo.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Image.network(
                                  leagueInfo.logo,
                                  width: 50, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text(
                                  leagueInfo.name,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                SvgPicture.network(
                                  leagueInfo.flag,
                                  width: 50, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Align items to the beginning and end of the row
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
