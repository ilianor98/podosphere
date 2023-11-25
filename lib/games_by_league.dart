import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podosphere/game_by_league_details.dart';
import 'package:intl/intl.dart';

class FixturesLeague extends StatelessWidget {
  final String leagueName;
  final List<Map<String, dynamic>> leagueData;
  final leagueId;
  final String logo;
  final String flag;

  const FixturesLeague(
      {super.key,
      required this.leagueName,
      required this.leagueData,
      required this.leagueId,
      required this.logo,
      required this.flag});

  String formatTime(String dateTimeString) {
  final parsedDate = DateTime.parse(dateTimeString);
  final localDate = parsedDate.toLocal();
  
  final formattedTime = DateFormat.Hm().format(localDate);
  return formattedTime;
}

  @override
  Widget build(BuildContext context) {
    final fixturesForLeague = leagueData
        .where((fixture) => fixture['league']['id'] == leagueId)
        .toList();

    if (fixturesForLeague.isEmpty) {
      return Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  flag == 'null'
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/$logo',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(leagueName,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center),
                            SizedBox(
                              width: 16.0,
                            ),
                            Container(
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/$logo',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Image.asset(
                                'assets/images/$logo',
                                width: 30,
                                height: 30,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text(
                              leagueName,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/images/$flag',
                              width: 30,
                              height: 30,
                            ),
                          ],
                        ),
                  const SizedBox(height: 8.0),
                  Text(
                    'No fixtures today.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodayDetails(
              leagueId: leagueId,
              leagueName: leagueName,
              logo: logo,
              flag: flag,
              leagueData: leagueData,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            flag == 'null'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/$logo',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(leagueName,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        width: 16.0,
                      ),
                      Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/$logo',
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/$logo',
                          width: 30,
                          height: 30,
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(leagueName,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                        width: 16.0,
                      ),
                      SvgPicture.asset(
                        'assets/images/$flag',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
            const SizedBox(height: 8.0),
            SizedBox(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                  1: FlexColumnWidth(3.0),
                  2: FlexColumnWidth(2.0),
                  3: FlexColumnWidth(3.0),
                  4: FlexColumnWidth(2.0),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: fixturesForLeague.map((fixture) {
                  final homeTeam = fixture['teams']['home']['name'];
                  final awayTeam = fixture['teams']['away']['name'];
                  final homeLogo = fixture['teams']['home']['logo'];
                  final awayLogo = fixture['teams']['away']['logo'];
                  final scoreHome = fixture['goals']['home'];
                  final scoreAway = fixture['goals']['away'];
                  final time = formatTime(fixture['fixture']['date']);
                  final shortStatus = fixture['fixture']['status']['short'];
                  final timeElapsed = fixture['fixture']['status']['elapsed'];

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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
                            SizedBox(width: 3,),
                            Container(
                              height: 16,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                              child: Center(child: Text(timeElapsed.toString(), style: TextStyle(color: Colors.white), ),),
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
                  }
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
