import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TeamProfileSquad extends StatefulWidget {
  final int teamId;

  const TeamProfileSquad({super.key, required this.teamId});

  @override
  State<TeamProfileSquad> createState() => _TeamProfileSquadState();
}

class _TeamProfileSquadState extends State<TeamProfileSquad> {
  List<Map<String, dynamic>> squad = [];
  @override
  void initState() {
    super.initState();
    fetchSquadProfile();
  }

  Future<void> fetchSquadProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://v3.football.api-sports.io/players/squads?team=${widget.teamId}',
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
          setState(() {
            squad =
                List<Map<String, dynamic>>.from(data['response'][0]['players']);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load squad data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final squadData = squad;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.0),
          1: FlexColumnWidth(6.0),
          2: FlexColumnWidth(2.0),
        },
        children: List.generate(squadData.length, (index) {
          final player = squadData[index];
          return TableRow(
            children: [
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Column(
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
                                    player['photo'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          child: Image.network(
                            player['photo'],
                            height: 65,
                            width: 65,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          player['name'],
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      )
                    ],
                  )),
              TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Column(
                    children: [
                      Center(
                          child: Text(
                        player['number']?.toString() ?? '-',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ))
            ],
          );
        }),
      ),
    );
  }
}
