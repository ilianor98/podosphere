import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerDetails extends StatefulWidget {
  final playerId;
  const PlayerDetails({super.key, required this.playerId});

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  List<Map<String, dynamic>> player = [];
  @override
  void initState() {
    super.initState();
    fetchPlayerData();
  }

  Future<void> fetchPlayerData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://v3.football.api-sports.io/players?id=${widget.playerId}&season=2023',
        ),
        headers: {
          'X-Rapidapi-Key': 'aef994ca7854998686130ca1111308df',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final playerData = data['response'][0];
          setState(() {
            player = [playerData];
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load coach data');
      }
    } catch (e) {
      print('Error: $e');
    }
    print(player[0]['player']['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text(
          'Player Details',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333333),
        centerTitle: true,
      ),
      body: player.isNotEmpty
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.black, width: 5.0)),
                                      child: Image.network(
                                        player[0]['player']['photo'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    player[0]['player']['photo'],
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${player[0]['player']['firstname']} ${player[0]['player']['lastname']}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Age: ${player[0]['player']['age']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Naionality: ${player[0]['player']['nationality']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Date of birth: ${player[0]['player']['birth']['date']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  softWrap:
                                      true, // Allow text to wrap to the next line
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Place of birth: ${player[0]['player']['birth']['place']}, ${player[0]['player']['birth']['country']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Height: ${player[0]['player']['height']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Weight: ${player[0]['player']['weight']}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    LeaguesDropdown(statistics: player[0]['statistics'])
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class LeaguesDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> statistics;

  const LeaguesDropdown({
    required this.statistics,
    Key? key,
  }) : super(key: key);

  @override
  _LeaguesDropdownState createState() => _LeaguesDropdownState();
}

class _LeaguesDropdownState extends State<LeaguesDropdown> {
  late List<String> leagues;
  late Map<String, List<Map<String, dynamic>>> leagueStats;
  late String? selectedLeague;

  @override
  void initState() {
    super.initState();
    extractLeagues();
  }

  void extractLeagues() {
    Set<String> uniqueLeagues = Set();

    for (var stat in widget.statistics) {
      if (stat['league'] != null && stat['league']['name'] != null) {
        uniqueLeagues.add(stat['league']['name']);
      }
    }

    leagues = uniqueLeagues.toList();

    leagueStats = {};
    for (var league in leagues) {
      leagueStats[league] = widget.statistics
          .where((stat) => stat['league']['name'] == league)
          .toList();
    }

    if (leagues.isNotEmpty) {
      selectedLeague = leagues.first;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leagues Participated:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          hint: Text('Select a league'),
          value: selectedLeague,
          items: leagues
              .map<DropdownMenuItem<String>>(
                (String value) => DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ),
              )
              .toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedLeague = newValue;
            });
          },
        ),
        if (selectedLeague != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Statistics for $selectedLeague:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              for (var stat in leagueStats[selectedLeague]!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text('Games: ${stat['games']['appearences']}'),
                    // Display other statistics as needed
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
