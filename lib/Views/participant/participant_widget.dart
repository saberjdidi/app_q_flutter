import 'package:flutter/material.dart';

class ParticipantWidget extends StatelessWidget {
  final String fullName;
  final String job;
  final Color color;
  const ParticipantWidget({Key? key, required this.fullName, required this.job, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
              shadowColor: Color(0xFFedf0f8),
         /* child: Container(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height/14,
            decoration: BoxDecoration(
                color: Color(0xFFedf0f8),
                borderRadius: BorderRadius.circular(0)
            ),*/
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: ListTile(
                      title: Text("${fullName}"),
                      subtitle: Text("${job}"),
                    )
                )
              ],
            ),
      );
  }
}