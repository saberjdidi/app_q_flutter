import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final fullName;
  final job;
  //final String job;
  final Color color;
  const TaskWidget({Key? key, required this.fullName, required this.job, required this.color}) : super(key: key);

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