import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/documentation/documentation_model.dart';
import 'dart:ui' as ui;

import 'package:qualipro_flutter/Utils/shared_preference.dart';

class DetailsDocumentation extends StatelessWidget {
  final DocumentationModel model;
  const DetailsDocumentation({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _contentStyleHeader = const TextStyle(
        color: Color(0xff060f7d),
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFamily: "Brand-Bold");
    final _contentStyle = const TextStyle(
        color: Color(0xff0c2d5e),
        fontSize: 14,
        fontWeight: FontWeight.normal,
        fontFamily: "Brand-Regular");

    final langue = SharedPreference.getLangue();
    DateTime dateCreation = DateTime.parse(model.dateCreat.toString());
    DateTime dateRevis = DateTime.parse(model.dateRevis.toString());
    DateTime dateRevue = DateTime.parse(model.dateRevue.toString());
    DateTime dateProchRevue = DateTime.parse(model.dateprochRevue.toString());

    var creation_date;
    var date_revis;
    var date_revue;
    var date_proche_revue;
    if (langue == 'en') {
      creation_date = DateFormat('dd/MM/yyyy').format(dateCreation);
      date_revis = DateFormat('dd/MM/yyyy').format(dateRevis);
      date_revue = DateFormat('dd/MM/yyyy').format(dateRevue);
      date_proche_revue = DateFormat('dd/MM/yyyy').format(dateProchRevue);
    } else if (langue == 'en') {
      creation_date = DateFormat('MM/dd/yyyy').format(dateCreation);
      date_revis = DateFormat('MM/dd/yyyy').format(dateRevis);
      date_revue = DateFormat('MM/dd/yyyy').format(dateRevue);
      date_proche_revue = DateFormat('MM/dd/yyyy').format(dateProchRevue);
    } else {
      creation_date = DateFormat('dd/MM/yyyy').format(dateCreation);
      date_revis = DateFormat('dd/MM/yyyy').format(dateRevis);
      date_revue = DateFormat('dd/MM/yyyy').format(dateRevue);
      date_proche_revue = DateFormat('dd/MM/yyyy').format(dateProchRevue);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListBody(
          children: <Widget>[
            Row(
              children: [
                Text(
                  'Code : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.cdi}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Libelle : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.libelle}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Type : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.typeDI}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  '${'file'.tr} ${'link'.tr} : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.fichierLien}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Motif : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.motifMAJ}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  '${'creation_date'.tr} : ',
                  style: _contentStyleHeader,
                ),
                Text('$creation_date', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Date Revis : ',
                  style: _contentStyleHeader,
                ),
                Text('$date_revis', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Date Revue : ',
                  style: _contentStyleHeader,
                ),
                Text('$date_revue', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Date Proche Revue : ',
                  style: _contentStyleHeader,
                ),
                Text('$date_proche_revue', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  '${'supervisor'.tr} : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.superv}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  'Site ${'supervisor'.tr} : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.sitesuperv}', style: _contentStyle),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  '${'etat'.tr} ${'favorites'.tr} : ',
                  style: _contentStyleHeader,
                ),
                Text('${model.favorisEtat}', style: _contentStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
