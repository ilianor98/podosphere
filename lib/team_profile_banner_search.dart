import 'package:flutter/material.dart';

class TeamProfileBannerSearch extends StatelessWidget {
  final  teamId;
  final  logo;
  final  teamName;
  final List<Map<String, dynamic>> profileData;

  const TeamProfileBannerSearch(
      {super.key,
      required this.teamId,
      required this.logo,
      required this.teamName,
      required this.profileData,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
              child: Image.network(
            logo,
            height: 75,
            width: 75,
          )),
          SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profileData[0]['team']['name']} [${profileData[0]['team']['code']}]',
                style: TextStyle(color: Colors.white, fontSize: 20),
                softWrap: true,
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Country: ${profileData[0]['team']['country']}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Text(
                    'Founded: ${profileData[0]['team']['founded']}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 5,),
              Text(
                    'Team ID: ${profileData[0]['team']['id']}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
