import 'package:flutter/material.dart';
import 'package:podosphere/greek_standings.dart';
import 'package:podosphere/standings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final premierId = 39;
  final String prem = 'PREMIER LEAGUE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333), // Dark mode background color
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Column(
            children: [
              Text(
                'PODOSPHERE',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GreekStandingsPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0), // Side padding
                  padding: EdgeInsets.all(20.0), // Top padding
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the button
                    borderRadius: BorderRadius.circular(20.0), // Smooth corners
                  ),
                  child: Center(
                    child: Text(
                      'SUPERLEAGUE',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.blue, // Text color
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Standings(
                              leagueId: premierId,
                              champName: prem,
                            )),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0), // Side padding
                  padding: EdgeInsets.all(20.0), // Top padding
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the button
                    borderRadius: BorderRadius.circular(20.0), // Smooth corners
                  ),
                  child: Center(
                    child: Text(
                      '${prem}',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.blue, // Text color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
