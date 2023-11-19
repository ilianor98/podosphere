import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/match_details.dart';

class TeamDetailsPage extends StatefulWidget {
  final int teamId;
  final int season;
  final String teamName;

  const TeamDetailsPage(
      {super.key, required this.teamId, required this.season, required this.teamName});

  @override
  _TeamDetailsPageState createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  List<Map<String, dynamic>> matches = [];

  @override
  void initState() {
    super.initState();
    fetchTeamMatches();
  }

  String parseDate(String date) {
    // Parse the date string and format it as "day/month/year"
    final parsedDate = DateTime.parse(date);
    final formattedDate =
        "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
    return formattedDate;
  }

  Future<void> fetchTeamMatches() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?season=${widget.season}&team=${widget.teamId}'),
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
          final teamMatches = data[
              'response']; // Adjust this to the actual path in the API response

          // Sort matches based on date
          teamMatches.sort((a, b) {
            final matchDateA = DateTime.parse(a['fixture']['date']);
            final matchDateB = DateTime.parse(b['fixture']['date']);
            return matchDateA.compareTo(matchDateB);
          });

          setState(() {
            matches = List<Map<String, dynamic>>.from(teamMatches);
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
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: const Color(0xFF333333),
        title: Text('${widget.teamName} Match History', style: TextStyle(color: Colors.green),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(10.0)),
          child: matches.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final matchData = matches[index];
                    return FixtureItem(matchData: matchData);
                  },
                ),
        ),
      ),
    );
  }

}

class FixtureItem extends StatelessWidget {
  final Map<String, dynamic> matchData;

  const FixtureItem({Key? key, required this.matchData}) : super(key: key);

  String parseDate(String date) {
    final parsedDate = DateTime.parse(date);
    return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
  }

  void navigateToMatchDetails(
      int fixtureId, int scoreHome, int scoreAway, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetails(
          fixtureId: fixtureId,
          scoreHome: scoreHome,
          scoreAway: scoreAway,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fixture = matchData['fixture'];
    final teams = matchData['teams'];
    final goals = matchData['goals'];
    final score = matchData['score'];

    final homeTeam = teams['home'];
    final awayTeam = teams['away'];
    final matchDate = parseDate(fixture['date']);

    final homeGoals = goals['home'];
    final awayGoals = goals['away'];
    final isNullScore = homeGoals == null && awayGoals == null;

    return GestureDetector(
      onTap: () {
        navigateToMatchDetails(
          fixture['id'],
          score['fulltime']['home'],
          score['fulltime']['away'],
          context,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      homeTeam['logo'],
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      homeTeam['name'],
                      style: TextStyle(color: Colors.white), textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isNullScore ? matchDate : '$homeGoals - $awayGoals',
                      style: TextStyle(fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isNullScore ? Colors.grey : Colors.white,
                      ),textAlign: TextAlign.center,
                    ),
                    if (!isNullScore)
                      Column(
                        children: [
                          SizedBox(height: 4),
                          Text(
                            matchDate,
                            style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    Text(
                      matchData['league']['name'],
                      style: TextStyle(color: Colors.grey),textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      awayTeam['logo'],
                      width: 40,
                      height: 40,
                    ),
                    Text(
                      awayTeam['name'],
                      style: TextStyle(color: Colors.white),textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

