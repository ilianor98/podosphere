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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Details'),
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
                              height: 75,
                              width: 75,
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(player[0]['player']['photo']),
                        radius: 50,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Name: ${player[0]['player']['firstname']} ${player[0]['player']['lastname']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text('Age: ${player[0]['player']['age']}'),
                    Text('Nationality: ${player[0]['player']['nationality']}'),
                    Text('Height: ${player[0]['player']['height']}'),
                    Text('Weight: ${player[0]['player']['weight']}'),
                    SizedBox(height: 20),
                    Text(
                      'Statistics:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    for (var stat in player[0]['statistics'])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('League: ${stat['league']['name']}'),
                          Text('Position: ${stat['games']['position']}'),
                          // Add other statistics here...
                          SizedBox(height: 10),
                        ],
                      ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
