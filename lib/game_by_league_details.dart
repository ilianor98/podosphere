//needs to be remade

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podosphere/match_details1.dart';
import 'package:podosphere/standings_widget.dart';

class TodayDetails extends StatelessWidget {
  final String leagueName;
  final List<Map<String, dynamic>> leagueData;
  final leagueId;
  final String logo;
  final String flag;

  const TodayDetails(
      {super.key,
      required this.leagueName,
      required this.leagueData,
      required this.leagueId,
      required this.logo,
      required this.flag});

  String formatTime(String dateTimeString) {
    final parsedDate = DateTime.parse(dateTimeString);
    final formattedTime =
        '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  void navigateToMatchDetails(int fixtureId, int scoreHome, int scoreAway,
      String shortStatus, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailsTest(
          fixtureId: fixtureId,
          homeScore: scoreHome,
          awayScore: scoreAway,
          shortStatus: shortStatus,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fixturesForLeague = leagueData
        .where((fixture) => fixture['league']['id'] == leagueId)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: Text(
          '$leagueName Fixtures',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: SizedBox(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: fixturesForLeague.map((fixture) {
                            final homeTeam = fixture['teams']['home']['name'];
                            final awayTeam = fixture['teams']['away']['name'];
                            final homeLogo = fixture['teams']['home']['logo'];
                            final awayLogo = fixture['teams']['away']['logo'];
                            final scoreHome = fixture['goals']['home'];
                            final scoreAway = fixture['goals']['away'];
                            final time = formatTime(fixture['fixture']['date']);
                            final shortStatus =
                                fixture['fixture']['status']['short'];
                            final timeElapsed =
                                fixture['fixture']['status']['elapsed'];
                            final fixtureId = fixture['fixture']['id'];

                            if (shortStatus == 'PST') {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(homeLogo,
                                          width: 30, height: 30)),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      homeTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'PST',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          time,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      awayTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(awayLogo,
                                          width: 30, height: 30)),
                                ],
                              );
                            } else if (shortStatus == 'CANC') {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(homeLogo,
                                          width: 30, height: 30)),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      homeTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'CANC',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          time,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      awayTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(awayLogo,
                                          width: 30, height: 30)),
                                ],
                              );
                            } else if (shortStatus == 'NS') {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(homeLogo,
                                          width: 30, height: 30)),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      homeTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Text(
                                          time,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      awayTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(awayLogo,
                                          width: 30, height: 30)),
                                ],
                              );
                            } else if (shortStatus != 'FT') {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(homeLogo,
                                          width: 30, height: 30)),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      homeTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Text(
                                          '$scoreHome - $scoreAway',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Container(
                                          height: 16,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green),
                                          child: Center(
                                            child: Text(
                                              timeElapsed.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    flex: 3,
                                    child: Text(
                                      awayTeam,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.tight,
                                      flex: 1,
                                      child: Image.network(awayLogo,
                                          width: 30, height: 30)),
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  navigateToMatchDetails(
                                    fixtureId,
                                    scoreHome,
                                    scoreAway,
                                    shortStatus,
                                    context,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Image.network(homeLogo,
                                            width: 30, height: 30)),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 3,
                                      child: Text(
                                        homeTeam,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            '$scoreHome - $scoreAway',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            shortStatus,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      flex: 3,
                                      child: Text(
                                        awayTeam,
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        flex: 1,
                                        child: Image.network(awayLogo,
                                            width: 30, height: 30)),
                                  ],
                                ),
                              );
                            }
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: StandingsWidget(
                    leagueId: leagueId,
                    champName: leagueName,
                    season: 2023,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
