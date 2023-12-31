import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class PreMatchDetails extends StatefulWidget {
  final fixtureId;
  final shortStatus;
  final homeTeam;
  final awayTeam;
  final homeLogo;
  final awayLogo;
  final String time;

  const PreMatchDetails(
      {Key? key,
      required this.fixtureId,
      required this.shortStatus,
      required this.homeTeam,
      required this.awayTeam,
      required this.homeLogo,
      required this.awayLogo,
      required this.time})
      : super(key: key);

  @override
  State<PreMatchDetails> createState() => _PreMatchDetailsState();
}

class _PreMatchDetailsState extends State<PreMatchDetails> {
  List<Map<String, dynamic>> oddsStats = [];
  late String error = '';

  @override
  void initState() {
    super.initState();
    fetchFixtureData();
  }

  Future<void> fetchFixtureData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api-football-v1.p.rapidapi.com/v3/odds?fixture=${widget.fixtureId}',
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
        if (responseData != null &&
            responseData is List &&
            responseData.isNotEmpty) {
          setState(() {
            oddsStats = List<Map<String, dynamic>>.from(responseData);
          });
        } else {
          error = 'Insufficient data';
          throw Exception('Insufficient data');
        }
      } else {
        setState(() {
          error = 'Failed to fetch fixture odds';
        });
        throw Exception('Failed to fetch fixture odds');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeTeam = widget.homeTeam;
    final awayTeam = widget.awayTeam;
    final homeLogo = widget.homeLogo;
    final awayLogo = widget.awayLogo;
    final time = widget.time;
    final shortStatus = widget.shortStatus.toString();
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: const Text(
          'Match Details',
          textAlign: TextAlign.center,
          style: TextStyle(
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
                          child:
                              Image.network(homeLogo, width: 55, height: 55)),
                      const Flexible(
                        fit: FlexFit.tight,
                        flex: 6,
                        child: Text(
                          'Pre Game Odds',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child:
                              Image.network(awayLogo, width: 55, height: 55)),
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
                                  time,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                      decorationColor: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'PST',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
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
                                  time,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      decoration: TextDecoration.lineThrough,
                                      decorationThickness: 2,
                                      decorationColor: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'CANC',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else if (shortStatus == 'TBD')
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Column(
                              children: [
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
                                const Text(
                                  'TBD',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else if (shortStatus == 'NS')
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  time,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.white),
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
                    height: 10,
                  ),
                  Column(children: [
                    if (error == 'Insufficient data')
                      Text(
                        'Error: $error',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    else if (error == 'Failed to fetch fixture odds')
                      Text(
                        'Error: $error',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    else
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: oddsStats.isEmpty
                              ? List.generate(
                                  1,
                                  (index) => Text(
                                      error)) // Display error message when oddsStats is empty
                              : List.generate(
                                  oddsStats[0]['bookmakers'].length,
                                  (index) {
                                    return Column(
                                      children: [
                                        OddsItem(
                                          bookmaker: oddsStats[0]['bookmakers']
                                              [index],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ), // Adjust the height as needed
                                      ],
                                    );
                                  },
                                ).toList()),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OddsItem extends StatelessWidget {
  final Map<String, dynamic>? bookmaker;

  const OddsItem({Key? key, this.bookmaker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmakerId = bookmaker?['name'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            bookmakerId,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(bookmaker?['bets'][0]['name'],
              style: const TextStyle(
                color: Colors.white,
              )),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('1',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              Text('X',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              Text('2',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(bookmaker?['bets'][0]['values'][0]['odd'],
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              Text(bookmaker?['bets'][0]['values'][1]['odd'],
                  style: const TextStyle(
                    color: Colors.white,
                  )),
              Text(bookmaker?['bets'][0]['values'][2]['odd'],
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
