import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MatchDetailsTest extends StatefulWidget {
  final fixtureId;
  final homeScore;
  final awayScore;
  final shortStatus;

  const MatchDetailsTest(
      {Key? key,
      required this.fixtureId,
      required this.homeScore,
      required this.awayScore,
      required this.shortStatus})
      : super(key: key);

  @override
  State<MatchDetailsTest> createState() => _MatchDetailsTestState();
}

class _MatchDetailsTestState extends State<MatchDetailsTest> {
  List<Map<String, dynamic>> fixtureStats = [];

  @override
  void initState() {
    super.initState();
    fetchFixtureData();
  }

  Future<void> fetchFixtureData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=${widget.fixtureId}',
        ),
        headers: {
          'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
          'x-rapidapi-key':
              '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseData = data['response'];
        if (responseData is List && responseData.length >= 2) {
          setState(() {
            fixtureStats = List<Map<String, dynamic>>.from(responseData);
          });
        } else {
          throw Exception('Insufficient data for both home and away teams');
        }
      } else {
        throw Exception('Failed to fetch fixture statistics');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeTeam = fixtureStats[0]['team']['name'];
    final awayTeam = fixtureStats[1]['team']['name'];
    final homeLogo = fixtureStats[0]['team']['logo'];
    final awayLogo = fixtureStats[1]['team']['logo'];
    final scoreHome = widget.homeScore.toString();
    final scoreAway = widget.awayScore.toString();
    final shortStatus = widget.shortStatus.toString();
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: Text(
          'Match Details',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                          flex: 2,
                          child: Image.network(homeLogo,
                              width: 55, height: 55)),
                      const Flexible(
                        fit: FlexFit.tight,
                        flex: 6,
                        child: Text(
                          'Game Stats',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20),
                              textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                          flex: 2,
                          child: Image.network(awayLogo,
                              width: 55, height: 55)),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        homeTeam,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                    if (shortStatus == 'PST')
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              'PST',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else if (shortStatus == 'CANC')
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              'CANC',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Column(
                          children: [
                            // Widgets for default
                            Text(
                              '$scoreHome - $scoreAway',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              shortStatus,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 5,
                      child: Text(
                        awayTeam,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: fixtureStats.isNotEmpty
                        ? List.generate(
                            fixtureStats[0]['statistics'].length,
                            (index) {
                              return Column(
                                children: [
                                  StatItem(
                                    homeTeamStat: fixtureStats[0]
                                        ['statistics'][index],
                                    awayTeamStat: fixtureStats[1]
                                        ['statistics'][index],
                                  ),
                                  const SizedBox(
                                      height:
                                          10), // Adjust the height as needed
                                ],
                              );
                            },
                          ).toList()
                        : [],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final Map<String, dynamic>? homeTeamStat;
  final Map<String, dynamic>? awayTeamStat;

  const StatItem({Key? key, this.homeTeamStat, this.awayTeamStat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeTeamValue = homeTeamStat?['value'];
    final homeTeamType = homeTeamStat?['type'];
    final awayTeamValue = awayTeamStat?['value'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Container(
            child: Text(
              homeTeamValue != null ? homeTeamValue.toString() : '0',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 6,
          child: Container(
            child: Text(
              homeTeamType == 'expected_goals' ? 'Expected goals' : homeTeamType ?? '-',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Flexible(
          flex: 2,
          child: Container(
            child: Text(
              awayTeamValue != null ? awayTeamValue.toString() : '0',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


