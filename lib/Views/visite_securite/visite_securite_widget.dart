import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Models/visite_securite/visite_securite_model.dart';
import '../../Utils/custom_colors.dart';

class VisiteSecuriteWidget extends StatelessWidget {
  final VisiteSecuriteModel model;
  const VisiteSecuriteWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(model.dateVisite.toString());
    final date = DateFormat('dd/MM/yyyy').format(dt);

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
                title:  Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Reference ${model.id} ${model.online == 1 ?'' :'*'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular",
                            fontSize: 15.0,
                            color: Colors.blue)),),
                   /* Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(message_status, style:
                      TextStyle(fontWeight: FontWeight.bold,
                          color: color_status,
                          fontFamily: "Brand-Bold"),),
                    ) */
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  /*  Text("${model.nc}", style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),*/
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                            child: Text("${date}", style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
                        ),

                        (model.site=="" || model.site==null) ? Text('')
                            : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('Site : ${model.site}', style: TextStyle(fontSize: 15,
                              fontStyle: FontStyle.normal, fontWeight: FontWeight.w500,
                              color: Color(0xFF18516C)),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Zone : ${model.zone}",
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Unite : ${model.unite}",
                        style: TextStyle(
                            color: Color(0xFF3B465E),
                            fontWeight: FontWeight.bold),
                        trimLines: 2,
                        colorClickableText: CustomColors.bleuCiel,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'more',
                        trimExpandedText: 'less',
                        moreStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4f515a),
                            fontFamily: "Brand-Bold"),
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}