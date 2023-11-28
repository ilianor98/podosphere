import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:podosphere/team_details.dart';

class Standings extends StatefulWidget {
  final int leagueId;
  final String champName;
  final int season;
  Standings(
      {required this.leagueId, required this.champName, required this.season});

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
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700, // Dark mode background color
        title:
            Text('${widget.champName}', style: TextStyle(color: Colors.white)),
        centerTitle: true, // Center-align the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 19,),
                  Flexible(flex: 1, fit: FlexFit.tight,child: Text('#', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 1,fit: FlexFit.tight,child: SizedBox(),),
                  SizedBox(width: 5,),
                  Flexible(flex: 6,fit: FlexFit.tight,child: Text('Team', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 1,fit: FlexFit.tight,child: Text('GP', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 1,fit: FlexFit.tight,child: Text('GW', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 1,fit: FlexFit.tight,child: Text('GD', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 1,fit: FlexFit.tight,child: Text('GL', style: TextStyle(color: Colors.white),),),
                  Flexible(flex: 2,fit: FlexFit.tight,child: Text('Points', style: TextStyle(color: Colors.white),),),
                ],
              ),
                Expanded(
                  child: ListView.builder(
                    itemCount: standingsData.length,
                    itemBuilder: (context, index) {
                      final teamData = standingsData[index];
                      return StandingsItem(
                        teamData: teamData,
                        season: widget.season,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

class StandingsItem extends StatelessWidget {
  final Map<String, dynamic> teamData;
  final int season;

  StandingsItem({required this.teamData, required this.season});

  void navigateToTeamDetails(BuildContext context, int teamId, String teamName) {
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
    final logo = teamData['team']['logo'];
    final rank = teamData['rank'];
    final points = teamData['points'];
    final goalsFor = teamData['all']['goals']['for'];
    final goalsAgainst = teamData['all']['goals']['against'];
    final teamId = teamData['team']['id'];
    final form = teamData['form'];
    final gamesPlayed = teamData['all']['played'];
    final gamesWon = teamData['all']['win'];
    final gamesDraw = teamData['all']['draw'];
    final gamesLost = teamData['all']['lose'];

    return GestureDetector(
      onDoubleTap: () {
        navigateToTeamDetails(context, teamId, teamName);
      },
      child: Column(
        children: [
          ExpansionTile(
            
            title: Row(
              children: [
                Flexible(flex: 1, fit: FlexFit.tight,child: Text('${rank}', style: TextStyle(color: Colors.white),),),
                Flexible(flex: 1,fit: FlexFit.tight,child: loadImage(logo),),
                SizedBox(width: 5,),
                Flexible(flex: 6,fit: FlexFit.tight,child: Text('${teamName}', style: TextStyle(color: Colors.white),),),
                Flexible(flex: 1,fit: FlexFit.tight,child: Text('${gamesPlayed}', style: TextStyle(color: Colors.white),),),
                Flexible(flex: 1,fit: FlexFit.tight,child: Text('${gamesWon}', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),
                Flexible(flex: 1,fit: FlexFit.tight,child: Text('${gamesDraw}', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),
                Flexible(flex: 1,fit: FlexFit.tight,child: Text('${gamesLost}', style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),),
                
              ],
            ),
            trailing: Text('$points', style: TextStyle(color: Colors.white,fontSize: 17 ,fontWeight: FontWeight.bold),),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'GF: $goalsFor - GA: $goalsAgainst',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 10), // Adjust spacing if needed
                Row(
                  children: [
                    Text('Form: ', style: TextStyle(color: Colors.white),),
                    FormDisplay(form: form),
                  ],
                ),
              ],
            ),
            ],
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
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}