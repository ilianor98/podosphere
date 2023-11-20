import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:podosphere/team_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeagueTeams extends StatefulWidget {
  final int leagueId;
  final String champName;
  final int season;
  final String logo;
  final String flag;

  LeagueTeams(
      {required this.leagueId, required this.champName, required this.season, required this.flag, required this.logo});

  @override
  _LeagueTeamsState createState() => _LeagueTeamsState();
}

class _LeagueTeamsState extends State<LeagueTeams> {
  List<Map<String, dynamic>> teamsData = [];

  @override
  void initState() {
    super.initState();
    fetchLeagueTeamsData();
  }

  Future<void> fetchLeagueTeamsData() async {
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
          final teams = data['response'][0]['league']['standings'][0];
          setState(() {
            teamsData = List<Map<String, dynamic>>.from(teams);
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
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.green),
        ),
        title: Row(
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/${widget.logo}',
                width: 30, // Adjust the width as needed
                height: 30, // Adjust the height as needed
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              '${widget.champName}',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16.0),
            SvgPicture.asset(
              'assets/images/${widget.flag}',
              width: 30, // Adjust the width as needed
              height: 30, // Adjust the height as needed
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: teamsData.length,
        itemBuilder: (context, index) {
          final team = teamsData[index];

          if (team['team'] != null &&
              team['team']['name'] is String &&
              team['team']['logo'] is String) {
            return GestureDetector(
              onTap: () {
                int teamId = team['team']['id'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeamProfile(teamId: teamId, logo: team['team']['logo'], teamName: team['team']['name'], flag: widget.flag),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  children: [
                    Image.network(
                      team['team']['logo'],
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      team['team']['name'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ), textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListTile(
              title: Text(
                'Invalid team data at index $index',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
