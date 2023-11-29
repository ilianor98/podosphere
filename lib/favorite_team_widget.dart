import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FavTeamWidget extends StatefulWidget {
  final teamId;

  const FavTeamWidget({super.key, required this.teamId});

  @override
  State<FavTeamWidget> createState() => _FavTeamWidgetState();
}

class _FavTeamWidgetState extends State<FavTeamWidget> {
  List<Map<String, dynamic>> profile = [];
  List<Map<String, dynamic>> nextFixture = [];
  Color dominantColor = Colors.grey.shade700;

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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final teamProfile = data['response'][0];
          setState(() {
            profile = [teamProfile];
          });
          fetchFixtures();
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

  Future<void> fetchFixtures() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?next=1&team=${widget.teamId}&timezone=Europe/Athens'),
        headers: {
          'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
          'x-rapidapi-key':
              '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          final tempFixtures = data['response'];
          setState(() {
            nextFixture = List<Map<String, dynamic>>.from(tempFixtures);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load fixture');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget loadImage(String url) {
    int retryCount = 0;
    const int maxRetries = 2;

    return Image.network(
      url,
      width: 25,
      height: 25,
      errorBuilder: (context, error, stackTrace) {
        if (retryCount < maxRetries) {
          retryCount++;
          return loadImage(url); // Retry loading the image
        } else {
          return const SizedBox(); // Return an empty SizedBox after max retries
        }
      },
    );
  }

  Future<void> _refreshData() async {
    await fetchFixtures();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (profile.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadImage(profile[0]['team']['logo']),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    profile[0]['team']['name'],
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              )
            else
              Text(
                'No team information',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            if (nextFixture.isNotEmpty)
              Text(
                'Next fixture: ${nextFixture[0]['teams']['home']['name']} - ${nextFixture[0]['teams']['away']['name']}',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            else
              Text(
                'No upcoming fixture',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              //IconButton(onPressed: _refreshData, icon: Icon(Icons.refresh))
          ],
        ),
      ),
    );
  }
}
