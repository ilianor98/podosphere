import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:podosphere/team_details.dart';

class StandingsWidget extends StatefulWidget {
  final int leagueId;
  final String champName;
  final int season;
  StandingsWidget(
      {required this.leagueId, required this.champName, required this.season});

  @override
  _StandingsWidgetState createState() => _StandingsWidgetState();
}

class _StandingsWidgetState extends State<StandingsWidget> {
  List<Map<String, dynamic>> standingsData = [];

  @override
  void initState() {
    super.initState();
    fetchStandingsData();
  }

  Future<void> fetchStandingsData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/standings?season=${widget.season}&league=${widget.leagueId}'),
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
          final standings = data['response'][0]['league']['standings'][0];
          setState(() {
            standingsData = List<Map<String, dynamic>>.from(standings);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load standings');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Text('STANDINGS',style: TextStyle(fontSize: 25, color: Colors.white), textAlign: TextAlign.center,),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: standingsData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: standingsData.map((teamData) {
                          return StandingsItem(
                            teamData: teamData,
                            season: widget.season,
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class StandingsItem extends StatelessWidget {
  final Map<String, dynamic> teamData;
  final int season;

  StandingsItem({required this.teamData, required this.season});

  void navigateToTeamDetails(
      BuildContext context, int teamId, String teamName) {
    // Navigate to the TeamDetailsPage and pass the team's ID as a parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailsPage(
          teamId: teamId,
          season: season,
          teamName: teamName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamName = teamData['team']['name'];
    final points = teamData['points'];
    final goalsFor = teamData['all']['goals']['for'];
    final goalsAgainst = teamData['all']['goals']['against'];
    final teamId = teamData['team']['id'];
    final form = teamData['form'];
    //final gamesPlayed = teamData['all']['played'];
    final gamesWon = teamData['all']['win'];
    final gamesDraw = teamData['all']['draw'];
    final gamesLost = teamData['all']['lose'];

    return GestureDetector(
      onTap: () {
        navigateToTeamDetails(context, teamId, teamName);
      },
      child: Column(
        children: [
          ListTile(
            leading: Image.network(
              teamData['team']['logo'],
              height: 50,
              width: 50,
            ),
            title: Text('$teamName (${gamesWon.toString()}/${gamesDraw.toString()}/${gamesLost.toString()})',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            subtitle: Row(
              children: [
                Text(
                  'GF: $goalsFor - GA: $goalsAgainst',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10), // Adjust spacing if needed
                FormDisplay(form: form),
              ],
            ),
            trailing: Text(
              '$points',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class FormDisplay extends StatelessWidget {
  final String form;

  const FormDisplay({Key? key, required this.form}) : super(key: key);

  Color getColor(String result) {
    if (result == 'W') {
      return const Color.fromARGB(255, 18, 107, 21);
    } else if (result == 'L') {
      return Color.fromARGB(255, 197, 27, 15);
    } else if (result == 'D') {
      return const Color.fromARGB(255, 179, 164, 30);
    } else {
      // Handle other cases if needed
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: form.split('').map((result) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: getColor(result),
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: Colors.black, // You can adjust the border color
                width: 1.0,
              ),
            ),
            child: Center(
              child: Text(
                result,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
