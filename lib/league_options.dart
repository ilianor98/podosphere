import 'package:flutter/material.dart';
import 'package:podosphere/ch_leag_display.dart';
import 'package:podosphere/league_history.dart';
import 'package:podosphere/league_teams.dart';
import 'package:podosphere/standings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeagueOptions extends StatelessWidget {
  final int leagueId;
  final String leagueName;
  final String logo;
  final String flag;

  LeagueOptions(
      {required this.leagueId,
      required this.leagueName,
      required this.logo,
      required this.flag});

  final int currentSeason = 2023;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF333333), // Set the app bar background color
        leading: IconButton(
          onPressed: () {
            // Handle going back to the homepage
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.green),
        ),
        title: Row(
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/$logo',
                width: 50, // Adjust the width as needed
                height: 50, // Adjust the height as needed
              ),
            ),
            SizedBox(width: 16.0),
            Text(
              '$leagueName',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.green,
              ),
            ),
            SizedBox(width: 16.0),
            SvgPicture.network(
              '$flag',
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
                color: const Color(0xFF333333),
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
                color: const Color(0xFF333333),
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
                color: const Color(0xFF333333),
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
                color: const Color(0xFF333333),
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
            ),),
      ),
    );
  }
}
