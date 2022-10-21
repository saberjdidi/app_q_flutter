import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/document/documentation_controller.dart';
import 'package:qualipro_flutter/Controllers/pnc/pnc_controller.dart';
import 'package:qualipro_flutter/Controllers/reunion/reunion_controller.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Views/pnc/pnc_widget.dart';
import '../../Models/documentation/documentation_model.dart';
import '../../Models/pnc/pnc_model.dart';
import '../../Services/action/local_action_service.dart';
import '../../Services/document/documentation_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import 'documentation_widget.dart';

class SearchDocumentationDelegate extends SearchDelegate<DocumentationModel> {
  
  List<DocumentationModel> listDocument = <DocumentationModel>[];

  SearchDocumentationDelegate(this.listDocument);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, DocumentationModel());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return GetBuilder<DocumentationController>(builder: (controller){
     /* final matricule = SharedPreference.getMatricule();
       DocumentationService().searchDocument(matricule, query.trim().toLowerCase()).then((response) async {
        print('response doc : $response');
        //isDataProcessing(false);
        response.forEach((data) async {
          //print('get documentation : ${data} ');
          var model = DocumentationModel();
          model.online = 1;
          model.cdi = data['cdi'];
          model.libelle = data['libelle'];
          model.indice = data['indice'];
          model.typeDI = data['typeDI'];
          model.fichierLien = data['fichierLien'];
          model.motifMAJ = data['motifMAJ'];
          model.fl = data['fl'];
          model.dateRevis = data['dateRevis'];
          model.suffixe = data['suffixe'];
          model.favoris = data['favoris'];
          model.favorisEtat = data['favoris_etat'];
          model.mail = data['mail'];
          model.mailBoolean = data['mail_boolean'];
          model.dateCreat = data['date_creat'];
          if(model.dateCreat == null){
            model.dateCreat = "";
          }
          model.dateRevue = data['dateRevue'];
          model.dateprochRevue = data['dateprochRevue'];
          model.nbrVers = data['nbr_vers'];
          model.superv = data['superv'];
          //model.sitesuperv = data['sitesuperv'];
          model.important = data['important'];
          model.issuperviseur = data['issuperviseur'];
          model.documentPlus0 = data['document_plus0'];
          model.documentPlus1 = data['document_plus1'];
          controller.filterDocument.add(model);
          controller.filterDocument.forEach((element) {
            //print('element document ${element.cdi} - ${element.libelle}');
          });

        });
      }
          , onError: (err) {
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          }); */

      controller.filterDocument = listDocument.where((action) {
        return action.cdi.toString().toLowerCase().contains(query.trim().toLowerCase())
            || action.libelle!.toLowerCase().contains(query.trim().toLowerCase())
            || action.dateCreat!.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();

      return controller.filterDocument.isNotEmpty ?
      ListView.builder(
        itemCount: controller.filterDocument.length,
        itemBuilder: (context, index) {

          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 3, right: 3, bottom: 0.0),
            child: Slidable(
              // Specify a key if the Slidable is dismissible.
              key: const ValueKey(0),
              // The child of the Slidable is what the user sees when the
              // component is not dragged.
              child: DocumentationWidget(model: controller.filterDocument[index], color: Colors.blueGrey,),
              // The start action pane is the one at the left or the top side.
              startActionPane: ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: const ScrollMotion(),

                // All actions are defined in the children parameter.
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      //Get.to(ParticipantPage(nReunion: controller.filterReunion[index].nReunion));
                    },
                    backgroundColor: Color(0xFF21B7CA),
                    foregroundColor: Colors.white,
                    icon: Icons.list,
                    label: 'details',
                  ),
                ],
              ),
              // The end action pane is the one at the right or the bottom side.
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                children: [
                  
                ],
              ),
            ),
          );
        },
      )
          : const Center(child: Text('Data not found', style: TextStyle(
          fontSize: 20.0,
          fontFamily: 'Brand-Bold'
      ),),);
    });
  }


}