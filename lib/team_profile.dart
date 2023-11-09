import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TeamProfile extends StatefulWidget {
  final int teamId;

  const TeamProfile({super.key, required this.teamId});

  @override
  State<TeamProfile> createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {
  List<Map<String, dynamic>> profile = [];
  String selectedOption = 'Details';

  @override
  void initState() {
    super.initState();
    fetchTeamProfile();
  }

  Future<void> fetchTeamProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://v3.football.api-sports.io/teams?id=${widget.teamId}',
        ),
        headers: {
          'X-Rapidapi-Key': 'aef994ca7854998686130ca1111308df',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final teamProfile = data['response'][0];
          setState(() {
            profile = [teamProfile];
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
        title: Text('Team Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(
                'Team Name: ${profile.isNotEmpty ? profile[0]['team']['name'] : ''}',
              ),
              leading: Image.network(
                profile.isNotEmpty ? profile[0]['team']['logo'] : '',
                width: 40,
                height: 40,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildOptionButton('Details'),
                buildOptionButton('Venue'),
              ],
            ),
            SizedBox(height: 16),
            if (selectedOption == 'Details') buildDetails(),
            if (selectedOption == 'Venue') buildVenue(),
          ],
        ),
      ),
    );
  }

  Widget buildOptionButton(String option) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedOption = option;
        });
      },
      child: Text(option),
    );
  }

  Widget buildDetails() {
    return Column(
      children: [
        ListTile(
          title: Text('Founded: ${profile[0]['team']['founded']}'),
          subtitle: Text('National: ${profile[0]['team']['national']}'),
        ),
      ],
    );
  }

  Widget buildVenue() {
    return Column(
      children: [
        ListTile(
          title: Text('Venue: ${profile[0]['venue']['name']}'),
          subtitle: Text('City: ${profile[0]['venue']['city']}'),
        ),
        SizedBox(height: 8),
        Image.network(
          profile.isNotEmpty ? profile[0]['venue']['image'] : '',
          width: 120,
          height: 120,
        ),
      ],
    );
  }
}
