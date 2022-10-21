import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/documentation/documentation_model.dart';
import 'package:qualipro_flutter/Models/pnc/pnc_model.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Models/action/action_model.dart';
import '../../Utils/custom_colors.dart';

class DetailsDocumentation extends StatelessWidget {
  final DocumentationModel model;
  const DetailsDocumentation({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _contentStyleHeader = const TextStyle(
        color: Color(0xff060f7d), fontSize: 15, fontWeight: FontWeight.w700,
        fontFamily: "Brand-Bold");
    final _contentStyle = const TextStyle(
        color: Color(0xff0c2d5e), fontSize: 14, fontWeight: FontWeight.normal,
        fontFamily: "Brand-Regular");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListBody(
          children: <Widget>[
            Row(
              children: [
                Text('Code : ', style: _contentStyleHeader,),
                Text('${model.cdi}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Libelle : ', style: _contentStyleHeader,),
                Text('${model.libelle}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Type : ', style: _contentStyleHeader,),
                Text('${model.typeDI}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Fichier Lien : ', style: _contentStyleHeader,),
                Text('${model.fichierLien}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Motif : ', style: _contentStyleHeader,),
                Text('${model.motifMAJ}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Date Creation : ', style: _contentStyleHeader,),
                Text('${model.dateCreat}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Date Revis : ', style: _contentStyleHeader,),
                Text('${model.dateRevis}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Date Revue : ', style: _contentStyleHeader,),
                Text('${model.dateRevue}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Date Proche Revue : ', style: _contentStyleHeader,),
                Text('${model.dateprochRevue}', style: _contentStyle),
              ],
            ),SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Superviseur : ', style: _contentStyleHeader,),
                Text('${model.superv}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Site Superviseur : ', style: _contentStyleHeader,),
                Text('${model.sitesuperv}', style: _contentStyle),
              ],
            ),
            SizedBox(height: 5.0,),
            Row(
              children: [
                Text('Etat Favoris : ', style: _contentStyleHeader,),
                Text('${model.favorisEtat}', style: _contentStyle),
              ],
            ),

          ],
        ),
      ),
    );
  }
}