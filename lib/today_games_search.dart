import 'package:flutter/material.dart';
import 'package:podosphere/games_by_leagues_search.dart';

class TodaySearch extends StatefulWidget {
  final List<Map<String, dynamic>> fixtures;

  const TodaySearch({
    Key? key,
    required this.fixtures,
  }) : super(key: key);

  @override
  State<TodaySearch> createState() => _TodaySearchState();
}

class _TodaySearchState extends State<TodaySearch> {
  late List<Map<String, dynamic>> filteredFixtures;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredFixtures = [];
  }

  void filterFixtures(String query) {
    setState(() {
      isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        filteredFixtures = widget.fixtures;
      } else {
        final Map<String, Map<String, dynamic>> uniqueLeagues = {};

        for (final fixture in widget.fixtures) {
          final leagueId = fixture['league']['id'].toString();
          final leagueName = fixture['league']['name'].toString().toLowerCase();
          final homeTeam =
              fixture['teams']['home']['name'].toString().toLowerCase();
          final awayTeam =
              fixture['teams']['away']['name'].toString().toLowerCase();
          final country = fixture['league']['country'].toString().toLowerCase();

          if (leagueId.isNotEmpty &&
              (leagueId.contains(query.toLowerCase()) ||
                  leagueName.contains(query.toLowerCase()) ||
                  homeTeam.contains(query.toLowerCase()) ||
                  awayTeam.contains(query.toLowerCase()) ||
                  country.contains(query.toLowerCase()))) {
            uniqueLeagues[leagueId] ??= fixture;
          }
        }

        filteredFixtures = uniqueLeagues.values.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        title: const Text(
          'Search for a fixture',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.grey.shade700,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                filterFixtures(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: isSearching
                ? filteredFixtures.isEmpty
                    ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Text(
                              'No fixtures today or leagues with that name',
                              style: TextStyle(color: Colors.white, fontSize: 24),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox()
                        ],
                      ),
                    )
                    : ListView.builder(
                        itemCount: filteredFixtures.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FixturesLeagueSearch(
                              leagueName: filteredFixtures[index]['league']
                                  ['name'],
                              leagueData: widget.fixtures,
                              leagueId: filteredFixtures[index]['league']['id'],
                              logo: filteredFixtures[index]['league']['logo'],
                              flag: filteredFixtures[index]['league']['flag']
                                  .toString(),
                              country: filteredFixtures[index]['league']
                                      ['country']
                                  .toString(),
                            ),
                          );
                        },
                      )
                : Container(),
          ),
        ],
      ),
    );
  }
}
