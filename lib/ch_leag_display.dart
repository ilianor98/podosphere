import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ch_leag_group_widget.dart';

class ChampionsLeagueDisplay extends StatefulWidget {
  @override
  _ChampionsLeagueDisplayState createState() => _ChampionsLeagueDisplayState();
}

class _ChampionsLeagueDisplayState extends State<ChampionsLeagueDisplay> {
  List<List<Map<String, dynamic>>> groupData = [];
  List<String> groupNames = [
    'Group A',
    'Group B',
    'Group C',
    'Group D',
    'Group E',
    'Group F',
    'Group G',
    'Group H'
  ];

  @override
  void initState() {
    super.initState();
    fetchGroupData();
  }

  Future<void> fetchGroupData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api-football-v1.p.rapidapi.com/v3/standings?season=2023&league=2',
        ),
        headers: {
          'X-Rapidapi-Key':
              '532fd60bd5msh6da995865b23f7fp107e5cjsn25f04e7e813e',
          'X-Rapidapi-Host': 'api-football-v1.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null &&
            data['response'] is List &&
            data['response'].isNotEmpty) {
          groupData = List.generate(
            groupNames.length,
            (index) => List<Map<String, dynamic>>.from(
              data['response'][0]['league']['standings'][index],
            ),
          );
          setState(() {});
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load group data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

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
        title: Text(
          'Champions League Groups',
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.blue,
          ),
        ),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: groupNames.length,
        itemBuilder: (context, index) {
          final groupName = groupNames[index];
          final filteredData = groupData[index];
          return ChampionsLeagueGroupWidget(
            groupName: groupName,
            groupData: filteredData,
          );
        },
      ),
    );
  }
}
