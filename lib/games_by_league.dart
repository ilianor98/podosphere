import 'dart:async';
import 'package:http/http.dart' as http;
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
  final String country;

  const FixturesLeague(
      {super.key,
      required this.leagueName,
      required this.leagueData,
      required this.leagueId,
      required this.logo,
      required this.flag,
      required this.country});

  String formatTime(String dateTimeString) {
    final parsedDate = DateTime.parse(dateTimeString);
    final localDate = parsedDate.toLocal();

    final formattedTime = DateFormat.Hm().format(localDate);
    return formattedTime;
  }

  Widget loadImage(String url) {
    int retryCount = 0;
    const int maxRetries = 2;

    return Image.network(
      url,
      width: 30,
      height: 30,
      errorBuilder: (context, error, stackTrace) {
        if (retryCount < maxRetries) {
          retryCount++;
          return loadImage(url); // Retry loading the image
        } else {
          return const SizedBox(); // Return an empty SizedBox after max retries
        }
      },
    );
  }

  Future<Widget> loadSvgImage(String url) async {
    int retryCount = 0;
    const int maxRetries = 3;

    Completer<Widget> completer = Completer();

    while (retryCount < maxRetries) {
      try {
        final svgData = await http.get(Uri.parse(url));
        if (svgData.statusCode == 200) {
          final widget = SvgPicture.string(
            svgData.body,
            width: 30,
            height: 30,
          );
          completer.complete(widget);
          return widget;
        }
      } catch (e) {
        retryCount++;
      }
    }

    completer.complete(
        const SizedBox()); // Return an empty SizedBox after max retries
    return completer.future;
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
                color: Colors.grey.shade700,
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
                                color: Colors.white, child: loadImage(logo)),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Text(leagueName,
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Container(
                                color: Colors.white, child: loadImage(logo)),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                color: Colors.white, child: loadImage(logo)),
                            SizedBox(
                              width: 16.0,
                            ),
                            Expanded(
                              child: Text(
                                leagueName,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            FutureBuilder<Widget>(
                              future: loadSvgImage(flag),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return snapshot.data ??
                                      const SizedBox(); // Use the loaded SVG or return an empty SizedBox if failed
                                } else {
                                  return const SizedBox(); // Return an empty SizedBox while loading
                                }
                              },
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
              leagueData: leagueData,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            flag == 'null'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(color: Colors.white, child: loadImage(logo)),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(leagueName,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Container(color: Colors.white, child: loadImage(logo)),
                    ],
                  )
                :
                leagueName == 'Cup' 
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(color: Colors.white, child: loadImage(logo)),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text('$leagueName ($country)',
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      FutureBuilder<Widget>(
                        future: loadSvgImage(flag),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.data ??
                                const SizedBox(); // Use the loaded SVG or return an empty SizedBox if failed
                          } else {
                            return const SizedBox(); // Return an empty SizedBox while loading
                          }
                        },
                      ),
                    ],
                  ) :Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(color: Colors.white, child: loadImage(logo)),
                      SizedBox(
                        width: 16.0,
                      ),
                      Expanded(
                        child: Text(leagueName,
                            style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      FutureBuilder<Widget>(
                        future: loadSvgImage(flag),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return snapshot.data ??
                                const SizedBox(); // Use the loaded SVG or return an empty SizedBox if failed
                          } else {
                            return const SizedBox(); // Return an empty SizedBox while loading
                          }
                        },
                      ),
                    ],
                  ),
            const SizedBox(height: 8.0),
            SizedBox(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2.0),
                  1: FlexColumnWidth(2.0),
                  2: FlexColumnWidth(3.0),
                  3: FlexColumnWidth(2.0),
                  4: FlexColumnWidth(3.0),
                  5: FlexColumnWidth(2.0),
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
                  final penaltyScoreHome = fixture['score']['penalty']['home'];
                  final penaltyScoreAway = fixture['score']['penalty']['away'];

                  if (shortStatus == 'PST') {
                    return TableRow(
                      children: [
                        const Text(
                          'PST',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
                        Text(
                          homeTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              decorationColor: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          awayTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(awayLogo),
                      ],
                    );
                  } else if (shortStatus == 'CANC') {
                    return TableRow(
                      children: [
                        const Text(
                          'CANC',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
                        Text(
                          homeTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              decorationColor: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          awayTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(awayLogo),
                      ],
                    );
                  } else if (shortStatus == 'TBD') {
                    return TableRow(
                      children: [
                        const Text(
                          'TBD',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
                        Text(
                          homeTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          time,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                              decorationColor: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          awayTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(awayLogo),
                      ],
                    );
                  } else if (shortStatus == 'NS') {
                    return TableRow(
                      children: [
                        const SizedBox(),
                        loadImage(homeLogo),
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
                        loadImage(awayLogo),
                      ],
                    );
                  } else if (shortStatus == 'PEN') {
                    return TableRow(
                      children: [
                        const Text(
                          'PEN',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
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
                              '$penaltyScoreHome - $penaltyScoreAway',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade300),
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
                        loadImage(awayLogo),
                      ],
                    );
                  } else if (shortStatus != 'FT') {
                    return TableRow(
                      children: [
                        Text(
                          '${timeElapsed.toString()}\'',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
                        Text(
                          homeTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.green,
                          ),
                          child: Text(
                            '$scoreHome - $scoreAway',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          awayTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(awayLogo),
                      ],
                    );
                  } else {
                    return TableRow(
                      children: [
                        const Text(
                          'FT',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(homeLogo),
                        Text(
                          homeTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '$scoreHome - $scoreAway',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          awayTeam,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        loadImage(awayLogo),
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
