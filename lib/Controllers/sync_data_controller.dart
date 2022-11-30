import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/action/action_model.dart';
import 'package:qualipro_flutter/Models/audit/audit_model.dart';
import 'package:qualipro_flutter/Models/incident_environnement/upload_image_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/cause_typique_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/site_lesion_model.dart';
import 'package:qualipro_flutter/Models/reunion/action_reunion.dart';

import '../Models/action/action_sync.dart';
import '../Models/action/sous_action_model.dart';
import '../Models/audit/auditeur_model.dart';
import '../Models/audit/constat_audit_model.dart';
import '../Models/audit/critere_checklist_audit_model.dart';
import '../Models/incident_environnement/action_inc_env.dart';
import '../Models/incident_environnement/incident_env_model.dart';
import '../Models/incident_environnement/type_cause_incident_model.dart';
import '../Models/incident_environnement/type_consequence_incident_model.dart';
import '../Models/incident_securite/action_inc_sec.dart';
import '../Models/incident_securite/incident_securite_model.dart';
import '../Models/pnc/pnc_model.dart';
import '../Models/pnc/product_pnc_model.dart';
import '../Models/pnc/type_cause_pnc_model.dart';
import '../Models/pnc/type_pnc_model.dart';
import '../Models/reunion/participant_reunion_model.dart';
import '../Models/reunion/reunion_model.dart';
import '../Models/type_cause_model.dart';
import '../Models/visite_securite/action_visite_securite.dart';
import '../Models/visite_securite/checklist_critere_model.dart';
import '../Models/visite_securite/equipe_model.dart';
import '../Models/visite_securite/equipe_visite_securite_model.dart';
import '../Models/visite_securite/visite_securite_model.dart';
import '../Services/action/action_service.dart';
import '../Services/action/local_action_service.dart';
import '../Services/audit/audit_service.dart';
import '../Services/audit/local_audit_service.dart';
import '../Services/document/local_documentation_service.dart';
import '../Services/incident_environnement/incident_environnement_service.dart';
import '../Services/incident_environnement/local_incident_environnement_service.dart';
import '../Services/incident_securite/incident_securite_service.dart';
import '../Services/incident_securite/local_incident_securite_service.dart';
import '../Services/pnc/local_pnc_service.dart';
import '../Services/pnc/pnc_service.dart';
import '../Services/reunion/local_reunion_service.dart';
import '../Services/reunion/reunion_service.dart';
import '../Services/visite_securite/local_visite_securite_service.dart';
import '../Services/visite_securite/visite_securite_service.dart';
import '../Utils/shared_preference.dart';
import '../Utils/snack_bar.dart';

class SyncDataController extends GetxController {
  var isDataProcessing = false.obs;
  final matricule = SharedPreference.getMatricule();
  final language = SharedPreference.getLangue() ?? "";
  LocalActionService localActionService = LocalActionService();
  LocalPNCService localPNCService = LocalPNCService();
  LocalReunionService localReunionService = LocalReunionService();
  LocalDocumentationService localDocumentationService =
      LocalDocumentationService();
  LocalIncidentEnvironnementService localIncidentEnvironnementService =
      LocalIncidentEnvironnementService();
  LocalIncidentSecuriteService localIncidentSecuriteService =
      LocalIncidentSecuriteService();
  LocalVisiteSecuriteService localVisiteSecuriteService =
      LocalVisiteSecuriteService();
  LocalAuditService localAuditService = LocalAuditService();

  @override
  void onInit() {
    super.onInit();
  }

  //action
  Future<void> syncActionToSQLServer() async {
    try {
      isDataProcessing(true);
      List<ActionSync> listActionSync =
          await localActionService.readListActionSync(); // as List<ActionSync>;
      for (var i = 0; i < listActionSync.length; i++) {
        print(
            'action sync : ${listActionSync[i].action} - type:${listActionSync[i].typea} -source:${listActionSync[i].codesource} -desc:${listActionSync[i].descpb} -site:${listActionSync[i].codesite} -typecause:${listActionSync[i].listTypeCause} ');
        await ActionService().saveAction({
          "action": listActionSync[i].action,
          "typea": listActionSync[i].typea,
          "codesource": listActionSync[i].codesource,
          "refAudit": listActionSync[i].refAudit,
          "descpb": listActionSync[i].descpb,
          "cause": listActionSync[i].cause,
          "datepa": listActionSync[i].datepa,
          "cloture": listActionSync[i].cloture,
          "codesite": listActionSync[i].codesite,
          "matdeclencheur": listActionSync[i].matdeclencheur,
          "commentaire": listActionSync[i].commentaire,
          "respsuivi": listActionSync[i].respsuivi,
          "nfiche": 0,
          "imodule": 0,
          "datesaisie": listActionSync[i].datesaisie,
          "mat_origine": listActionSync[i].matOrigine,
          "objectif": listActionSync[i].objectif,
          "respclot": listActionSync[i].respclot,
          "annee": listActionSync[i].annee,
          "ref_interne": listActionSync[i].refInterne,
          "direction": listActionSync[i].direction,
          "metier": 0,
          "theme": 0,
          "process": listActionSync[i].process,
          "domaine": listActionSync[i].domaine,
          "service": listActionSync[i].service,
          //"prod": listProduct.toList(),
          "typesCauses": listActionSync[i].listTypeCause
        }).then((resp) async {
          //isDataProcessing(false);
          await localActionService.deleteTableActionSync();
          //ShowSnackBar.snackBar("Add Action Sync", "Synchronization successfully", Colors.green);
          debugPrint(
              'action sync : ${listActionSync[i].action}-${listActionSync[i].descpb}-${listActionSync[i].listTypeCause}');
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      /* var responseActionSync = await localActionService.readActionSync();
      responseActionSync.forEach((data) async {
        //print('listTypeCauses : ${data['listTypeCause']}');
        print('data: $data');
        await ActionService().saveAction({
          "action": data['action'],
          "typea": data['typea'],
          "codesource": data['codesource'],
          "refAudit": data['refAudit'],
          "descpb": data['descpb'],
          "cause": data['cause'],
          "datepa": data['datepa'],
          "cloture": data['cloture'],
          "codesite": data['codesite'],
          "matdeclencheur": data['matdeclencheur'],
          "commentaire": data['commentaire'],
          "respsuivi": data['respsuivi'],
          "nfiche": 0,
          "imodule": 0,
          "datesaisie": data['datesaisie'],
          "mat_origine": data['matOrigine'],
          "objectif": data['objectif'],
          "respclot": data['respclot'],
          "annee": data['annee'],
          "ref_interne": data['refInterne'],
          "direction": data['direction'],
          "metier": 0,
          "theme": 0,
          "process": data['process'],
          "domaine": data['domaine'],
          "service": data['service'],
          //"prod": listProduct.toList(),
          "typesCauses": data['listTypeCause']
        }).then((resp) async {
          //isDataProcessing(false);
          await localActionService.deleteTableActionSync();
          //ShowSnackBar.snackBar("Add Action Sync", "Synchronization successfully", Colors.green);
          debugPrint('action sync : ${data['action']}-${data['descpb']}-${data['listTypeCause']}');
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }); */
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Error Sync reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncSousActionToSQLServer() async {
    try {
      isDataProcessing(true);
      List<SousActionModel> listSousActionSync =
          await localActionService.readListSousActionByOnline();
      for (var i = 0; i < listSousActionSync.length; i++) {
        print(
            'sous action sync : ${listSousActionSync[i].nAct} - ${listSousActionSync[i].sousAct} -processus:${listSousActionSync[i].processus}');
        await ActionService().saveSousAction({
          "nact": listSousActionSync[i].nAct,
          "sousact": listSousActionSync[i].sousAct,
          "respreal": listSousActionSync[i].respReal,
          "respsuivi": listSousActionSync[i].respSuivi,
          "delaitrait": "",
          "delaisuivi": listSousActionSync[i].delaiSuivi,
          "datereal": listSousActionSync[i].delaiReal,
          "datesuivi": "",
          "coutprev": listSousActionSync[i].coutPrev,
          "pourcentreal": "",
          "pourcentsuivi": "",
          "depense": "",
          "rapporteff": "",
          "commentaire": "",
          "cloture": "",
          "processus": listSousActionSync[i].processus,
          "risk": listSousActionSync[i].risques,
          "priorite":
              listSousActionSync[i].codePriorite, //int.parse(data['priorite']),
          "gravite":
              listSousActionSync[i].codeGravite //int.parse(data['gravite'])
        }).then((resp) async {
          //isDataProcessing(false);
          await localActionService.deleteSousActionOffline();
          //ShowSnackBar.snackBar("Add SousAction ${data['sousAct']}", "Synchronization successfully", Colors.green);
          //debugPrint('sous action sync : ${listSousActionSync[i].nAct}-${listSousActionSync[i].sousAct}');
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
      /* var responseSousAction = await localActionService.readSousActionByOnline();
      responseSousAction.forEach((data) async{
        print('data sous action offline: $data');
        await ActionService().saveSousAction({
          "nact": data['nAct'],
          "sousact": data['sousAct'],
          "respreal": data['respRealMat'],
          "respsuivi": data['respSuiviMat'],
          "delaitrait": "",
          "delaisuivi": data['delaiSuivi'],
          "datereal": data['delaiReal'],
          "datesuivi": "",
          "coutprev": data['coutPrev'],
          "pourcentreal": "",
          "pourcentsuivi": "",
          "depense": "",
          "rapporteff": "",
          "commentaire": "",
          "cloture": "",
          "processus": data['processus'],
          "risk": data['risques'],
          "priorite": data['codePriorite'], //int.parse(data['priorite']),
          "gravite": data['codeGravite'] //int.parse(data['gravite'])
        }).then((resp) async {
          //isDataProcessing(false);
          await localActionService.deleteSousActionOffline();
          //ShowSnackBar.snackBar("Add SousAction ${data['sousAct']}", "Synchronization successfully", Colors.green);
          debugPrint('sous action sync : ${data['nAct']}-${data['sousAct']}');
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }); */
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Error Sync reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeCauseActionToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeCauseModel> listTypeCauseActionSync =
          await localActionService.readTypeCauseActionOffline();
      for (var i = 0; i < listTypeCauseActionSync.length; i++) {
        debugPrint(
            'type cause action sync : ${listTypeCauseActionSync[i].nAct} - ${listTypeCauseActionSync[i].typecause}');
        await ActionService()
            .saveTypeCauseAction(listTypeCauseActionSync[i].nAct,
                listTypeCauseActionSync[i].codetypecause)
            .then((resp) async {}, onError: (err) {
          if (kDebugMode) print('error type cause : ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error type cause : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync Participant reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //reunion
  Future<void> syncReunionToSQLServer() async {
    try {
      isDataProcessing(true);
      List<ReunionModel> listReunionSync =
          await localReunionService.readListReunionByOnline();
      for (var i = 0; i < listReunionSync.length; i++) {
        debugPrint(
            'reunion sync : ${listReunionSync[i].nReunion} - ${listReunionSync[i].lieu} -site:${listReunionSync[i].site}');
        await ReunionService().saveReunion({
          "codetypeR": listReunionSync[i].codeTypeReunion,
          "dateprev": listReunionSync[i].datePrev,
          "dureePrev": listReunionSync[i].dureePrev,
          "heuredeb": listReunionSync[i].heureDeb,
          "heurefin": listReunionSync[i].heureFin,
          "ordrejour": listReunionSync[i].ordreJour,
          "dateReal": listReunionSync[i].dateReal,
          "durereal": listReunionSync[i].dureReal,
          "etat": listReunionSync[i].etat,
          "commentaire": listReunionSync[i].commentaire,
          "lieu": listReunionSync[i].lieu,
          "site": listReunionSync[i].codeSite,
          "id_process": listReunionSync[i].codeProcessus,
          "id_domaine": listReunionSync[i].codeActivity,
          "id_direction": listReunionSync[i].codeDirection,
          "id_service": listReunionSync[i].codeService,
          "matdecl": matricule
        }).then((resp) async {
          //await localReunionService.deleteReunionOffline();
          //ShowSnackBar.snackBar("${data['ordreJour']} added", "Synchronization successfully", Colors.green);
        }, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Sync Reunion", err.toString(), Colors.red);
        });
      }
      /*  var responseReunionByOnline = await localReunionService.readReunionByOnline();
      responseReunionByOnline.forEach((data) async{
        debugPrint('readReunionByOnline : ${data['nReunion']}');
        await ReunionService().saveReunion({
          "codetypeR": data['codeTypeReunion'],
          "dateprev": data['datePrev'],
          "dureePrev": data['dureePrev'],
          "heuredeb": data['heureDeb'],
          "heurefin": data['heureFin'],
          "ordrejour": data['ordreJour'],
          "dateReal": data['dateReal'],
          "durereal": data['dureeReal'],
          "etat": data['etat'],
          "commentaire": data['commentaire'],
          "lieu": data['lieu'],
          "site": data['codeSite'],
          "id_process": data['codeProcessus'],
          "id_domaine": data['codeActivity'],
          "id_direction": data['codeDirection'],
          "id_service": data['codeService'],
          "matdecl": matricule
        }).then((resp) async {
          if(kDebugMode) print('Sync reunion : ${data['nReunion']} - ${data['lieu']}  ');
          //await localReunionService.deleteReunionOffline();
          //ShowSnackBar.snackBar("${data['ordreJour']} added", "Synchronization successfully", Colors.green);
        }, onError: (err) {
          ShowSnackBar.snackBar("Error Sync Reunion", err.toString(), Colors.red);
        });
      }); */
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Error Sync reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncParticipantOfReunionToSQLServer() async {
    try {
      isDataProcessing(true);
      List<ParticipantReunionModel> listParticipantReunionSync =
          await localReunionService.readListParticipantReunionByOnline();
      for (var i = 0; i < listParticipantReunionSync.length; i++) {
        debugPrint(
            'particpants of reunion sync : ${listParticipantReunionSync[i].nReunion} - ${listParticipantReunionSync[i].mat}');
        await ReunionService().addParticipant({
          "numReunion": listParticipantReunionSync[i].nReunion,
          "matParticipant": listParticipantReunionSync[i].mat
        }).then((resp) async {
          //if(kDebugMode) print('particpant sync : ${listParticipantReunionSync[i].nReunion} - ${listParticipantReunionSync[i].mat} ');
        }, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Sync Participant reunion", err.toString(), Colors.red);
        });
      }
      /* var responseParticipantReunionByOnline = await localReunionService.readParticipantReunionByOnline();
      responseParticipantReunionByOnline.forEach((data) async{
        await ReunionService().addParticipant({
          "numReunion": data['nReunion'],
          "matParticipant": data['mat']
        }).then((resp) async {
          if(kDebugMode) print('Sync participant reunion : ${data['nReunion']} - ${data['mat']}  ');
        }, onError: (err) {
          ShowSnackBar.snackBar("Error Sync Participant reunion", err.toString(), Colors.red);
        });
      }); */
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync Participant reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncActionOfReunionToSQLServer() async {
    try {
      List<ActionReunion> listActionReunion =
          await localReunionService.readActionReunionOffline();
      for (var i = 0; i < listActionReunion.length; i++) {
        debugPrint(
            'actions of reunion sync : ${listActionReunion[i].nReunion} - ${listActionReunion[i].nAct} - ${listActionReunion[i].decision}');
        await ReunionService().addActionReunion({
          "nReunion": listActionReunion[i].nReunion,
          "nAct": listActionReunion[i].nAct,
          "decision": listActionReunion[i].decision,
          "lang": language
        }).then((resp) async {}, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Sync action reunion", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync action reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  //sync pnc
  Future<void> syncPNCToSQLServer() async {
    try {
      isDataProcessing(true);
      List<PNCModel> listPNCSync = await localPNCService.readListPNCByOnline();
      for (var i = 0; i < listPNCSync.length; i++) {
        debugPrint(
            'pnc sync : ${listPNCSync[i].nnc} - ${listPNCSync[i].nc} -product:${listPNCSync[i].produit}');
        await PNCService().savePNC({
          "codePdt": listPNCSync[i].codePdt,
          "codeTypeNC": listPNCSync[i].codeTypeNC,
          "dateDetect": listPNCSync[i].dateDetect,
          "nc": listPNCSync[i].nc,
          "recep": listPNCSync[i].recep,
          "qteDetect": listPNCSync[i].qteDetect,
          "unite": listPNCSync[i].unite,
          "valRej": listPNCSync[i].valRej,
          "traitement": "",
          "ctr": 0,
          "ctt": 0,
          "traitee": listPNCSync[i].traitee,
          "respTrait": "",
          "numOf": listPNCSync[i].numeroOf,
          "delaiTrait": listPNCSync[i].dateSaisie,
          "qteRej": 0,
          "matOrigine": listPNCSync[i].matOrigine,
          "ngravite": listPNCSync[i].codeGravite,
          "repSuivi": "",
          "cloturee": 0,
          "dateT": listPNCSync[i].dateSaisie,
          "codeSite": listPNCSync[i].codeSite,
          "codeSourceNC": listPNCSync[i].codeSource,
          "codeTypeT": 0,
          "nLot": listPNCSync[i].numeroLot,
          "rapportT": "",
          "nAct": 0,
          "dateClot": listPNCSync[i].dateSaisie,
          "rapportClot": "",
          "bloque": listPNCSync[i].bloque,
          "isole": listPNCSync[i].isole,
          "numCession": "",
          "numEnvoi": "",
          "dateSaisie": listPNCSync[i].dateSaisie,
          "matEnreg": matricule.toString(),
          "qtConforme": 0,
          "qtNonConforme": 0,
          "prix": 0,
          "dateLiv":
              listPNCSync[i].dateLivraison, //dateLivraisonController.text,
          "atelier": listPNCSync[i].codeAtelier,
          "qteprod": listPNCSync[i].qteProduct,
          "ninterne": listPNCSync[i].numInterne,
          "det_type": 0,
          "avec_retour": 0,
          "processus": listPNCSync[i].codeProcessus,
          "domaine": listPNCSync[i].codeActivity,
          "direction": listPNCSync[i].codeDirection,
          "service": listPNCSync[i].codeService,
          "id_client": listPNCSync[i].codeClient,
          "actionIm": listPNCSync[i].actionIm,
          "causeNC": "default",
          "isps": listPNCSync[i].isps,
          "id_fournisseur": listPNCSync[i].codeFournisseur,
          "pourcentage": listPNCSync[i].pourcentage
        }).then((response) async {
          //await localPNCService.deletePNCOffline();
          List<UploadImageModel> listImages =
              await localPNCService.readImagesPNC();
          for (var j = 0; j < listImages.length; j++) {
            debugPrint(
                'image pnc sync : ${listImages[j].idFiche} - ${listImages[j].fileName.toString()} - ${listImages[j].image.toString()}');
            await PNCService().uploadImagePNC({
              "image": listImages[j].image.toString(),
              "idFiche": listImages[j].idFiche,
              "fileName": listImages[j].fileName.toString()
            }).then((resp) async {
              await localPNCService.deleteTableImagePNC();
              //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
              //Get.to(ActionRealisationPage());
            }, onError: (err) {
              isDataProcessing(false);
              // ShowSnackBar.snackBar("Error upload images", err.toString(), Colors.red);
            });
          }
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Error Sync reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncProductPNCToSQLServer() async {
    try {
      isDataProcessing(true);
      List<ProductPNCModel> listProductPNCSync =
          await localPNCService.readListProductPNCByOnline();
      for (var i = 0; i < listProductPNCSync.length; i++) {
        debugPrint(
            'product pnc sync : ${listProductPNCSync[i].nnc} - ${listProductPNCSync[i].produit}');
        await PNCService().addProductNC({
          "nnc": listProductPNCSync[i].nnc,
          "codeProduit": listProductPNCSync[i].codeProduit,
          "qDetect": listProductPNCSync[i].qdetect,
          "unite": listProductPNCSync[i].unite,
          "nof": listProductPNCSync[i].numOf,
          "lot": listProductPNCSync[i].numLot,
          "qProd": listProductPNCSync[i].qprod
        }).then((resp) async {
          //if(kDebugMode) print('product : ${listProductPNCSync[i].nnc} - ${listProductPNCSync[i].produit}');
        }, onError: (err) {
          if (kDebugMode) print('error product pnc sync : ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error product pnc sync : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync Participant reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeCausePNCToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeCausePNCModel> listTypeCausePNCSync =
          await localPNCService.readListTypeCausePNCByOnline();
      for (var i = 0; i < listTypeCausePNCSync.length; i++) {
        debugPrint(
            'type cause pnc sync : ${listTypeCausePNCSync[i].nnc} - ${listTypeCausePNCSync[i].typecause}');
        await PNCService().addTypeCauseByNNC({
          "nnc": listTypeCausePNCSync[i].nnc,
          "codetypecause": listTypeCausePNCSync[i].codetypecause
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode) print('error type cause : ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error type cause : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync Participant reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeProductPNCToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypePNCModel> listTypeProductPNCSync =
          await localPNCService.readTypeProductNNCByOnline();
      for (var i = 0; i < listTypeProductPNCSync.length; i++) {
        debugPrint(
            'type product pnc sync : ${listTypeProductPNCSync[i].nnc} - ${listTypeProductPNCSync[i].idProduct} - ${listTypeProductPNCSync[i].typeNC}');
        await PNCService().addTypeProductNC({
          "nnc": listTypeProductPNCSync[i].nnc,
          "id_produit": listTypeProductPNCSync[i].idProduct,
          "type": listTypeProductPNCSync[i].codeTypeNC,
          "pourcentage": listTypeProductPNCSync[i].pourcentage,
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode) print('error type product : ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error type product pnc sync : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Exception Sync type product pnc", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncAuditToSQLServer() async {
    try {
      isDataProcessing(true);
      List<AuditModel> listAuditSync =
          await localAuditService.readListAuditByOnline();
      for (var i = 0; i < listAuditSync.length; i++) {
        debugPrint(
            'audit sync : ${listAuditSync[i].refAudit} - ${listAuditSync[i].audit}');
        await AuditService().saveAudit({
          "descriptionAudit": listAuditSync[i].audit,
          "dateDebutPrev": listAuditSync[i].dateDebPrev,
          "dateFinPrev": listAuditSync[i].dateFinPrev,
          "objectif": listAuditSync[i].objectif,
          "codeTypeAudit": listAuditSync[i].codeTypeA,
          "codeSite": listAuditSync[i].codeSite,
          "refInterne": listAuditSync[i].interne,
          "matDeclencheur": matricule.toString(),
          "processus": listAuditSync[i].idProcess,
          "domaine": listAuditSync[i].idDomaine,
          "direction": listAuditSync[i].idDirection,
          "service": listAuditSync[i].idService,
          "codesChamps": listAuditSync[i].listCodeChamp
        }).then((resp) async {
          String? refAudit = resp['refAudit'];
          debugPrint('refAudit : $refAudit');
          //geeting employes of type audit
          await AuditService().verifierRapportAuditParMode({
            "refAudit": "",
            "mat": "",
            "codeChamp": listAuditSync[i].codeTypeA.toString(),
            "mode": "Cons_Param_valid"
          }).then((responseVerifierRapport) async {
            //insert employe validation
            responseVerifierRapport.forEach((element) async {
              print(
                  'Matricule : ${element['matricule']} - Nompre : ${element['nompre']}');

              await AuditService().ajoutEnregEmpValidAudit({
                "refAudit": listAuditSync[i].refAudit.toString(),
                "mat": element['matricule'].toString(),
                "codeChamp": '',
                "mode": "Ajout_enreg_empvalid"
              }).then((responseEnregEmpValid) async {
                //Get.back();
                //ShowSnackBar.snackBar("Successfully", "responsable validation ${element['matricule']} added", Colors.green);
              }, onError: (error) {
                ShowSnackBar.snackBar("error inserting employes validation : ",
                    error.toString(), Colors.red);
              });
            });
          }, onError: (error) {
            ShowSnackBar.snackBar("error getting employe by TypeAudit : ",
                error.toString(), Colors.red);
          });
          //await localSecuriteEnvironnementService.deleteIncidentEnvironnementOffline();
          //ShowSnackBar.snackBar("${data['audit']} added", "Synchronization successfully", Colors.green);
        }, onError: (err) {
          isDataProcessing(false);
          debugPrint('Error sync audit : ${err.toString()}');
          ShowSnackBar.snackBar("Error sync audit", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Error Sync Audit", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncConstatAuditToSQLServer() async {
    try {
      isDataProcessing(true);
      List<ConstatAuditModel> listConstatAuditSync =
          await localAuditService.readListConstatAuditByOnline();
      for (var i = 0; i < listConstatAuditSync.length; i++) {
        debugPrint(
            'constat audit sync : ${listConstatAuditSync[i].refAudit} - ${listConstatAuditSync[i].act} - ${listConstatAuditSync[i].champ}');
        await AuditService().saveConstatAudit({
          "refAud": listConstatAuditSync[i].refAudit,
          "objetConstat": listConstatAuditSync[i].act,
          "descConstat": listConstatAuditSync[i].descPb,
          "typeConst": listConstatAuditSync[i].typeAct,
          "matConcerne": listConstatAuditSync[i].mat,
          "typeEcart": listConstatAuditSync[i].codeTypeE,
          "graviteConstat": listConstatAuditSync[i].ngravite,
          "mat": matricule.toString(),
          "id": listConstatAuditSync[i].idEcart,
          "numAct": 0,
          "mode": "Ajout",
          "codeChamp": listConstatAuditSync[i].codeChamp,
          "idCritere": 0,
          "dealiReal": listConstatAuditSync[i].delaiReal
        }).then((value) {}, onError: (error) {
          ShowSnackBar.snackBar(
              "Error constat audit sync", error.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error constat audit reunion", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncAuditeurInterneToSQLServer() async {
    try {
      isDataProcessing(true);
      List<AuditeurModel> listAuditeurInterneSync =
          await localAuditService.readListAuditeurInterneByOnline();
      for (var i = 0; i < listAuditeurInterneSync.length; i++) {
        debugPrint(
            'auditeur interne sync : ${listAuditeurInterneSync[i].refAudit} - ${listAuditeurInterneSync[i].mat} - ${listAuditeurInterneSync[i].nompre}');
        await AuditService().saveAuditeurInterne({
          "mat": listAuditeurInterneSync[i].mat,
          "refAudit": listAuditeurInterneSync[i].refAudit,
          "affectation": listAuditeurInterneSync[i].affectation
        }).then((value) {
          //print('auditeur interne  : ${data['refAudit']} - ${data['mat']}');
        }, onError: (error) {
          ShowSnackBar.snackBar(
              "Error auditeur interne sync", error.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error auditeur interne Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncAuditeurExterneToSQLServer() async {
    try {
      isDataProcessing(true);
      List<AuditeurModel> listAuditeurExterneSync =
          await localAuditService.readAuditeurExterneRattacherByOnline();
      for (var i = 0; i < listAuditeurExterneSync.length; i++) {
        debugPrint(
            'auditeur externe sync : ${listAuditeurExterneSync[i].refAudit} - ${listAuditeurExterneSync[i].code} - ${listAuditeurExterneSync[i].nompre}');
        await AuditService().saveAuditeurExterne({
          "codeAuditeur": listAuditeurExterneSync[i].code,
          "refAudit": listAuditeurExterneSync[i].refAudit,
          "affectation": listAuditeurExterneSync[i].affectation
        }).then((value) {
          //print('auditeur interne  : ${data['refAudit']} - ${data['mat']}');
        }, onError: (error) {
          ShowSnackBar.snackBar(
              "Error auditeur externe sync", error.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error auditeur externe Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncEmployeHabiliteAuditToSQLServer() async {
    try {
      isDataProcessing(true);
      List<AuditeurModel> listEmployeSync =
          await localAuditService.readEmployeHabiliteAuditByOnline();
      for (var i = 0; i < listEmployeSync.length; i++) {
        debugPrint(
            'auditeur employe habilite sync : ${listEmployeSync[i].refAudit} - ${listEmployeSync[i].mat} - ${listEmployeSync[i].nompre}');
        await AuditService().addEmployeHabiliteAudit({
          "mat": listEmployeSync[i].mat,
          "refAudit": listEmployeSync[i].refAudit
        }).then((value) {
          //print('auditeur interne  : ${data['refAudit']} - ${data['mat']}');
        }, onError: (error) {
          ShowSnackBar.snackBar(
              "Error employe habilite sync", error.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error employe habilite Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncCritereCheckListAudit() async {
    try {
      isDataProcessing(true);
      List<CritereChecklistAuditModel> listCritereCheckList =
          await localAuditService.readCritereCheckListAuditByOnline();
      for (var i = 0; i < listCritereCheckList.length; i++) {
        debugPrint(
            'critere checklist sync : ${listCritereCheckList[i].refAudit}-${listCritereCheckList[i].idChamp}-${listCritereCheckList[i].commentaire}');
        await AuditService().evaluerCritereOfCheckList({
          "refAudit": listCritereCheckList[i].refAudit,
          "idChamp": listCritereCheckList[i].idChamp,
          "idCritere": listCritereCheckList[i].idCrit,
          "evaluation": listCritereCheckList[i].evaluation,
          "commentaire": listCritereCheckList[i].commentaire
        }).then((response) {}, onError: (error) {
          ShowSnackBar.snackBar(
              'Error Critere CheckList Audit', error.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar('Exception Critere CheckList Audit',
          exception.toString(), Colors.redAccent);
    } finally {
      isDataProcessing(false);
    }
  }

  //sync incident environnement
  Future<void> syncIncidentEnvironnementToSQLServer() async {
    try {
      isDataProcessing(true);
      DateTime dateNow = DateTime.now();
      List<IncidentEnvModel> listIncidentEnvSync =
          await localIncidentEnvironnementService
              .readListIncidentEnvironnementByOnline();
      for (var i = 0; i < listIncidentEnvSync.length; i++) {
        debugPrint(
            'incident environnement sync : ${listIncidentEnvSync[i].n} - ${listIncidentEnvSync[i].type} - ${listIncidentEnvSync[i].incident}');
        await IncidentEnvironnementService().saveIncident({
          "incident": listIncidentEnvSync[i].incident,
          "date_detect": listIncidentEnvSync[i].dateDetect,
          "lieu": listIncidentEnvSync[i].codeLieu,
          "type": listIncidentEnvSync[i].codeType.toString(),
          "gravite": listIncidentEnvSync[i].codeGravite.toString(),
          "source": listIncidentEnvSync[i].codeSource.toString(),
          "mat_detect": listIncidentEnvSync[i].detectedEmployeMatricule,
          "mat_origine": listIncidentEnvSync[i].origineEmployeMatricule,
          "traitement": "",
          "mat_trait": "",
          "mat_suivi": "0",
          "delai_trait": listIncidentEnvSync[i].delaiTrait,
          "traite": 0,
          "date_trait": DateFormat('yyyy-MM-dd').format(dateNow),
          "rapport_trait": "",
          "cout": 0,
          "cloture": "",
          "date_cloture": DateFormat('yyyy-MM-dd').format(dateNow),
          "rapport_cloture": "",
          "accident": 0,
          "cause": "",
          "date1": listIncidentEnvSync[i].dateDetect,
          "rapport": listIncidentEnvSync[i].rapport,
          "categorie": listIncidentEnvSync[i].codeCategory.toString(),
          "heure": listIncidentEnvSync[i].heure,
          "poste": "",
          "secteur": listIncidentEnvSync[i].codeSecteur,
          "desc_cons": listIncidentEnvSync[i].descriptionConsequence,
          "desc_cause": listIncidentEnvSync[i].descriptionCause,
          "act_im": listIncidentEnvSync[i].actionImmediate,
          "type_cause": "",
          "quantite": listIncidentEnvSync[i].quantity,
          "ninter": listIncidentEnvSync[i].numInterne,
          "matEnreg": matricule.toString(),
          "detectPar": listIncidentEnvSync[i].detectedEmployeMatricule,
          "mat": matricule.toString(),
          "id_site": listIncidentEnvSync[i].codeSite.toString(),
          "id_process": listIncidentEnvSync[i].codeProcessus.toString(),
          "id_domaine": listIncidentEnvSync[i].codeActivity.toString(),
          "id_direction": listIncidentEnvSync[i].codeDirection.toString(),
          "id_service": listIncidentEnvSync[i].codeService.toString(),
          "isps": int.parse(listIncidentEnvSync[i].isps.toString()),
          "cout_estime": listIncidentEnvSync[i].codeCoutEsteme,
          "date_creat": listIncidentEnvSync[i].delaiTrait,
          "consequences": listIncidentEnvSync[i].listTypeConsequence,
          "causes": listIncidentEnvSync[i].listTypeCause
        }).then((resp) async {
          //ShowSnackBar.snackBar("${data['incident']} added", "Synchronization successfully", Colors.green);
          List<UploadImageModel> listImages =
              await localIncidentEnvironnementService
                  .readImagesIncidentEnvironnement();
          for (var j = 0; j < listImages.length; j++) {
            debugPrint(
                'image inc env sync : ${listImages[j].idFiche} - ${listImages[j].fileName.toString()} - ${listImages[j].image.toString()}');
            await IncidentEnvironnementService().uploadImageIncEnv({
              "image": listImages[j].image.toString(),
              "idFiche": listImages[j].idFiche,
              "fileName": listImages[j].fileName.toString()
            }).then((resp) async {
              await localIncidentEnvironnementService
                  .deleteTableImageIncidentEnvironnement();
              //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
              //Get.to(ActionRealisationPage());
            }, onError: (err) {
              isDataProcessing(false);
              // ShowSnackBar.snackBar("Error upload images", err.toString(), Colors.red);
            });
          }
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar(
              "Error incident environnement sync", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error incident environnement Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeCauseIncEnvToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeCauseIncidentModel> listTypeCauseIncEnvSync =
          await localIncidentEnvironnementService
              .readTypeCauseIncidentEnvRattacherByOnline();
      for (var i = 0; i < listTypeCauseIncEnvSync.length; i++) {
        debugPrint(
            'type cause inc env sync : ${listTypeCauseIncEnvSync[i].idIncident} - ${listTypeCauseIncEnvSync[i].typeCause}');
        await IncidentEnvironnementService().saveTypeCauseByIncident({
          "idIncident": listTypeCauseIncEnvSync[i].idIncident,
          "idCause": listTypeCauseIncEnvSync[i].idTypeCause
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type cause inc env sync: ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error type cause inc env sync : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type cause inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeConsequenceIncEnvToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeConsequenceIncidentModel> listTypeConsequenceIncEnvSync =
          await localIncidentEnvironnementService
              .readTypeConsequenceIncidentEnvRattacherByOnline();
      for (var i = 0; i < listTypeConsequenceIncEnvSync.length; i++) {
        debugPrint(
            'type consequence inc env sync : ${listTypeConsequenceIncEnvSync[i].idIncident} - ${listTypeConsequenceIncEnvSync[i].typeConsequence}');
        await IncidentEnvironnementService().saveTypeConseqenceByIncident({
          "idIncident": listTypeConsequenceIncEnvSync[i].idIncident,
          "idConsequence": listTypeConsequenceIncEnvSync[i].idConsequence
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type consequence inc env sync: ${err.toString()}');
          ShowSnackBar.snackBar("Error type consequence inc env sync : ",
              err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type consequence inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncActionIncEnvRattacherToSQLServer() async {
    try {
      isDataProcessing.value = true;
      List<ActionIncEnv> listAction = await localIncidentEnvironnementService
          .readActionIncEnvRattacherByOnline();
      for (var i = 0; i < listAction.length; i++) {
        debugPrint(
            'Action Inc Env sync : ${listAction[i].idFiche} - ${listAction[i].act}');
        await IncidentEnvironnementService().saveActionIncidentEnvironnement({
          "idFiche": listAction[i].idFiche,
          "idAct": listAction[i].nAct
        }).then((resp) async {}, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Action Inc Env Rattacher", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception Action Inc Env', exception.toString(), Colors.deepOrange);
    } finally {
      isDataProcessing(false);
    }
  }

  //sync incident securite
  Future<void> syncIncidentSecuriteToSQLServer() async {
    try {
      isDataProcessing(true);
      List<IncidentSecuriteModel> listIncidentSecSync =
          await localIncidentSecuriteService.readListIncidentSecuriteByOnline();
      for (var i = 0; i < listIncidentSecSync.length; i++) {
        debugPrint(
            'incident securite sync : ${listIncidentSecSync[i].ref} - ${listIncidentSecSync[i].designation} - ${listIncidentSecSync[i].listTypeCause}');
        await IncidentSecuriteService().saveIncident({
          "date_inc": listIncidentSecSync[i].dateInc,
          "heure_inc": listIncidentSecSync[i].heure,
          "type": listIncidentSecSync[i].codeType,
          "poste": listIncidentSecSync[i].codePoste,
          "gravite": listIncidentSecSync[i].codeGravite,
          "categorie": listIncidentSecSync[i].codeCategory,
          "desc_inc": listIncidentSecSync[i].descriptionIncident,
          "desc_caus": listIncidentSecSync[i].descriptionCause,
          "designation": listIncidentSecSync[i].designation,
          "desc_con": listIncidentSecSync[i].descriptionConsequence,
          "nom_jour": listIncidentSecSync[i].nombreJour,
          "actions_imm": listIncidentSecSync[i].actionImmediate,
          "site": listIncidentSecSync[i].codeSite.toString(),
          "secteur": listIncidentSecSync[i].codeSecteur,
          "mat": matricule.toString(),
          "avec_regle": "",
          "id_process": listIncidentSecSync[i].codeProcessus,
          "id_domaine": listIncidentSecSync[i].codeActivity,
          "id_direction": listIncidentSecSync[i].codeDirection,
          "id_service": listIncidentSecSync[i].codeService,
          "matEnreg": matricule.toString(),
          "recep": listIncidentSecSync[i].detectedEmployeMatricule,
          "ninter": listIncidentSecSync[i].numInterne,
          "isps": listIncidentSecSync[i].isps,
          "cout_estime": listIncidentSecSync[i].codeCoutEsteme,
          "date_creat": listIncidentSecSync[i].dateCreation,
          "semaine": listIncidentSecSync[i].week,
          "eventDeclencheur": listIncidentSecSync[i].codeEvenementDeclencheur,
          "typesCauses": listIncidentSecSync[i].listTypeCause,
          "typesConsequences": listIncidentSecSync[i].listTypeConsequence,
          "causesTypiques": listIncidentSecSync[i].listCauseTypique,
          "sitesLesions": listIncidentSecSync[i].listSiteLesion
        }).then((response) async {
          //await localSecuriteEnvironnementService.deleteIncidentEnvironnementOffline();
          List<UploadImageModel> listImages =
              await localIncidentSecuriteService.readImagesIncidentSecurite();
          for (var j = 0; j < listImages.length; j++) {
            debugPrint(
                'image inc sec sync : ${listImages[j].idFiche} - ${listImages[j].fileName.toString()} - ${listImages[j].image.toString()}');
            await IncidentSecuriteService().uploadImageIncSec({
              "image": listImages[j].image.toString(),
              "idFiche": listImages[j].idFiche,
              "fileName": listImages[j].fileName.toString()
            }).then((resp) async {
              await localIncidentSecuriteService
                  .deleteTableImageIncidentSecurite();
              //ShowSnackBar.snackBar("Action Successfully", "images uploaded", Colors.green);
              //Get.to(ActionRealisationPage());
            }, onError: (err) {
              isDataProcessing(false);
              // ShowSnackBar.snackBar("Error upload images", err.toString(), Colors.red);
            });
          }
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar(
              "Error inc sec sync", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error incident securite Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeCauseIncSecToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeCauseIncidentModel> listTypeCauseIncSecSync =
          await localIncidentSecuriteService
              .readTypeCauseIncidentSecRattacherByOnline();
      for (var i = 0; i < listTypeCauseIncSecSync.length; i++) {
        debugPrint(
            'type cause inc sec sync : ${listTypeCauseIncSecSync[i].idIncident} - ${listTypeCauseIncSecSync[i].typeCause}');
        await IncidentSecuriteService().saveTypeCauseByIncident({
          "idIncident": listTypeCauseIncSecSync[i].idIncident,
          "idCause": listTypeCauseIncSecSync[i].idTypeCause
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type cause inc sec sync: ${err.toString()}');
          ShowSnackBar.snackBar(
              "Error type cause inc sec sync : ", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type cause inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncTypeConsequenceIncSecToSQLServer() async {
    try {
      isDataProcessing(true);
      List<TypeConsequenceIncidentModel> listTypeConsequenceIncSecSync =
          await localIncidentSecuriteService
              .readTypeConsequenceIncSecRattacherByOnline();
      for (var i = 0; i < listTypeConsequenceIncSecSync.length; i++) {
        debugPrint(
            'type consequence inc sec sync : ${listTypeConsequenceIncSecSync[i].idIncident} - ${listTypeConsequenceIncSecSync[i].typeConsequence}');
        await IncidentSecuriteService().saveTypeConseqenceByIncident({
          "idIncident": listTypeConsequenceIncSecSync[i].idIncident,
          "idConsequence": listTypeConsequenceIncSecSync[i].idConsequence
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type consequence inc sec sync: ${err.toString()}');
          ShowSnackBar.snackBar("Error type consequence inc sec sync : ",
              err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type consequence inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncCauseTypiqueIncSecToSQLServer() async {
    try {
      isDataProcessing(true);
      List<CauseTypiqueModel> listCauseTypiqueIncSecSync =
          await localIncidentSecuriteService
              .readCauseTypiqueIncSecRattacherByOnline();
      for (var i = 0; i < listCauseTypiqueIncSecSync.length; i++) {
        debugPrint(
            'cause typique inc sec sync : ${listCauseTypiqueIncSecSync[i].idIncident} - ${listCauseTypiqueIncSecSync[i].causeTypique}');
        await IncidentSecuriteService().saveCauseTypiqueByIncident({
          "idIncident": listCauseTypiqueIncSecSync[i].idIncident,
          "idCauseTypique": listCauseTypiqueIncSecSync[i].idCauseTypique
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type consequence inc sec sync: ${err.toString()}');
          ShowSnackBar.snackBar("Error type consequence inc sec sync : ",
              err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type consequence inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncSiteLesionIncSecToSQLServer() async {
    try {
      isDataProcessing(true);
      List<SiteLesionModel> listSiteLesionIncSecSync =
          await localIncidentSecuriteService
              .readSiteLesionIncSecRattacherByonline();
      for (var i = 0; i < listSiteLesionIncSecSync.length; i++) {
        debugPrint(
            'site lesion inc sec sync : ${listSiteLesionIncSecSync[i].idIncident} - ${listSiteLesionIncSecSync[i].siteLesion}');
        await IncidentSecuriteService().saveSiteLesionByIncident({
          "idIncident": listSiteLesionIncSecSync[i].idIncident,
          "idSiteLesion": listSiteLesionIncSecSync[i].codeSiteLesion
        }).then((resp) async {}, onError: (err) {
          if (kDebugMode)
            print('error type consequence inc sec sync: ${err.toString()}');
          ShowSnackBar.snackBar("Error type consequence inc sec sync : ",
              err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Sync type consequence inc env", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncActionIncSecRattacherToSQLServer() async {
    try {
      isDataProcessing.value = true;
      List<ActionIncSec> listAction = await localIncidentSecuriteService
          .readActionSecEnvRattacherByOnline();
      for (var i = 0; i < listAction.length; i++) {
        debugPrint(
            'Action Inc Sec sync : ${listAction[i].idFiche} - ${listAction[i].act}');
        await IncidentSecuriteService().saveActionIncidentSecurite({
          "idFiche": listAction[i].idFiche,
          "idAct": listAction[i].nAct
        }).then((resp) async {}, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Action Inc Sec Rattacher", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception Action Sec Env', exception.toString(), Colors.deepOrange);
    } finally {
      isDataProcessing(false);
    }
  }

  //sync visite securite
  Future<void> syncVisiteSecuriteToSQLServer() async {
    try {
      isDataProcessing(true);
      List<VisiteSecuriteModel> listVisiteSecSync =
          await localVisiteSecuriteService.readListVisiteSecuriteByOnline();
      for (var i = 0; i < listVisiteSecSync.length; i++) {
        debugPrint(
            'visite securite sync : ${listVisiteSecSync[i].id} - ${listVisiteSecSync[i].site} - ${listVisiteSecSync[i].unite}');

        List<EquipeModel> listEquipeToSync =
            List<EquipeModel>.empty(growable: true);
        /* var responseEquipe = await localVisiteSecuriteService.readEquipeVisiteSecuriteEmployeById(listVisiteSecSync[i].id);
        responseEquipe.forEach((element) async {
          var modelToSync = EquipeModel();
          modelToSync.mat = element['mat'];
          modelToSync.affectation = element['affectation'];
          listEquipeToSync.add(modelToSync);
        }); */

        List<EquipeModel> listEquipeVisiteSecSync =
            await localVisiteSecuriteService
                .readListEquipeVisiteSecuriteEmployeById(
                    listVisiteSecSync[i].id);
        debugPrint('list equipe sync : ${listEquipeVisiteSecSync}');
        for (var j = 0; j < listEquipeVisiteSecSync.length; j++) {
          debugPrint(
              'equipe vs sync : ${listEquipeVisiteSecSync[j].mat} - ${listEquipeVisiteSecSync[j].affectation}');
          var modelToSync = EquipeModel();
          modelToSync.mat = listEquipeVisiteSecSync[j].mat;
          modelToSync.affectation = listEquipeVisiteSecSync[j].affectation;
          listEquipeToSync.add(modelToSync);
        }

        final dateVisite = listVisiteSecSync[i].dateVisite;
        DateTime? dt1 = DateTime.tryParse(dateVisite!);
        await VisiteSecuriteService().saveVisiteSecurite({
          "idSite": listVisiteSecSync[i].codeSite,
          "dateVisite": DateFormat('dd/MM/yyyy').format(dt1!),
          "idUnite": listVisiteSecSync[i].idUnite,
          "idZone": listVisiteSecSync[i].idZone,
          "comportementObserve": listVisiteSecSync[i].comportementSurObserve,
          "comportementRisque": listVisiteSecSync[i].comportementRisqueObserve,
          "correctImmediate": listVisiteSecSync[i].correctionImmediate,
          "autres": listVisiteSecSync[i].autres,
          "idCHK": listVisiteSecSync[i].idCheckList,
          "stObserve": listVisiteSecSync[i].situationObserve,
          "equipes": listEquipeVisiteSecSync //listEquipeToSync
        }).then((resp) async {
          //await localSecuriteEnvironnementService.deleteIncidentEnvironnementOffline();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar(
              "Error Visite Securite sync", err.toString(), Colors.red);
        });
      }
      //upload images
      List<UploadImageModel> listImages =
          await localVisiteSecuriteService.readImagesVisiteSecurite();
      for (var i = 0; i < listImages.length; i++) {
        debugPrint(
            'image visite sec sync : ${listImages[i].idFiche} - ${listImages[i].fileName.toString()} - ${listImages[i].image.toString()}');
        await VisiteSecuriteService().uploadImageVisiteSec({
          "image": listImages[i].image.toString(),
          "idFiche": listImages[i].idFiche,
          "fileName": listImages[i].fileName.toString()
        }).then((resp) async {
          await localVisiteSecuriteService.deleteTableImageVisiteSecurite();
        }, onError: (err) {
          isDataProcessing(false);
          // ShowSnackBar.snackBar("Error upload images", err.toString(), Colors.red);
        });
      }
    } catch (error) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Error Visite securite Sync", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncEquipeVSToSQLServer() async {
    try {
      List<EquipeVisiteSecuriteModel> listEquipe =
          await localVisiteSecuriteService.readListEquipeVSOffline();
      for (var i = 0; i < listEquipe.length; i++) {
        debugPrint(
            'sync equipe vs : ${listEquipe[i].id} - ${listEquipe[i].mat} - ${listEquipe[i].nompre}');
        await VisiteSecuriteService().saveEquipeVisiteSecurite({
          "idFiche": listEquipe[i].id,
          "respMat": listEquipe[i].mat,
          "affectation": listEquipe[i].affectation
        }).then((resp) {}, onError: (err) {
          ShowSnackBar.snackBar(
              "Error equipe Visite securite Sync", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception equipe Visite securite Sync",
          exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncCheckListVSToSQLServer() async {
    try {
      List<CheckListCritereModel> listCheckList =
          await localVisiteSecuriteService.readCheckListRattacherByOnline();
      for (var i = 0; i < listCheckList.length; i++) {
        debugPrint(
            'sync checklist vs : ${listCheckList[i].idFiche} - ${listCheckList[i].id} - ${listCheckList[i].lib}');
        await VisiteSecuriteService().saveCheckListCritere({
          "id": listCheckList[i].id,
          "eval": listCheckList[i].eval,
          "commentaire": listCheckList[i].commentaire
        }).then((resp) {}, onError: (err) {
          ShowSnackBar.snackBar("Error CheckList Visite securite Sync",
              err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception CheckList Visite securite Sync",
          exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }

  Future<void> syncActionVSRattacherToSQLServer() async {
    try {
      isDataProcessing.value = true;
      List<ActionVisiteSecurite> listActionVS =
          await localVisiteSecuriteService.readActionVSRattacherByOnline();
      for (var i = 0; i < listActionVS.length; i++) {
        debugPrint(
            'Action visite securite sync : ${listActionVS[i].idFiche} - ${listActionVS[i].act}');
        await VisiteSecuriteService().saveActionVisiteSecurite({
          "idFiche": listActionVS[i].idFiche,
          "idAct": listActionVS[i].nAct
        }).then((resp) async {}, onError: (err) {
          ShowSnackBar.snackBar(
              "Error Action VS Rattacher", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          'Exception', exception.toString(), Colors.deepOrange);
    } finally {
      isDataProcessing(false);
    }
  }
}
