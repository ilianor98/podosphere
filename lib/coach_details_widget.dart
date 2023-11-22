import 'package:flutter/material.dart';

class CoachDetails extends StatelessWidget {
  final List<Map<String, dynamic>> coachData;

  const CoachDetails({super.key, required this.coachData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF333333),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 5.0)),
                              child: Image.network(
                                coachData[0]['photo'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                            coachData[0]['photo'],
                          ),
                          fit: BoxFit.fill,
                        ),
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
                          '${coachData[0]['firstname']} ${coachData[0]['lastname']}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                          softWrap: true, // Allow text to wrap to the next line
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Age: ${coachData[0]['age']}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true, // Allow text to wrap to the next line
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Naionality: ${coachData[0]['nationality']}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true, // Allow text to wrap to the next line
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Date of birth: ${coachData[0]['birth']['date']}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                          softWrap: true, // Allow text to wrap to the next line
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Place of birth: ${coachData[0]['birth']['country']}',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                  child: Text(
                'Career',
                style: TextStyle(color: Colors.white),
              )),
              SizedBox(
                height: 5,
              ),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                },
                children: [
                  for (final careerItem in coachData[0]['career'])
                    TableRow(
                      children: [
                        TableCell(
                          child: CoachHistoryTeam(
                            team: careerItem,
                          ),
                        ),
                      ],
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

class CoachHistoryTeam extends StatelessWidget {
  final Map<String, dynamic> team;

  const CoachHistoryTeam({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: Image.network(
            team['team']['logo'],
            height: 40,
            width: 40,
          ),
        ),
        SizedBox(width: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${team['team']['name']}',
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            SizedBox(height: 5),
            Text(
              'Coached: ${team['start']} - ${team['end'] ?? 'Present'}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}
