import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/team_profile_banner.dart';
import 'package:podosphere/team_profile_coach.dart';
import 'package:podosphere/team_profile_squad.dart';
import 'package:podosphere/team_profile_venue.dart';

class TeamProfile extends StatefulWidget {
  final int teamId;
  final String logo;
  final String teamName;
  final String flag;

  const TeamProfile(
      {super.key,
      required this.teamId,
      required this.logo,
      required this.teamName,
      required this.flag});

  @override
  State<TeamProfile> createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {
  List<Map<String, dynamic>> profile = [];

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
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          '${widget.teamName} Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: TeamProfileBanner(
                teamName: widget.teamName,
                flag: widget.flag,
                logo: widget.logo,
                profileData: profile,
              )),
              SizedBox(
                height: 15,
              ),
              Container(
                  child: TeamProfileVenue(
                teamName: widget.teamName,
                flag: widget.flag,
                logo: widget.logo,
                profileData: profile,
              )),
              SizedBox(
                height: 15,
              ),
              Container(child: TeamProfileCoach(teamId: widget.teamId)),
              SizedBox(
                height: 15,
              ),
              Container(child: TeamProfileSquad(teamId: widget.teamId)),
            ],
          ),
        ),
      ),
    );
  }
}
