import 'package:flutter/material.dart';
import 'package:podosphere/league_options.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Leagues extends StatefulWidget {
  const Leagues({super.key});

  @override
  State<Leagues> createState() => _LeaguesState();
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
    logo: 'logo_39.png',
    id: 39,
    flag: 'flag_gb.svg',
  ),
  LeagueInfo(
    name: 'La Liga',
    logo: 'logo_140.png',
    id: 140,
    flag: 'flag_es.svg',
  ),
  LeagueInfo(
    name: 'Bundesliga',
    logo: 'logo_78.png',
    id: 78,
    flag: 'flag_de.svg',
  ),
  LeagueInfo(
    name: 'Superleague 1',
    logo: 'logo_197.png',
    id: 197,
    flag: 'flag_gr.svg',
  ),
  LeagueInfo(
    name: 'Ligue 1',
    logo: 'logo_61.png',
    id: 61,
    flag: 'flag_fr.svg',
  ),
  LeagueInfo(
    name: 'Serie A',
    logo: 'logo_135.png',
    id: 135,
    flag: 'flag_it.svg',
  ),
  LeagueInfo(
    name: 'Eredivisie',
    logo: 'logo_88.png',
    id: 88,
    flag: 'flag_nl.svg',
  ),
  LeagueInfo(
    name: 'Jupiler Pro',
    logo: 'logo_144.png',
    id: 144,
    flag: 'flag_be.svg',
  ),
  LeagueInfo(
    name: 'UEFA Champions\nLeague',
    logo: 'logo_2.png',
    id: 2,
    flag: 'null',
  ),
  LeagueInfo(
    name: 'UEFA Europa\nLeague',
    logo: 'logo_3.png',
    id: 3,
    flag: 'null',
  ),
  // Add more leagues here
];

class _LeaguesState extends State<Leagues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.green,
      appBar: AppBar(
        title: const Text(
          'LEAGUES',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333333),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.0),
                Column(
                  children: [
                    for (final leagueInfo in leagueList)
                      leagueInfo.flag != 'null'
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeagueOptions(
                                  leagueId: leagueInfo.id,
                                  leagueName: leagueInfo.name,
                                  logo: leagueInfo.logo,
                                  flag: leagueInfo.flag,
                                ),
                              ),
                            );
                          },
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Image.asset(
                                      'assets/images/${leagueInfo.logo}',
                                      width: 50, // Adjust the width as needed
                                      height: 50, // Adjust the height as needed
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Text(
                                    leagueInfo.name,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/${leagueInfo.flag}',
                                    width: 50, // Adjust the width as needed
                                    height: 50, // Adjust the height as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ) : Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LeagueOptions(
                                  leagueId: leagueInfo.id,
                                  leagueName: leagueInfo.name,
                                  logo: leagueInfo.logo,
                                  flag: leagueInfo.flag,
                                ),
                              ),
                            );
                          },
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Container(
                              padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF333333),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Image.asset(
                                      'assets/images/${leagueInfo.logo}',
                                      width: 50, // Adjust the width as needed
                                      height: 50, // Adjust the height as needed
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Text(
                                    leagueInfo.name,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Image.asset(
                                      'assets/images/${leagueInfo.logo}',
                                      width: 50, // Adjust the width as needed
                                      height: 50, // Adjust the height as needed
                                    ),
                                  ),
                                ],
                              ),
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