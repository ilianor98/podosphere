import 'package:flutter/material.dart';
import 'package:podosphere/ch_leag_group_display.dart';

class ChampionsLeagueGroupWidget extends StatelessWidget {
  final String groupName;
  final List<Map<String, dynamic>> groupData;

  ChampionsLeagueGroupWidget({Key? key, required this.groupName, required this.groupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChampionsLeagueGroupDetail(
                      groupName: groupName,
                      groupData: groupData,
                    ),
                  ),
                )
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              groupName,
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
          ],
        ),
      ),
    );
  }
}
