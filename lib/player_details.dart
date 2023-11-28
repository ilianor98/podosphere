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
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: const Text(
          'Player Details',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
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
                        color: Colors.grey.shade700,
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
                                  'Height: ${player[0]['player']['height'] ?? '-'}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Weight: ${player[0]['player']['weight'] ?? '-'}',
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
                    PlayerLeagueStats(player: player)
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class PlayerLeagueStats extends StatelessWidget {
  final List<Map<String, dynamic>> player;

  const PlayerLeagueStats({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text('Current Season Stats', style: TextStyle(color: Colors.white, fontSize: 20),),
          SizedBox(height: 5),
          Column(
            children: player[0]['statistics']
                .map<ExpansionTile>(
                  (leagueData) => ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Row(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Image.network(
                            '${leagueData['league']['logo']}',
                            width: 30, // Adjust the width as needed
                            height: 30, // Adjust the height as needed
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(child: Text(leagueData['league']['name'], style: TextStyle(color: Colors.white), softWrap: true,)),
                      ],
                    ),
                    children: [
                      // Sub-tiles (player stats)
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appearences:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['games']['appearences']}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total minutes:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['games']['minutes']}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Rating:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['games']['rating'] != null ? double.parse(leagueData['games']['rating']).toStringAsFixed(2) : 'N/A'}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shots(On target):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['shots']['total'] ?? '0'}(${leagueData['shots']['on'] ?? '0'})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Goals:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['goals']['total']}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Passes(Accuracy):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['passes']['total'] ?? '0'}(${leagueData['passes']['accuracy'] ?? '0'})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tackles:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['tackles']['total'] ?? '0'}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Interceptions:', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['tackles']['interceptions'] ?? '0'}', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Duels(Won):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['duels']['total'] ?? '0'}(${leagueData['duels']['won'] ?? '0'})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dribbles(Successful):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${leagueData['dribbles']['attempts'] ?? '0'}(${leagueData['dribbles']['success'] ?? '0'})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fouls(Drawn/Committed):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '(${leagueData['fouls']['drawn'] ?? '0'}/${leagueData['fouls']['commited'] ?? '0'})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cards(Yellow/Red):', style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '(${leagueData['cards']['yellow']}/${leagueData['cards']['red']})', style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      // Add other stats as ListTile widgets
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
