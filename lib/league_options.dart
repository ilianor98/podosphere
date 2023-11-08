import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF333333), // Set the app bar background color
        leading: IconButton(
          onPressed: () {
            // Handle going back to the homepage
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.blue),
        ),
        title: Row(
          children: [
            Image.network(
              '$logo',
              width: 50, // Adjust the width as needed
              height: 50, // Adjust the height as needed
            ),
            SizedBox(width: 16.0),
            Text(
              '$leagueName',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.blue,
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
      body: Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
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
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                    )),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: GestureDetector(
              onTap: () {
                // Handle the "League History" option
                // You can navigate to a page that lists older seasons for the selected league here
              },
              child: Center(
                child: Text('League History',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
