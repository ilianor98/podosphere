import 'package:flutter/material.dart';
import 'package:podosphere/standings.dart';

class LeagueOptions extends StatelessWidget {
  final int leagueId;
  final String leagueName;

  LeagueOptions({required this.leagueId, required this.leagueName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333), // Set the background color
      appBar: AppBar(
        title: Text('$leagueName Options',
            style: TextStyle(
                color: Colors.white)), // Display the league name in the title
        backgroundColor:
            const Color(0xFF333333), // Set app bar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue, // Set button background color
                borderRadius: BorderRadius.circular(20.0),
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
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text('Current Season',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 16.0), // Add some spacing
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.blue, // Set button background color
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GestureDetector(
                onTap: () {
                  // Handle the "League History" option
                  // You can navigate to a page that lists older seasons for the selected league here
                },
                child: Center(
                  child: Text('League History',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
