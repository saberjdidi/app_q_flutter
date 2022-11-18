import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/shared_preference.dart';

class IncidentSecuriteWidget extends StatelessWidget {
  final IncidentSecuriteModel model;
  const IncidentSecuriteWidget({Key? key, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? langue = SharedPreference.getLangue();
    DateTime dt = DateTime.parse(model.dateInc.toString());
    var date;
    if (langue == 'fr') {
      date = DateFormat('dd/MM/yyyy').format(dt);
    } else if (langue == 'en') {
      date = DateFormat('MM/dd/yyyy').format(dt);
    } else {
      date = DateFormat('dd/MM/yyyy').format(dt);
    }
    final status = model.statut;
    String message_status = '';
    Color color_status = Color(0xff898f97);
    switch (status) {
      case 0:
        message_status = 'non_encore_realise'.tr;
        color_status = Color(0xffd2430c);
        break;
      case 1:
        message_status = 'en_attente_de_validation'.tr;
        color_status = Color(0xff0da713);
        break;
      case 2:
        message_status = 'fiche_refuse'.tr;
        color_status = Color(0xffd00e38);
        break;
      case 3:
        message_status = 'en_attente_de_correction'.tr;
        color_status = Color(0xff6ace11);
        break;
      case 4:
        message_status = 'en_attente_de_decision'.tr;
        color_status = Color(0xff0f6fe5);
        break;
      case 5:
        message_status = 'en_attente_de_traitement'.tr;
        color_status = Color(0xff1aa0d5);
        break;
      case 6:
        message_status = 'en_attente_de_cloture'.tr;
        color_status = Color(0xffe5650f);
        break;
      case 7:
        message_status = 'cloture'.tr;
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
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                          "Reference ${model.ref} ${model.online == 1 ? '' : '*'}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand-Regular",
                              fontSize: 15.0,
                              color: Colors.blue)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        message_status,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color_status,
                            fontFamily: "Brand-Bold"),
                      ),
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
                          child: Text(
                            "${date}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontFamily: "Brand-Bold"),
                          ),
                        ),

                        /* (model.typeIncident=="" || model.typeIncident==null) ? Text('')
                            : Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('Type : ${model.typeIncident}', style: TextStyle(fontSize: 15,
                              fontStyle: FontStyle.normal, fontWeight: FontWeight.w400,
                              color: Color(0xFF18516C)),),
                        ), */
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "${model.designation}",
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
                        "Type : ${model.typeIncident}",
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
                    (model.site == '' || model.site == null)
                        ? Text('')
                        : Padding(
                            padding: (model.site == '' || model.site == null)
                                ? const EdgeInsets.only(top: 0)
                                : const EdgeInsets.only(top: 5.0),
                            child: Text("Site : ${model.site}",
                                style: TextStyle(
                                    color: Color(0xFF3B465E),
                                    fontWeight: FontWeight.w500)),
                          ),
                    (model.gravite == '' || model.gravite == null)
                        ? Text('')
                        : Padding(
                            padding:
                                (model.gravite == '' || model.gravite == null)
                                    ? const EdgeInsets.only(top: 0)
                                    : const EdgeInsets.only(top: 5.0),
                            child: Text("${'gravity'.tr} : ${model.gravite}",
                                style: TextStyle(
                                    color: Color(0xFF3B465E),
                                    fontWeight: FontWeight.w500)),
                          ),
                    (model.categorie == '' || model.categorie == null)
                        ? Text('')
                        : Padding(
                            padding: (model.categorie == '' ||
                                    model.categorie == null)
                                ? const EdgeInsets.only(top: 0)
                                : const EdgeInsets.only(top: 5.0),
                            child: Text(
                                "${'categorie'.tr} : ${model.categorie}",
                                style: TextStyle(
                                    color: Color(0xFF3B465E),
                                    fontWeight: FontWeight.w500)),
                          ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
