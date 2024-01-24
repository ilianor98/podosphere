import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podosphere/ch_leag_display.dart';
import 'package:podosphere/league_history.dart';
import 'package:podosphere/league_teams.dart';
import 'package:podosphere/standings.dart';

class LeagueOptionsFav extends StatelessWidget {
  final int leagueId;
  final String leagueName;
  final String logo;
  final String flag;

  LeagueOptionsFav(
      {required this.leagueId,
      required this.leagueName,
      required this.logo,
      required this.flag});

  final int currentSeason = 2023;

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
            Container(color: Colors.white, child: loadImage(logo)),
            SizedBox(width: 16.0),
            Text(
              '$leagueName',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.0),
            Image.asset(
              'assets/images/$flag.png',
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16.0),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        // Handle the "Current Season" option
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Standings(
                              leagueId: leagueId,
                              champName: leagueName,
                              season: currentSeason,
                            ),
                          ),
                        );
                      },
                      child: Center(
                        child: Text('Current Season',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeagueHistory(
                              leagueId: leagueId,
                              leagueName: leagueName,
                              logo: logo,
                              flag: flag,
                            ),
                          ),
                        );
                        // You can navigate to a page that lists older seasons for the selected league here
                      },
                      child: Center(
                        child: Text('League History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeagueTeams(
                              leagueId: leagueId,
                              champName: leagueName,
                              season: currentSeason,
                              flag: flag,
                              logo: logo,
                            ),
                          ),
                        );
                        // You can navigate to a page that lists older seasons for the selected league here
                      },
                      child: Center(
                        child: Text('League Teams',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade700,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChampionsLeagueDisplay(),
                          ),
                        );
                        // You can navigate to a page that lists older seasons for the selected league here
                      },
                      child: Center(
                        child: Text('test chou lou',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            )),
                      ),
                    ),
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
