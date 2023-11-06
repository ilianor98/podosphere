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

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, int> leagueMap = {
    'Premier League': 39,
    'La Liga': 140,
    'Bundesliga': 78,
    'Superleague 1': 197,
    // Add more leagues here
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
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
              Column(
                children: [
                  for (final leagueEntry in leagueMap.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Standings(
                                leagueId: leagueEntry.value,
                                champName: leagueEntry.key,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Center(
                            child: Text(
                              leagueEntry.key,
                              style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
