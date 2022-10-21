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

class DocumentationWidget extends StatelessWidget {
  final DocumentationModel model;
  final Color color;
  const DocumentationWidget({Key? key, required this.model, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime dt = DateTime.parse(model.dateDetect.toString());
    //final date = DateFormat('dd/MM/yyyy').format(dt);
    final status = model.fichierLien.toString();
    Image document_image = Image.asset("assets/images/logo.png", width: 60.0, height: 60.0,);

    if(status.contains(".png") || status.contains(".PNG")){
      document_image = Image.asset("assets/images/icon_png.png",width: 60.0, height: 60.0,);
    }
   else if(status.contains(".docx") || status.contains(".DOCX")){
      document_image = Image.asset("assets/images/word.png",width: 60.0, height: 60.0,);
    }
    else if(status.contains(".txt")){
      document_image = Image.asset("assets/images/word.png",width: 60.0, height: 60.0,);
    }
    else if(status.contains(".xls") || status.contains(".xlsx")){
      document_image = Image.asset("assets/images/excel.png",width: 60.0, height: 60.0,);
    }
    else if(status.contains(".ppt")){
      document_image = Image.asset("assets/images/ppt.png",width: 60.0, height: 60.0,);
    }
    else if(status.contains(".pdf")){
      document_image = Image.asset("assets/images/pdficon.png",width: 60.0, height: 60.0,);
    }
    else {
      document_image = Image.asset("assets/images/logo.png", width: 60.0, height: 60.0,);
    }

    return Card(
      shadowColor: Color(0xFFedf0f8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: ListTile(
                leading: document_image,
                title:  Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text("${model.cdi}",
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
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                            child: Text("${model.dateCreat}", style:
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: ReadMoreText(
                        "${model.libelle}",
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
                        "Type DI : ${model.typeDI}",
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