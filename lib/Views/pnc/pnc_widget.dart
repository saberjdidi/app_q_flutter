import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/pnc/pnc_model.dart';
import 'package:readmore/readmore.dart';
import 'dart:ui' as ui;
import '../../Utils/custom_colors.dart';

class PNCWidget extends StatelessWidget {
  final PNCModel pncModel;
  final Color color;
  const PNCWidget({Key? key, required this.pncModel, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime dt = DateTime.parse(pncModel.dateDetect.toString());
    //final date = DateFormat('dd/MM/yyyy').format(dt);
    final status = pncModel.etatNC;
    String message_status = '';
    Color color_status = Color(0xff898f97);

    switch (status) {
      case 3:
        message_status = 'en_attente_de_validation'.tr;
        color_status = Color(0xff14b843);
        break;
      case 4:
        message_status = 'en_attente_de_validation_de_decision'.tr;
        color_status = Color(0xff03c781);
        break;
      case 5:
        message_status = 'fiche_refuse'.tr;
        color_status = Color(0xffd00e38);
        break;
      case 6:
        message_status = 'en_attente_de_correction'.tr;
        color_status = Color(0xff0759ee);
        break;
      case 7:
        message_status = 'en_attente_de_decision'.tr;
        color_status = Color(0xff0da0db);
        break;
      case 8:
        message_status = 'en_attente_de_traitement'.tr;
        color_status = Color(0xff0ec4c4);
        break;
      case 9:
        message_status = 'en_attente_de_cloture'.tr;
        color_status = Color(0xffc96b80);
        break;
      case 8:
        message_status = 'cloture'.tr;
        color_status = Color(0xffd20835);
        break;
      default:
        message_status = "";
        color_status = Color(0xff898f97);
    }
    return Card(
      shadowColor: Color(0xFFedf0f8),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                  "PNC N° ${pncModel.nnc} ${pncModel.online == 1 ? '' : '*'}",
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
            /*  Text("${pncModel.nc}", style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),*/
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "Date detect : ${pncModel.dateDetect}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        fontFamily: "Brand-Bold"),
                  ),
                ),
                Text(
                  'traited'.tr,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          pncModel.traitee == 1 ? Colors.blue : Colors.black54,
                      fontFamily: "Brand-Bold"),
                ),
                Switch(
                    value: pncModel.traitee == 1 ? true : false,
                    onChanged: (value) {}),
              ],
            ),
            ReadMoreText(
              "${'non_conformite'.tr} : ${pncModel.nc}",
              style: TextStyle(
                  color: Color(0xFF3B465E), fontWeight: FontWeight.bold),
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
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Text(
                '${'product'.tr} : ${pncModel.produit}',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Text(
              'Type : ${pncModel.typeNC}',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
            (pncModel.fournisseur == '' || pncModel.fournisseur!.isEmpty)
                ? Text('')
                : Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      '${'fournisseur'.tr} : ${pncModel.fournisseur}',
                      style: TextStyle(color: Colors.black87, fontSize: 15),
                    ),
                  ),
            (pncModel.site == '' || pncModel.site!.isEmpty)
                ? Text('')
                : Text(
                    'Site : ${pncModel.site}',
                    style: TextStyle(color: Colors.black87, fontSize: 15),
                  ),
          ],
        ),
      ),
    );
  }
}
