import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class LeagueInfo {
  final String name;
  final String logo;
  final int id;
  final String flag;

  LeagueInfo(
      {required this.name,
      required this.logo,
      required this.id,
      required this.flag});
}

final List<LeagueInfo> leagueList = [
  LeagueInfo(
    name: 'Premier League',
    logo: 'logo_39.png',
    id: 39,
    flag: 'flag_gb.svg',
  ),
  LeagueInfo(
    name: 'La Liga',
    logo: 'logo_140.png',
    id: 140,
    flag: 'flag_es.svg',
  ),
  LeagueInfo(
    name: 'Bundesliga',
    logo: 'logo_78.png',
    id: 78,
    flag: 'flag_de.svg',
  ),
  LeagueInfo(
    name: 'Superleague 1',
    logo: 'logo_197.png',
    id: 197,
    flag: 'flag_gr.svg',
  ),
  LeagueInfo(
    name: 'Ligue 1',
    logo: 'logo_61.png',
    id: 61,
    flag: 'flag_fr.svg',
  ),
  LeagueInfo(
    name: 'Serie A',
    logo: 'logo_135.png',
    id: 135,
    flag: 'flag_it.svg',
  ),
  LeagueInfo(
    name: 'Eredivisie',
    logo: 'logo_88.png',
    id: 88,
    flag: 'flag_nl.svg',
  ),
  LeagueInfo(
    name: 'Jupiler Pro',
    logo: 'logo_144.png',
    id: 144,
    flag: 'flag_be.svg',
  ),
  LeagueInfo(
    name: 'UEFA Champions League',
    logo: 'logo_2.png',
    id: 2,
    flag: 'null',
  ),
  LeagueInfo(
    name: 'UEFA Europa League',
    logo: 'logo_3.png',
    id: 3,
    flag: 'null',
  ),
  // Add more leagues here
];

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> fixtures = [];

  @override
  void initState() {
    super.initState();
    fetchFixtures();
  }

  Future<void> fetchFixtures() async {
    String _formatDate(int value) {
  return value.toString().padLeft(2, '0');
}

    final DateTime now = DateTime.now();
    final String todayDate = '${now.year}-${_formatDate(now.month)}-${_formatDate(now.day)}';

    try{
    final response = await http.get(
      Uri.parse('https://api-football-v1.p.rapidapi.com/v3/fixtures?date=$todayDate'),
      headers: {
        'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
        'x-rapidapi-key': '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
      },
    );

    if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
      final tempFixtures = data['response'];
      setState(() {
            fixtures = List<Map<String, dynamic>>.from(tempFixtures);
          });
      print(fixtures);
      
    } else  {
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
        title: Text('Today\'s Fixtures'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                for (final league in leagueList)
                  Container(
                    
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(10.0),
              ),
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            Text(league.name, textAlign: TextAlign.center,),
                            
                          ],
                        ),
                        for (final fixture in fixtures)
                          if (fixture['league']['id'] == league.id)
                            TableRow(children: [
                              Text(
                                  '${fixture['teams']['home']['name']} vs ${fixture['teams']['away']['name']}'),
                              Text(
                                  'Time: ${fixture['fixture']['date'].split('T')[1].substring(0, 5)} | Score: ${fixture['score']['fulltime']['home']} - ${fixture['score']['fulltime']['away']}'),
                      ],),
                      ],
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
