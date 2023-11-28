import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podosphere/standings.dart';

class LeagueHistory extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  final String logo;
  final String flag;

  const LeagueHistory({super.key, required this.leagueId, required this.leagueName, required this.logo,
      required this.flag});

  @override
  State<LeagueHistory> createState() => _LeagueHistoryState();
}

class _LeagueHistoryState extends State<LeagueHistory> {
  List<dynamic> seasons = [];

  @override
  void initState() {
    super.initState();
    fetchSeasonsData();
  }

  Future<void> fetchSeasonsData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-football-v1.p.rapidapi.com/v3/leagues?id=${widget.leagueId}'),
        headers: {
          'X-Rapidapi-Key': '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['response'] is List && data['response'].isNotEmpty) {
          final leagueData = data['response'][0];
          setState(() {
            seasons = leagueData['seasons'];
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load seasons');
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
        backgroundColor:
            Colors.grey.shade700, // Set the app bar background color
        leading: IconButton(
          onPressed: () {
            // Handle going back to the homepage
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Row(
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/${widget.logo}',
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              widget.leagueName,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.0),
            SvgPicture.asset(
              'assets/images/${widget.flag}',
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          final season = seasons[index];
          final int seasonStand = season['year'];
          return GestureDetector(
            onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Standings(
                      leagueId: widget.leagueId,
                      champName: widget.leagueName,
                      season: seasonStand,
                    ),
                  ),
                );},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Center(
                  child: Text(
                    '${season['year']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

