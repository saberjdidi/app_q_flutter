import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Utils/shared_preference.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Utils/custom_colors.dart';

class ReunionWidget extends StatefulWidget {
  final ReunionModel model;
  final Color color;
  const ReunionWidget({Key? key, required this.model, required this.color})
      : super(key: key);

  @override
  State<ReunionWidget> createState() => _ReunionWidgetState();
}

class _ReunionWidgetState extends State<ReunionWidget> {
  final langue = SharedPreference.getLangue();

  @override
  Widget build(BuildContext context) {
    var date_prevue, date_real;
    if (langue == 'en') {
      setState(() {
        date_prevue = DateFormat('MM/dd/yyyy')
            .format(DateTime.parse(widget.model.datePrev.toString()));
        //date_real = DateFormat('MM/dd/yyyy').format(DateTime.parse(widget.model.dateReal.toString()));
      });
    } else if (langue == 'fr') {
      setState(() {
        date_prevue = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.model.datePrev.toString()));
        //date_real = DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.model.dateReal.toString()));
      });
    } else {
      setState(() {
        date_prevue = DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.model.datePrev.toString()));
        //date_real = DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.model.dateReal.toString()));
      });
    }

    final status = widget.model.etat;
    String message_status = '';
    Color color_status = Color(0xff898f97);
    switch (status) {
      case "0":
        message_status = 'non_encore_realise'.tr;
        color_status = Color(0xffd2430c);
        break;
      case "1":
        message_status = 'realise'.tr;
        color_status = Color(0xff0da713);
        break;
      case "2":
        message_status = 'annule'.tr;
        color_status = Color(0xffd00e38);
        break;
      case "3":
        message_status = 'reporte'.tr;
        color_status = Color(0xff0f6fe5);
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
                          "${'reunion'.tr} N° ${widget.model.nReunion} ${widget.model.online == 1 ? '' : '*'}",
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
                          child: widget.model.datePrev == null
                              ? Text('${'date_prevue'.tr} :')
                              : Text(
                                  "${'date_prevue'.tr} : $date_prevue",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontFamily: "Brand-Bold"),
                                ),
                        ),
                        widget.model.lieu == ""
                            ? Text('')
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  '${'lieu'.tr} : ${widget.model.lieu}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF18516C)),
                                ),
                              ),
                      ],
                    ),
                    /*
                    widget.model.dateReal == null
                        ? Text('Date ${'realisation'.tr} :')
                        : SharedPreference.getLangue() == 'en'
                            ? Text(
                                "Date ${'realisation'.tr} : ${DateFormat('MM/dd/yyyy').format(DateTime.parse(widget.model.dateReal.toString()))}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontFamily: "Brand-Bold"),
                              )
                            : Text(
                                "Date ${'realisation'.tr} : ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.model.dateReal.toString()))}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontFamily: "Brand-Bold"),
                              ),
                    */
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "${'order'} : ${widget.model.ordreJour}",
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
                        "Type : ${widget.model.typeReunion}",
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

/*
class ReunionWidget extends StatelessWidget {
  final ReunionModel model;
  final Color color;
  const ReunionWidget({Key? key, required this.model, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    final status = model.etat;
    String message_status = '';
    Color color_status = Color(0xff898f97);

    switch (status) {
      case "0":
        message_status = 'non_encore_realise'.tr;
        color_status = Color(0xffd2430c);
        break;
      case "1":
        message_status = 'realise'.tr;
        color_status = Color(0xff0da713);
        break;
      case "2":
        message_status = 'annule'.tr;
        color_status = Color(0xffd00e38);
        break;
      case "3":
        message_status = 'reporte'.tr;
        color_status = Color(0xff0f6fe5);
        break;
      default:
        message_status = "";
        color_status = Color(0xff898f97);
    }
    return Card(
      shadowColor: Color(0xFFedf0f8),
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
                          "${'reunion'.tr} N° ${model.nReunion} ${model.online == 1 ? '' : '*'}",
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
                            "${'date_prevue'.tr} : ${model.datePrev.toString()}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontFamily: "Brand-Bold"),
                          ),
                        ),
                        model.lieu == ""
                            ? Text('')
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  '${'lieu'.tr} : ${model.lieu}',
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
                      child: ReadMoreText(
                        "${'order'} : ${model.ordreJour}",
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
                        "Type : ${model.typeReunion}",
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
} */
