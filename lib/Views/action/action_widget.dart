import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/action/action_model.dart';
import '../../Utils/custom_colors.dart';

class ActionWidget extends StatelessWidget {
  final ActionModel actionModel;
  final Color color;
  const ActionWidget({Key? key, required this.actionModel, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(actionModel.date.toString());
    final langue = SharedPreference.getLangue();
    var dateCreation;
    if (langue == 'en') {
      dateCreation = DateFormat('MM/dd/yyyy').format(dt);
    } else if (langue == 'fr') {
      dateCreation = DateFormat('dd/MM/yyyy').format(dt);
    } else {
      dateCreation = DateFormat('dd/MM/yyyy').format(dt);
    }
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
                title: Text(
                    "Action N° ${actionModel.nAct} ${actionModel.online == 1 ? '' : '*'}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Brand-Regular",
                        fontSize: 15.0,
                        color: Colors.blue)),
                /*Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ReadMoreText(
                        "${actionModel.typeAct}",
                        style: TextStyle(
                            color: Color(0xFF3B465E),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular",
                            fontSize: 15.0),
                        //trimLines: 3,
                        trimLength: 20,
                        colorClickableText: CustomColors.bleuCiel,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'more',
                        trimExpandedText: 'less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.bleuCiel),
                      ),
                      Spacer(),
                      Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Text("${date}", style:
                        TextStyle(fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontFamily: "Brand-Bold",),),
                      ),
                    ],
                  ), */
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: ReadMoreText(
                        "Designation : ${actionModel.act}",
                        style: TextStyle(
                            color: Color(0xFF3B465E),
                            fontWeight: FontWeight.bold),
                        trimLines: 3,
                        colorClickableText: CustomColors.bleuCiel,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'more',
                        trimExpandedText: 'less',
                        moreStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.bleuCiel),
                      ),
                    ),
                    Text(
                      "Type : ${actionModel.typeAct}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Brand-Bold"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        "Source : ${actionModel.sourceAct}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: "Brand-Bold"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        "${'creation_date'.tr} : $dateCreation",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: "Brand-Bold"),
                      ),
                    ),
                    (actionModel.site == '' || actionModel.site == null)
                        ? Text('')
                        : Text(
                            "Site : ${actionModel.site}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontFamily: "Brand-Bold"),
                          ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
