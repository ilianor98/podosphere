import 'package:flutter/material.dart';

class TeamProfileBanner extends StatelessWidget {
  final String logo;
  final String teamName;
  final String flag;
  final List<Map<String, dynamic>> profileData;

  const TeamProfileBanner(
      {super.key,
      required this.logo,
      required this.teamName,
      required this.profileData,
      required this.flag});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Container(
              child: Image.network(
            logo,
            height: 75,
            width: 75,
          )),
          const SizedBox(
            width: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${profileData[0]['team']['name']} - [${profileData[0]['team']['code']}]',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Country: ${profileData[0]['team']['country']}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/images/$flag.png',
                    height: 12,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Founded: ${profileData[0]['team']['founded']}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                'Team ID: ${profileData[0]['team']['id']}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
