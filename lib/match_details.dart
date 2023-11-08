import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MatchDetails extends StatefulWidget {
  final int fixtureId;

  final int scoreHome;
  final int scoreAway;

  const MatchDetails(
      {super.key,
      required this.fixtureId,
      required this.scoreHome,
      required this.scoreAway});

  @override
  State<MatchDetails> createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  List<Map<String, dynamic>> statistics = [];

  @override
  void initState() {
    super.initState();
    fetchMatchStatistics();
  }

  Future<void> fetchMatchStatistics() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures/statistics?fixture=${widget.fixtureId}'),
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
          setState(() {
            statistics = List<Map<String, dynamic>>.from(data['response']);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load match statistics');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (statistics.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final firstTeam = statistics[0]['team'];
    final secondTeam = statistics[1]['team'];
    final firstTeamStatistics = statistics[0]['statistics'];
    final commonStatTypes = firstTeamStatistics
        .map<String>((stat) => stat['type'].toString())
        .toList();
    final secondTeamStatistics = statistics[1]['statistics'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: Text('Match Details'),
      ),
      body: Container(
        color: const Color(0xFF333333),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Row(children: [
              Expanded(
                child: DataTable(
                  dataRowMinHeight: 75,
                  dataRowMaxHeight: 75,
                  columnSpacing: 12,
                  columns: [
                    DataColumn(
                      label: Center(
                        child: Text(
                          firstTeam['name'],
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                           '${widget.scoreHome.toString()} - ${widget.scoreAway.toString()}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      numeric: false,
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          secondTeam['name'],
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      numeric: false,
                    ),
                  ],
                  rows: commonStatTypes.map<DataRow>((statType) {
                    final firstTeamStat = firstTeamStatistics.firstWhere(
                      (stat) => stat['type'] == statType,
                      orElse: () => {'value': ''},
                    );
                    final secondTeamStat = secondTeamStatistics.firstWhere(
                      (stat) => stat['type'] == statType,
                      orElse: () => {'value': ''},
                    );

                    return DataRow(cells: [
                      
                      DataCell(
                        Center(
                          child: Text(
                            firstTeamStat['value'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            statType,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            secondTeamStat['value'].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
