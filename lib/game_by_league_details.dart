//needs to be remade



import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    final fixturesForLeague = leagueData
        .where((fixture) => fixture['league']['id'] == leagueId)
        .toList();

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text(
          '$leagueName Fixtures',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333333),
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
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: SizedBox(
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(2.0),
                          1: FlexColumnWidth(3.0),
                          2: FlexColumnWidth(2.0),
                          3: FlexColumnWidth(3.0),
                          4: FlexColumnWidth(2.0),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
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
                            return TableRow(
                              children: [
                                Image.network(homeLogo, width: 30, height: 30),
                                Text(
                                  homeTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'PST',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
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
                                Text(
                                  awayTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Image.network(awayLogo, width: 30, height: 30),
                              ],
                            );
                          } else if (shortStatus == 'CANC') {
                            return TableRow(
                              children: [
                                Image.network(homeLogo, width: 30, height: 30),
                                Text(
                                  homeTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'CANC',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
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
                                Text(
                                  awayTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Image.network(awayLogo, width: 30, height: 30),
                              ],
                            );
                          } else if (shortStatus == 'NS') {
                            return TableRow(
                              children: [
                                Image.network(homeLogo, width: 30, height: 30),
                                Text(
                                  homeTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      time,
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Text(
                                  awayTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Image.network(awayLogo, width: 30, height: 30),
                              ],
                            );
                          } else if (shortStatus != 'FT') {
                            return TableRow(
                              children: [
                                Image.network(homeLogo, width: 30, height: 30),
                                Text(
                                  homeTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '$scoreHome - $scoreAway',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  awayTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Image.network(awayLogo, width: 30, height: 30),
                              ],
                            );
                          } else {
                            return TableRow(
                              children: [
                                Image.network(homeLogo, width: 30, height: 30),
                                Text(
                                  homeTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      '$scoreHome - $scoreAway',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      shortStatus,
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      fixtureId.toString(),
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Text(
                                  awayTeam,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Image.network(awayLogo, width: 30, height: 30),
                                SizedBox(
                                  height: 8.0,
                                ),
                                 //MatchDetailsTest(fixtureId: fixtureId),
                              ],
                            );
                          }
                        }).toList(),
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
