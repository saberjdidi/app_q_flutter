import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/pnc/local_pnc_service.dart';

import '../../Models/pnc/pnc_model.dart';
import '../../Services/pnc/pnc_service.dart';
import '../../Utils/shared_preference.dart';
import '../../Utils/snack_bar.dart';
import '../api_controllers_call.dart';
import '../sync_data_controller.dart';

class PNCController extends GetxController {
  var listPNC = List<PNCModel>.empty(growable: true).obs;
  var filterPNC = List<PNCModel>.empty(growable: true);
  var isDataProcessing = false.obs;
  LocalPNCService localPNCService = LocalPNCService();
  final matricule = SharedPreference.getMatricule();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getPNC();
    //checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void getPNC() async {
    try {
      isDataProcessing.value = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //get local data
        var response = await localPNCService.readPNC();
        response.forEach((data) {
          var model = PNCModel();
          model.nnc = data['nnc'];
          model.nc = data['nc'];
          model.codePdt = data['codePdt'];
          model.codeTypeNC = data['codeTypeNC'];
          model.dateDetect = data['dateDetect'];
          model.valRej = data['valRej'];
          model.unite = data['unite'];
          model.recep = data['recep'];
          model.qteDetect = data['qteDetect'];
          model.traitee = data['traitee'];
          model.online = data['online'];
          model.etatNC = data['etatNC'];

          model.numInterne = data['numInterne'];
          model.numeroOf = data['numeroOf'];
          model.numeroLot = data['numeroLot'];
          model.rapportT = data['rapportT'];
          model.typeNC = data['typeNC'];
          model.produit = data['produit'];
          model.site = data['site'];
          model.fournisseur = data['fournisseur'];
          listPNC.add(model);
          /* listPNC.forEach((element) {
            print('element nc ${element.nc}');
          }); */
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //rest api
        await PNCService().getPNC(matricule).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            print('get pnc : ${data} ');
            var model = PNCModel();
            model.nnc = data['nnc'];
            model.nc = data['nc'];
            model.codeTypeNC = data['codeTypeNC'];
            model.dateDetect = data['dateDetect'];
            model.traitee = data['traitee'];
            model.online = 1;
            model.etatNC = data['etatNC'];

            model.numInterne = data['ninterne'];
            model.numeroOf = data['numOf'];
            model.numeroLot = data['nlot'];
            model.rapportT = data['rapportT'];
            model.typeNC = data['typeNC'];
            model.produit = data['produit'];
            model.site = data['site'];
            model.fournisseur = data['frs'];

            listPNC.add(model);
            /* listPNC.forEach((element) {
              print('element nc ${element.nc}');
            }); */
          });
        }, onError: (err) {
          isDataProcessing.value = false;
          ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing.value = false;
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
      print('Exception : ${exception.toString()}');
    } finally {
      isDataProcessing.value = false;
    }
  }

  //synchronization
  Future syncPNCToWebService() async {
    try {
      isDataProcessing(true);
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No Connection", "Cannot synchronize Data",
            colorText: Colors.blue, snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        /*   var response = await localPNCService.readPNCByOnline();
        response.forEach((data) async{
          print('data: ${data['nc']}');
          await PNCService().savePNC({
            "codePdt": data['codePdt'],
            "codeTypeNC": data['codeTypeNC'],
            "dateDetect": data['dateDetect'],
            "nc": data['nc'],
            "recep": data['recep'],
            "qteDetect": data['qteDetect'],
            "unite": data['unite'],
            "valRej": data['valRej'],
            "traitement": "",
            "ctr": 0,
            "ctt": 0,
            "traitee": data['traitee'],
            "respTrait": "",
            "numOf": data['numeroOf'],
            "delaiTrait": data['dateSaisie'],
            "qteRej": 0,
            "matOrigine": data['matOrigine'],
            "ngravite": data['codeGravite'],
            "repSuivi": "",
            "cloturee": 0,
            "dateT": data['dateSaisie'],
            "codeSite": data['codeSite'],
            "codeSourceNC": data['codeSource'],
            "codeTypeT": 0,
            "nLot": data['numeroLot'],
            "rapportT": "",
            "nAct": 0,
            "dateClot": data['dateSaisie'],
            "rapportClot": "",
            "bloque": data['bloque'],
            "isole": data['isole'],
            "numCession": "",
            "numEnvoi": "",
            "dateSaisie": data['dateSaisie'],
            "matEnreg": matricule.toString(),
            "qtConforme": 0,
            "qtNonConforme": 0,
            "prix": 0,
            "dateLiv": data['dateLivraison'], //dateLivraisonController.text,
            "atelier": data['codeAtelier'],
            "qteprod": data['qteProduct'],
            "ninterne": data['numInterne'],
            "det_type": 0,
            "avec_retour": 0,
            "processus": data['codeProcessus'],
            "domaine": data['codeActivity'],
            "direction": data['codeDirection'],
            "service": data['codeService'],
            "id_client": data['codeClient'],
            "actionIm": data['actionIm'],
            "causeNC": "default",
            "isps": data['isps'],
            "id_fournisseur": data['codeFournisseur'],
            "pourcentage": data['pourcentage']
          }).then((resp) async {
            //await localPNCService.deletePNCOffline();
            ShowSnackBar.snackBar("${data['nc']} added", "Synchronization successfully", Colors.green);
            listPNC.clear();
            getPNC();
          }, onError: (err) {
            isDataProcessing(false);
            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
          });
        }); */
        //sync to DB
        await SyncDataController().syncPNCToSQLServer();
        await SyncDataController().syncProductPNCToSQLServer();
        await SyncDataController().syncTypeCausePNCToSQLServer();
        await SyncDataController().syncTypeProductPNCToSQLServer();
        //save pnc data in db local
        await PNCService().getPNC(matricule).then((resp) async {
          //delete table
          await localPNCService.deleteTablePNC();
          resp.forEach((data) async {
            //print('get site : ${data} ');
            var model = PNCModel();
            model.online = 1;
            model.nnc = data['nnc'];
            model.nc = data['nc'];
            model.codePdt = data['codePdt'];
            model.codeTypeNC = data['codeTypeNC'];
            model.dateDetect = data['dateDetect'];
            model.valRej = data['valRej'];
            model.unite = data['unite'];
            model.recep = data['recep'];
            model.qteDetect = data['qteDetect'];
            model.traitee = data['traitee'];
            model.etatNC = data['etatNC'];
            model.numInterne = data['ninterne'];
            model.numeroOf = data['numOf'];
            model.numeroLot = data['nlot'];
            model.rapportT = data['rapportT'];
            if (data['typeNC'] == null) {
              model.typeNC = '';
            } else {
              model.typeNC = data['typeNC'];
            }
            model.produit = data['produit'];
            model.site = data['site'];
            model.fournisseur = data['frs'];

            //save data
            await localPNCService.savePNC(model);
            print(
                'Inserting data in table PNC : ${model.nnc}-${model.nc}-${model.produit}');
          });
          listPNC.clear();
          getPNC();
        }, onError: (err) {
          isDataProcessing(false);
          ShowSnackBar.snackBar("Error PNC", err.toString(), Colors.red);
        });

        await ApiControllersCall().getAllProductsPNC();
        await ApiControllersCall().getAllTypeCausePNC();
        await PNCService().parametrageProduct().then((param) {
          Future oneProduct =
              SharedPreference.setIsOneProduct(param['seulProduit']);
          if (param['seulProduit'] == 0) {
            ApiControllersCall().getAllTypeProductPNC();
          }
        }, onError: (error) {
          ShowSnackBar.snackBar(
              'Error one product', error.toString(), Colors.red);
        });
      }
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      isDataProcessing(false);
    }
  }
}
