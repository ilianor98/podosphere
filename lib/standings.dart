import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:podosphere/team_details.dart';

class Standings extends StatefulWidget {
  final int leagueId;
  final String champName;
  final int season;
  Standings({required this.leagueId, required this.champName, required this.season});

  @override
  _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333), // Dark mode background color
        title:
            Text('${widget.champName}', style: TextStyle(color: Colors.white)),
        centerTitle: true, // Center-align the title
      ),
      body: Container(
        color: const Color(0xFF333333), // Change the background color
        child: ListView.builder(
          itemCount: standingsData.length,
          itemBuilder: (context, index) {
            final teamData = standingsData[index];
            return StandingsItem(teamData: teamData);
          },
        ),
      ),
    );
  }
}

class StandingsItem extends StatelessWidget {
  final Map<String, dynamic> teamData;

  StandingsItem({required this.teamData});

  void navigateToTeamDetails(BuildContext context, int teamId) {
    // Navigate to the TeamDetailsPage and pass the team's ID as a parameter
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetailsPage(teamId: teamId),
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

    return GestureDetector(
      onTap: () {
        navigateToTeamDetails(context, teamId);
      },
      child: ListTile(
        leading: Image.network(teamData['team']['logo']),
        title: Text(teamName, style: TextStyle(color: Colors.white)),
        subtitle: Text(
          'Points: $points - Goals For: $goalsFor - Goals Against: $goalsAgainst',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
