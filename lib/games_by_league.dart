import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FixturesLeague extends StatelessWidget {
  final String leagueName;
  final List<Map<String, dynamic>> leagueData;
  final leagueId;
  final String logo;
  final String flag;

  const FixturesLeague({
    super.key,
    required this.leagueName,
    required this.leagueData,
    required this.leagueId,
    required this.logo,
    required this.flag
  });

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

    if (fixturesForLeague.isEmpty) {
      return Center(child: Column(
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
            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Image.asset(
                                      'assets/images/$logo',
                                      width: 30, // Adjust the width as needed
                                      height: 30, // Adjust the height as needed
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
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/$flag',
                                    width: 30, // Adjust the width as needed
                                    height: 30, // Adjust the height as needed
                                  ),
                                ],
                              ),
            const SizedBox(height: 8.0),
            Text('No fixtures available for this league.', style: const TextStyle(color: Colors.white),),
            ],),),
        ],
      ),);
    }
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Image.asset(
                                      'assets/images/$logo',
                                      width: 30, // Adjust the width as needed
                                      height: 30, // Adjust the height as needed
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
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  if (flag != 'null')
                                  SvgPicture.asset(
                                    'assets/images/$flag',
                                    width: 30, // Adjust the width as needed
                                    height: 30, // Adjust the height as needed
                                  ),
                                ],
                              ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: fixturesForLeague.length,
                  itemBuilder: (context, index) {
                    final homeTeam = fixturesForLeague[index]['teams']['home']['name'];
                    final awayTeam = fixturesForLeague[index]['teams']['away']['name'];
                    final homeLogo = fixturesForLeague[index]['teams']['home']['logo'];
                    final awayLogo = fixturesForLeague[index]['teams']['away']['logo'];
                    final scoreHome = fixturesForLeague[index]['goals']['home'];
                    final scoreAway = fixturesForLeague[index]['goals']['away'];
                    final time = formatTime(fixturesForLeague[index]['fixture']['date']);
                    final shortStatus = fixturesForLeague[index]['fixture']['status']['short'];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
      if (shortStatus == 'FT') ...[
        Image.network(
          homeLogo,
          width: 30,
          height: 30,
        ),
        Text(homeTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text('$scoreHome - $scoreAway', style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text(awayTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Image.network(
          awayLogo,
          width: 30,
          height: 30,
        ),
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.white)),
      ] else if (shortStatus == 'PST') ...[
        Image.network(
          homeLogo,
          width: 30,
          height: 30,
        ),
        Text(homeTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text('PST', style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text(awayTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Image.network(
          awayLogo,
          width: 30,
          height: 30,
        ),
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.white)),
      ] else if (shortStatus == 'CANC') ...[
        Image.network(
          homeLogo,
          width: 30,
          height: 30,
        ),
        Text(homeTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text('CANC', style: const TextStyle(fontSize: 10, color: Colors.white)),
        Text(awayTeam, style: const TextStyle(fontSize: 10, color: Colors.white)),
        Image.network(
          awayLogo,
          width: 30,
          height: 30,
        ),
        Text(time, style: const TextStyle(fontSize: 10, color: Colors.white)),
      ]
    ],
                      ),
                    );
                  },),
            ),
          ],
        ),
      ),
    );
  }
}
