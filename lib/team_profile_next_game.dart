import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:podosphere/pre_match_details.dart';

class NextGame extends StatefulWidget {
  final teamId;
  const NextGame({super.key, required this.teamId});

  @override
  State<NextGame> createState() => _NextGameState();
}

class _NextGameState extends State<NextGame> {
  List<Map<String, dynamic>> fixture = [];

  @override
  void initState() {
    super.initState();
    fetchFixtures();
  }

  Future<void> fetchFixtures() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?next=1&team=${widget.teamId}&timezone=Europe/Athens'),
        headers: {
          'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
          'x-rapidapi-key':
              '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final tempFixtures = data['response'];
          setState(() {
            fixture = List<Map<String, dynamic>>.from(tempFixtures);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load fixture');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatTime(String dateTimeString) {
    final parsedDate = DateTime.parse(dateTimeString);
    final localDate = parsedDate.toLocal();

    final formattedTime = DateFormat.Hm().format(localDate);
    return formattedTime;
  }

  String formatDate(String dateTimeString) {
  final parsedDate = DateTime.parse(dateTimeString);
  final localDate = parsedDate.toLocal();

  final formattedDate = '${localDate.day}/${localDate.month}/${localDate.year % 100}';
  return formattedDate;
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

  void navigateToPreMatchDetails(int fixtureId, String shortStatus, String homeTeam, String awayTeam, String homeLogo,String awayLogo,String time, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreMatchDetails(
          fixtureId: fixtureId,
          shortStatus: shortStatus,
          homeTeam: homeTeam,
          awayTeam: awayTeam,
          homeLogo: homeLogo,
          awayLogo: awayLogo,
          time: time,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeTeam = fixture[0]['teams']['home']['name'];
    final awayTeam = fixture[0]['teams']['away']['name'];
    final homeLogo = fixture[0]['teams']['home']['logo'];
    final awayLogo = fixture[0]['teams']['away']['logo'];
    final scoreHome = fixture[0]['goals']['home'];
    final scoreAway = fixture[0]['goals']['away'];
    final time = formatTime(fixture[0]['fixture']['date']);
    final date = formatDate(fixture[0]['fixture']['date']);
    final shortStatus = fixture[0]['fixture']['status']['short'];
    final timeElapsed = fixture[0]['fixture']['status']['elapsed'];
    final penaltyScoreHome = fixture[0]['score']['penalty']['home'];
    final penaltyScoreAway = fixture[0]['score']['penalty']['away'];
    final fixtureId = fixture[0]['fixture']['id'];
    return /*fixture.isEmpty 
      ? Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(10.0),),
          child: const Center(child: Text('No data for next fixture available', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),),
      )
     :GestureDetector(
      onTap: () {
        navigateToPreMatchDetails(fixtureId, shortStatus, homeTeam, awayTeam, homeLogo, awayLogo, time, context);
      },
      child: */Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade700,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text('Next Game', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Row(
          children: [
                if (shortStatus == 'PST') ...[
                  Flexible(
                    flex:2, fit: FlexFit.tight,
                    child: const Text(
                      'PST',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(awayLogo)),
                ] else if (shortStatus == 'CANC') ...[
                  Flexible(
                    flex:2, fit: FlexFit.tight,
                    child: const Text(
                      'CANC',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(awayLogo)),
                ] else if (shortStatus == 'TBD') ...[
                  Flexible(
                    flex:2, fit: FlexFit.tight,
                    child: const Text(
                      'TBD',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 2,
                          decorationColor: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(awayLogo)),
                ] else if (shortStatus == 'NS') ...[
                   Flexible(flex: 2, child: SizedBox(), fit: FlexFit.tight),
                  Flexible(flex: 2,child: loadImage(homeLogo), fit: FlexFit.tight),
                  Flexible(flex: 3,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 2,
                    child: Column(
                      children: [
                        Text(
                          time,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(date, style: TextStyle(fontSize: 9, color: Colors.white), textAlign: TextAlign.center,)
                      ],
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 3,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 2,
                    child: loadImage(awayLogo), fit: FlexFit.tight),
                ] else if (shortStatus == 'PEN') ...[
                  Flexible(flex:2, fit: FlexFit.tight,
                    child: const Text(
                      'PEN',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),),
                  Flexible(flex:2, fit: FlexFit.tight,
                    child: Column(
                      children: [
                        Text(
                          '$scoreHome - $scoreAway',
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '$penaltyScoreHome - $penaltyScoreAway',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade300),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Flexible(flex: 3,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 2,
                    child: loadImage(awayLogo), fit: FlexFit.tight),
                ] else if (shortStatus != 'FT') ...[
                  Flexible(flex:2, fit: FlexFit.tight,
                    child: Text(
                      '${timeElapsed.toString()}\'',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),),
                  Flexible(flex: 2, fit: FlexFit.tight,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.green,
                      ),
                      child: Text(
                        '$scoreHome - $scoreAway',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(flex: 3,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 2,
                    child: loadImage(awayLogo), fit: FlexFit.tight)
                ] else ...[
                  Flexible(flex:2, fit: FlexFit.tight,
                    child: const Text(
                      'FT',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 2, fit: FlexFit.tight,child: loadImage(homeLogo)),
                  Flexible(flex: 3, fit: FlexFit.tight,
                    child: Text(
                      homeTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),),
                  Flexible(flex:2, fit: FlexFit.tight,
                    child: Text(
                      '$scoreHome - $scoreAway',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(flex: 3,
                    child: Text(
                      awayTeam,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                      textAlign: TextAlign.center,
                    ), fit: FlexFit.tight
                  ),
                  Flexible(flex: 2,
                    child: loadImage(awayLogo), fit: FlexFit.tight)
                ]
          ],
        ),
              ],
            )),
      //),
    );
  }
}
