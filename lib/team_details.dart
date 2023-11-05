import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TeamDetailsPage extends StatefulWidget {
  final int teamId;

  TeamDetailsPage({required this.teamId});

  @override
  _TeamDetailsPageState createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  List<Map<String, dynamic>> matches = [];

  @override
  void initState() {
    super.initState();
    fetchTeamMatches();
  }

  String parseDate(String date) {
    // Parse the date string and format it as "day/month/year"
    final parsedDate = DateTime.parse(date);
    final formattedDate =
        "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    return formattedDate;
  }

  Future<void> fetchTeamMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?season=2023&team=${widget.teamId}'),
        headers: {
          'X-Rapidapi-Key':
              '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final teamMatches = data[
              'response']; // Adjust this to the actual path in the API response

          // Sort matches based on date
          teamMatches.sort((a, b) {
            final matchDateA = DateTime.parse(a['fixture']['date']);
            final matchDateB = DateTime.parse(b['fixture']['date']);
            return matchDateA.compareTo(matchDateB);
          });

          setState(() {
            matches = List<Map<String, dynamic>>.from(teamMatches);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load team matches');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: Text('Team Details', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: const Color(0xFF333333),
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: DataTable(
                dataRowMinHeight: 75,
                dataRowMaxHeight: 75,
                columns: [
                  DataColumn(
                    label:
                        Text('Home Team', style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label: Text('Score', style: TextStyle(color: Colors.white)),
                  ),
                  DataColumn(
                    label:
                        Text('Away Team', style: TextStyle(color: Colors.white)),
                  ),
                ],
                rows: matches.map((matchData) {
                  final homeTeam = matchData['teams']['home'];
                  final awayTeam = matchData['teams']['away'];
                  final homeTeamLogo = homeTeam['logo'];
                  final awayTeamLogo = awayTeam['logo'];
                  final homeTeamName = homeTeam['name'];
                  final awayTeamName = awayTeam['name'];
                  final score = matchData['score']['fulltime'];
                  final matchDate = parseDate(matchData['fixture']['date']);
                  final matchType = matchData['league']['name'];
            
                  return DataRow(
                    cells: [
                      DataCell(
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(homeTeamLogo, width: 40, height: 40),
                              Text(
                                homeTeamName,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (score['home'] != null)
                                Text(
                                  '${score['home']}-${score['away']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                )
                              else
                                Text(
                                  matchDate,
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 25),
                                ),
                                if (score['home'] != null)
                                Text(
                                matchDate,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              )
                              else
                                const Text(
                                  ' ',
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 25),
                                ),
                              
                              Text(
                                matchType,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.network(awayTeamLogo, width: 40, height: 40),
                              Text(
                                awayTeamName,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }
}
