import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:podosphere/games_by_league.dart';
import 'package:podosphere/today_games_search.dart';

class TodayGames extends StatefulWidget {
  const TodayGames({Key? key});

  @override
  State<TodayGames> createState() => _TodayGamesState();
}

/*class LeagueInfo {
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
];*/

class _TodayGamesState extends State<TodayGames> {
  List<Map<String, dynamic>> fixtures = [];
  List<Map<String, dynamic>> apiLeagues =
      []; // Updated list to hold league information
  List<Map<String, dynamic>> visibleLeagues = [];
  ScrollController _scrollController = ScrollController();
  int loadedLeagues = 0;
  int leaguesPerPage = 7;

  @override
  void initState() {
    super.initState();
    fetchFixtures();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadNextLeagues();
    }
  }

  void _loadNextLeagues() {
    if (loadedLeagues < apiLeagues.length) {
      setState(() {
        final nextLeagues =
            apiLeagues.skip(loadedLeagues).take(leaguesPerPage).toList();
        visibleLeagues.addAll(nextLeagues);
        loadedLeagues += leaguesPerPage;
      });
    }
  }

  Future<void> fetchFixtures() async {
    String _formatDate(int value) {
      return value.toString().padLeft(2, '0');
    }

    final DateTime now = DateTime.now();
    final String todayDate =
        '${now.year}-${_formatDate(now.month)}-${_formatDate(now.day)}';

    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/fixtures?date=$todayDate&timezone=Europe/Athens'),
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
            fixtures = List<Map<String, dynamic>>.from(tempFixtures);
            updateLeagueList(fixtures); // Update the leagueList
            visibleLeagues = apiLeagues.take(leaguesPerPage).toList();
            loadedLeagues = leaguesPerPage;
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

  void updateLeagueList(List<Map<String, dynamic>> fixtures) {
    for (final fixture in fixtures) {
      final leagueId = fixture['league']['id'];
      final leagueName = fixture['league']['name'];
      final leagueLogo = fixture['league']['logo'];
      final leagueFlag = fixture['league']['flag'];
      final country = fixture['league']['country'];

      final existingLeague = apiLeagues.firstWhere(
        (league) => league['id'] == leagueId,
        orElse: () => <String, dynamic>{}, // Returns an empty map if not found
      );

      if (existingLeague.isEmpty) {
        // If league doesn't exist in the list, add it
        setState(() {
          apiLeagues.add({
            'name': leagueName,
            'logo': leagueLogo,
            'id': leagueId,
            'flag': leagueFlag,
            'country': country,
          });
          visibleLeagues =
              List<Map<String, dynamic>>.from(apiLeagues.take(loadedLeagues));
          //print(visibleLeagues);
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await fetchFixtures();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> visibleLeagues =
        loadedLeagues < apiLeagues.length
            ? apiLeagues.take(loadedLeagues).toList()
            : apiLeagues;
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: const Text(
          'Today\'s Fixtures',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 32,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodaySearch(fixtures: fixtures,)),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.white,
        backgroundColor: Colors.grey.shade700,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: visibleLeagues.length,
                itemBuilder: (BuildContext context, int index) {
                  final league = visibleLeagues[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FixturesLeague(
                      leagueName: league['name'],
                      leagueData: fixtures,
                      leagueId: league['id'],
                      logo: league['logo'],
                      flag: league['flag'].toString(),
                      country: league['country'].toString(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
