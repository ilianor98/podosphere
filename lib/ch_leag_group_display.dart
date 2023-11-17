import 'package:flutter/material.dart';

class ChampionsLeagueGroupDetail extends StatelessWidget {
  final String groupName;
  final List<Map<String, dynamic>> groupData;

  const ChampionsLeagueGroupDetail({super.key, required this.groupName, required this.groupData});

  @override
  Widget build(BuildContext context) {
    print(groupData);
    return Scaffold(
      backgroundColor: const Color(0xFF333333),
      appBar: AppBar(title: Text(groupName,style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),),
              backgroundColor: const Color(0xFF333333),),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Standings',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            
              Expanded(
                child: ListView.builder(
                  itemCount: groupData.length,
                  itemBuilder: (context, index) {
                    final team = groupData[index]['team'];
                    final points = groupData[index]['points'];
                  
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            team['logo'],
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            team['name'],
                            style: TextStyle(color: Colors.blue),
                          ),
                          Text(
                            '$points',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            SizedBox(height: 8.0,child: Container(height: 20, color: const Color(0xFF333333),)),
          ],
        ),
      ),
    );
  }
}