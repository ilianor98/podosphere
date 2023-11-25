import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:podosphere/games_by_league.dart';

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
    name: 'UEFA Champions\nLeague',
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
      Uri.parse('https://api-football-v1.p.rapidapi.com/v3/fixtures?date=$todayDate&timezone=Europe/Athens'),
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

  Future<void> _refreshData() async {
    await fetchFixtures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.green,
      appBar: AppBar(
        title: const Text('Today\'s Fixtures', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),),
        backgroundColor: const Color(0xFF333333),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.green,
        backgroundColor: const Color(0xFF333333),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: leagueList.map((league) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FixturesLeague(
                      leagueName: league.name,
                      leagueData: fixtures,
                      leagueId: league.id,
                      logo: league.logo,
                      flag: league.flag,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}