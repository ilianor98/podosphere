import 'package:flutter/material.dart';

class TeamProfileVenue extends StatelessWidget {
  final String logo;
  final String teamName;
  final String flag;
  final List<Map<String, dynamic>> profileData;

  const TeamProfileVenue(
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
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 5.0)),
                      child: Image.network(
                        profileData[0]['venue']['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              child: Image.network(
                profileData[0]['venue']['image'],
                height: 75,
                width: 75,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profileData[0]['venue']['name']}',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  softWrap: true, // Allow text to wrap to the next line
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Address: ${profileData[0]['venue']['address']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  softWrap: true, // Allow text to wrap to the next line
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City: ${profileData[0]['venue']['city']}',
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
                  'Capacity: ${profileData[0]['venue']['capacity']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Surface: ${profileData[0]['venue']['surface']}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
