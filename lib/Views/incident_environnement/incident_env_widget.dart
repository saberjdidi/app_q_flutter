import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/incident_environnement/incident_env_model.dart';
import '../../Utils/custom_colors.dart';

class IncidentEnvWidget extends StatelessWidget {
  final IncidentEnvModel model;
  const IncidentEnvWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime dt = DateTime.parse(model.dateDetect.toString());
    //final date = DateFormat('dd/MM/yyyy').format(dt);
    final status = model.statut;
    String message_status = '';
    Color color_status = Color(0xff898f97);

    switch (status) {
      case 0:
        message_status = "Non encore réalisée";
        color_status = Color(0xffd2430c);
        break;
      case 1:
        message_status = "En attente de validation";
        color_status = Color(0xff0da713);
        break;
      case 2:
        message_status = "Refusée";
        color_status = Color(0xffd00e38);
        break;
      case 3:
        message_status = "En attente de correction";
        color_status = Color(0xff6ace11);
        break;
      case 4:
        message_status = "En attente de décision";
        color_status = Color(0xff0f6fe5);
        break;
      case 5:
        message_status = "En attente de traitement";
        color_status = Color(0xff1aa0d5);
        break;
      case 6:
        message_status = "En attente de clôture";
        color_status = Color(0xffe5650f);
        break;
      case 7:
        message_status = "Clôturée";
        color_status = Color(0xffe00a23);
        break;
      case 8:
        message_status = "";
        color_status = Color(0xff898f97);
        break;
      default:
      message_status = "";
      color_status = Color(0xff898f97);
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
                title:  Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("Incident N° ${model.n} ${model.online == 1 ?'' :'*'}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Brand-Regular",
                            fontSize: 15.0,
                            color: Colors.blue)),),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(message_status, style:
                      TextStyle(fontWeight: FontWeight.bold,
                          color: color_status,
                          fontFamily: "Brand-Bold"),),
                    )
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
                            child: Text("${model.delaiTrait}", style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
                        ),

                        (model.lieu=="" || model.lieu==null) ? Text('')
                            : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('Lieu : ${model.lieu}', style: TextStyle(fontSize: 15,
                              fontStyle: FontStyle.normal, fontWeight: FontWeight.w400,
                              color: Color(0xFF18516C)),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "${model.incident}",
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
                    model.type == '' ? Text('')
                    : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Type : ${model.type}",
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

                    model.site == '' ? Text('')
                        : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Site : ${model.site}",
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
                            color: Color(0xff1d1e21),
                            fontFamily: "Brand-Bold"),
                      ),
                    ),

                    model.processus == '' ? Text('')
                        : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Processus : ${model.processus}",
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