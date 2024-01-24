import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:podosphere/favorites.dart';
import 'package:podosphere/league_option_favorites.dart';

class FavLeagueWidget extends StatefulWidget {
  final String leagueId;
  const FavLeagueWidget({super.key, required this.leagueId});

  @override
  State<FavLeagueWidget> createState() => _FavLeagueWidgetState();
}

class _FavLeagueWidgetState extends State<FavLeagueWidget> {
  List<Map<String, dynamic>> league = [];
  String leagueLogo = '';
  String leagueFlag = '';
  String leagueName = '';
  String leagueCountry = '';
  int leagueIdInt = 0;

  @override
  void initState() {
    super.initState();
    fetchLeagueProfile();
  }

  Future<void> fetchLeagueProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api-football-v1.p.rapidapi.com/v3/leagues?id=${widget.leagueId.toString()}'),
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
          final leagueProfile = data['response'][0];
          setState(() {
            league = [leagueProfile];
            leagueLogo = league[0]['league']['logo'];
            leagueName = league[0]['league']['name'];
            leagueFlag = league[0]['country']['code'];
            leagueCountry = league[0]['country']['name'];
            leagueIdInt = int.parse(widget.leagueId);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load league info');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget loadImage(String url) {
    int retryCount = 0;
    const int maxRetries = 2;

    return CachedNetworkImage(
      imageUrl: url,
      width: 25,
      height: 25,
      placeholder: (context, url) => Image.asset(
        'assets/images/football-load.gif',
        width: 25,
        height: 25,
      ),
      errorWidget: (context, url, error) {
        if (retryCount < maxRetries) {
          retryCount++;
          return loadImage(url); // Retry loading the image
        } else {
          return const SizedBox(
            width: 25,
            height: 25,
          ); // Return an empty SizedBox after max retries
        }
      },
    );
  }

  void _showRemoveConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade700,
          title: Text(
            "Remove League",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Do you want to remove this league from favorites?",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                removeFromFavorites();
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Remove",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void removeFromFavorites() async {
    try {
      await FavoritesManager.removeFromFavoriteLeagues(widget.leagueId);
      // Optionally, you can update the UI or perform other actions after removal.
    } catch (e) {
      print("Error removing from favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeagueOptionsFav(
              leagueId: leagueIdInt,
              leagueName: leagueName,
              logo: leagueLogo,
              flag: leagueFlag,
            ),
          ),
        );
      },
      onLongPress: () {
        _showRemoveConfirmationDialog();
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            children: [
              LeagueRow(
                  leagueName: leagueName,
                  leagueFlag: leagueFlag,
                  leagueLogo: leagueLogo),
              Text(leagueCountry,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}

class LeagueRow extends StatelessWidget {
  final String leagueName;
  final String leagueFlag;
  final String leagueLogo;

  const LeagueRow({
    super.key,
    required this.leagueName,
    required this.leagueFlag,
    required this.leagueLogo,
  });

  Widget loadImage(String url) {
    int retryCount = 0;
    const int maxRetries = 2;

    return CachedNetworkImage(
      imageUrl: url,
      width: 25,
      height: 25,
      placeholder: (context, url) => Image.asset(
        'assets/images/football-load.gif',
        width: 25,
        height: 25,
      ),
      errorWidget: (context, url, error) {
        if (retryCount < maxRetries) {
          retryCount++;
          return loadImage(url); // Retry loading the image
        } else {
          return const SizedBox(
            width: 25,
            height: 25,
          ); // Return an empty SizedBox after max retries
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (leagueFlag == 'null') {
      return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10.0,
            ),
            Container(color: Colors.white, child: loadImage(leagueLogo)),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              leagueName,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              softWrap: true,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Container(color: Colors.white, child: loadImage(leagueLogo)),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10.0,
            ),
            Container(color: Colors.white, child: loadImage(leagueLogo)),
            const SizedBox(
              width: 10.0,
            ),
            Text(
              leagueName,
              style: const TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              softWrap: true,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Image.asset(
              'assets/images/$leagueFlag.png',
              height: 25,
              width: 25,
            ),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
      );
    }
  }
}
