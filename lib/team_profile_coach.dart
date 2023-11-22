import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/coach_details_widget.dart';

class TeamProfileCoach extends StatefulWidget {
  final int teamId;

  const TeamProfileCoach({super.key, required this.teamId});

  @override
  State<TeamProfileCoach> createState() => _TeamProfileCoachState();
}

class _TeamProfileCoachState extends State<TeamProfileCoach> {
  List<Map<String, dynamic>> coach = [];
  @override
  void initState() {
    super.initState();
    fetchCoachProfile();
  }

  Future<void> fetchCoachProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://v3.football.api-sports.io/coachs?team=${widget.teamId}',
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
          final coachProfile = data['response'][0];
          setState(() {
            coach = [coachProfile];
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
    final coachData = coach;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 5.0), borderRadius: BorderRadius.circular(10.0)),
                child: CoachDetails(coachData: coachData),
              ),
            );
          },
        );
      },
      child: Container(
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
                            border:
                                Border.all(color: Colors.black, width: 5.0)),
                        child: Image.network(
                          coachData[0]['photo'],
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
                      coachData[0]['photo'],
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
                    '${coachData[0]['firstname']} ${coachData[0]['lastname']}',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                    softWrap: true, // Allow text to wrap to the next line
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Age: ${coachData[0]['age']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true, // Allow text to wrap to the next line
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Naionality: ${coachData[0]['nationality']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true, // Allow text to wrap to the next line
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Date of birth: ${coachData[0]['birth']['date']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    softWrap: true, // Allow text to wrap to the next line
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Place of birth: ${coachData[0]['birth']['country']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
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
    );
  }
}
