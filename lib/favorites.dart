import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/favorite_team_widget.dart';
import 'package:podosphere/team_profile_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final TextEditingController _leagueIdController = TextEditingController();
  List<String> _savedLeagueIds = [];
  List<String> _savedTeamIds = [];

  @override
  void initState() {
    super.initState();
    _loadSavedLeagueIds();
    _loadSavedTeamIds();
  }

  Future<void> _loadSavedLeagueIds() async {
    final savedIds = await FavoritesManager.getFavoriteLeagueIds();
    setState(() {
      _savedLeagueIds = savedIds;
    });
  }

  Future<void> _addToFavorites() async {
    final leagueId = _leagueIdController.text;
    await FavoritesManager.addToFavoriteLeagues(leagueId);
    _leagueIdController.clear();
    await _loadSavedLeagueIds();
  }

  Future<List<dynamic>> _searchTeams(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api-football-v1.p.rapidapi.com/v3/teams?search=$query'),
      headers: {
        'x-rapidapi-key': '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
        'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
        'useQueryString': 'true',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['response'];
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<List<dynamic>> _searchLeagues(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://api-football-v1.p.rapidapi.com/v3/leagues?search=$query'),
      headers: {
        'x-rapidapi-key': '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
        'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
        'useQueryString': 'true',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['response'];
    } else {
      throw Exception('Failed to load leagues');
    }
  }

  Widget loadImage(String url) {
    int retryCount = 0;
    const int maxRetries = 2;

    return Image.network(
      url,
      width: 30,
      height: 30,
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

  Future<void> _showSearchDialog() async {
    String? selectedType;
    String? searchText;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Search Teams/Leagues'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      DropdownButton<String>(
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'teams',
                            child: Text('Search Teams'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'leagues',
                            child: Text('Search Leagues'),
                          ),
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        value: selectedType,
                        hint: const Text('Select Type'),
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (String value) {
                            searchText = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter search query',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (selectedType != null && searchText != null) {
                        List<dynamic> results = [];
                        if (selectedType == 'teams') {
                          results = await _searchTeams(searchText!);
                          _showTeamResultsDialog(context, results);
                        } else if (selectedType == 'leagues') {
                          results = await _searchLeagues(searchText!);
                          _showLeagueResultsDialog(context, results);
                        }
                      }
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      // Refresh the favorites screen after closing the dialog
      _loadSavedTeamIds();
    });
  }

  void _showTeamResultsDialog(BuildContext context, List<dynamic> teams) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Results - Teams'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: teams.length,
              itemBuilder: (BuildContext context, int index) {
                final teamName = teams[index]['team']['name'];
                final teamLogo = teams[index]['team']['logo'];
                final teamId = teams[index]['team']['id'];

                return ListTile(
                  title: Row(
                    children: [
                      loadImage(teamLogo),
                      Expanded(
                        child: Text(
                          teamName,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the current dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          // Set dialog properties here
                          child: TeamProfileSearch(
                            teamId: teamId,
                            logo: teamLogo,
                            teamName: teamName,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showLeagueResultsDialog(BuildContext context, List<dynamic> leagues) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Results - Leagues'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: leagues.length,
              itemBuilder: (BuildContext context, int index) {
                final leagueName = leagues[index]['league']['name'];
                final leagueLogo = leagues[index]['league']['logo'];
                return ListTile(
                  title: Row(
                    children: [
                      loadImage(leagueLogo),
                      Text(leagueName),
                    ],
                  ),
                  onTap: () {
                    // Handle tap on the searched league
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadSavedTeamIds() async {
    final savedIds = await FavoritesManager.getFavoriteTeamIds();
    setState(() {
      _savedTeamIds = savedIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: const Text(
          'Favorites',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showSearchDialog,
            icon: const Icon(Icons.search_sharp),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Column(
                  children: [
                    const Text(
                      'Favorite teams',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    if (_savedTeamIds.isEmpty)
                      const Expanded(
                        child: Text(
                          'No favorite teams',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      Column(
                        children: _savedTeamIds.map((teamId) {
                          return FavTeamWidget(
                            key: Key(teamId),
                            teamId: teamId,
                            onRemove: () {
                              // Remove from favorites and update state
                              _removeFromFavorites(teamId);
                            },
                          );
                        }).toList(),
                      )
                  ],
                ),
                const Column(
                  children: [
                    Text(
                      'Favorite Leagues',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'test1',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'test2',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to remove a team from favorites and update state
  Future<void> _removeFromFavorites(String teamId) async {
    await FavoritesManager.removeFromFavoriteTeams(teamId);
    await _loadSavedTeamIds(); // Refresh saved team IDs after removal
  }
}

class FavoritesManager {
  static const _leagueKey = 'favorite_league_ids';
  static const _teamKey = 'favorite_team_ids';

  static Future<List<String>> getFavoriteLeagueIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_leagueKey) ?? [];
    return favoriteIds;
  }

  static Future<void> addToFavoriteLeagues(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_leagueKey) ?? [];
    favoriteIds.add(id);
    await prefs.setStringList(_leagueKey, favoriteIds);
  }

  static Future<void> removeFromFavoriteLeagues(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_leagueKey) ?? [];
    favoriteIds.remove(id);
    await prefs.setStringList(_leagueKey, favoriteIds);
  }

  static Future<List<String>> getFavoriteTeamIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_teamKey) ?? [];
    return favoriteIds;
  }

  static Future<void> addToFavoriteTeams(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_teamKey) ?? [];
    favoriteIds.add(id);
    await prefs.setStringList(_teamKey, favoriteIds);
  }

  static Future<void> removeFromFavoriteTeams(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList(_teamKey) ?? [];
    favoriteIds.remove(id);
    await prefs.setStringList(_teamKey, favoriteIds);
  }

  // Check if a team ID exists in favorites
  static Future<bool> isTeamInFavorites(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_teamKey) ?? [];
    return favoriteIds.contains(id);
  }

  // Check if a league ID exists in favorites
  static Future<bool> isLeagueInFavorites(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_leagueKey) ?? [];
    return favoriteIds.contains(id);
  }
}
