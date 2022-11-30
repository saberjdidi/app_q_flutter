import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/incident_environnement/incident_env_model.dart';
import '../../Utils/custom_colors.dart';

class AuditWidget extends StatelessWidget {
  final AuditModel model;
  const AuditWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final champ = model.champ;
    const htmlData = """<p>Bonjour Saphir</p>""";
    DateTime dt = DateTime.parse(model.dateDebPrev.toString());
    final langue = SharedPreference.getLangue();
    var date;
    if (langue == 'en') {
      date = DateFormat('MM/dd/yyyy').format(dt);
    } else if (langue == 'fr') {
      date = DateFormat('dd/MM/yyyy').format(dt);
    } else {
      date = DateFormat('dd/MM/yyyy').format(dt);
    }

    final status = model.etat;
    String message_status = '';
    Color color_status = Color(0xff898f97);

    switch (status) {
      case 1:
        message_status = 'non_encore_realise'.tr;
        color_status = Color(0xffcd1247);
        break;
      case 2:
        message_status = 'realise'.tr;
        color_status = Color(0xff07bd50);
        break;
      case 3:
        message_status = 'reporte'.tr;
        color_status = Color(0xff2b9c85);
        break;
      case 4:
        message_status = 'annule'.tr;
        color_status = Color(0xffc2100a);
        break;
      case 5:
        message_status = 'en_cours_de_validation'.tr;
        color_status = Color(0xff3a99bf);
        break;
      case 6:
        message_status = 'en_cours_elaboration'.tr;
        color_status = Color(0xff108bcd);
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
                          "Ref Audit ${model.idAudit} ${model.online == 1 ? '' : '*'}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Brand-Regular",
                              fontSize: 15.0,
                              color: Colors.blue)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 3.0),
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
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    child: Icon(Icons.calendar_today),
                                  ),
                                ),
                                TextSpan(
                                    text: '$date',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54)),

                                //TextSpan(text: '${action.declencheur}'),
                              ],
                            ),
                          ),
                          /*Text(
                            "${date}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontFamily: "Brand-Bold"),
                          ),*/
                        ),
                        (model.site == "" || model.site == null)
                            ? Text('')
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  'Site : ${model.site}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF18516C)),
                                ),
                              ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Html(
                          data: champ, //htmlData,
                          //tagsList: Html.tags..remove(Platform.isAndroid ? "-" : ""),
                          style: {
                            "body": Style(
                                backgroundColor:
                                    Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                fontSize: FontSize.large,
                                fontWeight: FontWeight.w500,
                                margin: EdgeInsets.zero,
                                textTransform: TextTransform.none),
                          },
                        )
                        /* ReadMoreText(
                        "${model.champ}",
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
                      ),*/
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "Type : ${model.typeA}",
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
              ))
        ],
      ),
    );
  }
}
