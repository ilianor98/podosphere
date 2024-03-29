import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/team_profile.dart';
import 'package:podosphere/team_profile_search.dart';

class FavTeamWidget extends StatefulWidget {
  final String teamId;

  const FavTeamWidget({
    Key? key,
    required this.teamId,
  }) : super(key: key);

  @override
  State<FavTeamWidget> createState() => _FavTeamWidgetState();
}

class _FavTeamWidgetState extends State<FavTeamWidget> {
  List<Map<String, dynamic>> profile = [];
  List<Map<String, dynamic>> nextFixture = [];
  Color dominantColor = Colors.grey.shade700;
  String? countryCode;

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
          fetchFlagCode(profile[0]['team']['country']);
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

  Future<void> fetchFlagCode(String country) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/countries?search=$country'),
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
          final countryCodeTemp = data['response'][0]['code'];
          {
            setState(() {
              countryCode = countryCodeTemp;
            });
          }
        } else {
          throw Exception('No data');
        }
      } else {
        throw Exception('Failed to load flag code');
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
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamProfile(
              teamId: profile[0]['team']['id'],
              logo: profile[0]['team']['logo'],
              teamName: profile[0]['team']['name'],
              flag: countryCode.toString(),
            ),
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              // Set dialog properties here
              child: TeamProfileSearch(
                teamId: profile[0]['team']['id'],
                logo: profile[0]['team']['logo'],
                teamName: profile[0]['team']['name'],
              ),
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
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
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      profile[0]['team']['name'],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (countryCode != null)
                      Image.asset(
                        'assets/images/$countryCode.png',
                        width: 25,
                      )
                    else
                      Container(
                        color: Colors.white,
                        width: 25,
                        height: 25,
                      ),
                  ],
                )
              else
                const Text(
                  'No team information',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              if (nextFixture.isNotEmpty)
                Column(
                  children: [
                    const Text(
                      'Next fixture:',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      '${nextFixture[0]['teams']['home']['name']} - ${nextFixture[0]['teams']['away']['name']}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )
              else
                const Text(
                  'No upcoming fixture',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
