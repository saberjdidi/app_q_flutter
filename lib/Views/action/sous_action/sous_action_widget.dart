import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/action/sous_action_model.dart';
import 'package:readmore/readmore.dart';

import '../../../Utils/custom_colors.dart';

class SousActionWidget extends StatelessWidget {
  final SousActionModel sousActionModel;
  final Color color;
  const SousActionWidget({Key? key, required this.sousActionModel, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateTime dt = DateTime.parse(sousActionModel.dateSuivi.toString());
    //final date = DateFormat('dd/MM/yyyy').format(dt);
    return Card(
      shadowColor: Color(0xFFedf0f8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        title:  Text("Sous Action N° ${sousActionModel.nSousAct} ${sousActionModel.online == 1 ?'' :'*'}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Brand-Regular",
                fontSize: 15.0,
                color: Colors.blue)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Designation : ${sousActionModel.sousAct}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand-Regular",
                    fontSize: 15.0)),
            SizedBox(height: 5.0,),
            Text("Delai Suivi : ${sousActionModel.delaiSuivi}", style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
            SizedBox(height: 5.0,),
            ReadMoreText(
              "Priorite : ${sousActionModel.priorite}",
              style: TextStyle(
                  color: Color(0xFF3B465E),
                  fontWeight: FontWeight.w500),
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
            SizedBox(height: 5.0,),
            Text("Gravite : ${sousActionModel.gravite}", style:
            TextStyle(fontWeight: FontWeight.w500, color: Color(0xFD151414), fontFamily: "Brand-Bold"),),
            SizedBox(height: 5.0,),
            Text("Resp. Real : ${sousActionModel.respRealNom}", overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFD635050),
                fontFamily: "Brand-Bold"),),
            SizedBox(height: 5.0,),
            Text("Resp. Suivi : ${sousActionModel.respSuivieNom}", overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xFD635050), fontFamily: "Brand-Bold"),),
          ],
        ),
      ),
    );
  }
}