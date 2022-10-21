import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/audit/check_list_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Utils/snack_bar.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';

import '../../../Models/audit/audit_model.dart';
import '../../../Utils/shared_preference.dart';
import 'critere_checklist_page.dart';

class CheckListPage extends StatefulWidget {
  final AuditModel model;
  const CheckListPage({Key? key, required this.model}) : super(key: key);

  @override
  State<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {

  final matricule = SharedPreference.getMatricule();
  List<CheckListModel> listCheckList = List<CheckListModel>.empty(growable: true);

  getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.defaultDialog(
            title: 'mode_offline'.tr,
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            middleTextStyle: TextStyle(color: Colors.white),
            textCancel: "Back",
            onCancel: (){
              Get.back();
            },
            confirmTextColor: Colors.white,
            buttonColor: Colors.blue,
            barrierDismissible: false,
            radius: 20,
            content: Center(
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/empty_list.json', width: 150, height: 150),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('no_internet'.tr,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ),
                ],
              ),
            )
        );
      }
      else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile){
        await AuditService().getCheckListByRefAudit(widget.model.refAudit)
            .then((response){
              response.forEach((element) {
                setState(() {
                  var model = new CheckListModel();
                  model.codeChamp = element['code_champ'];
                  model.champ = element['champ'];
                  model.tauxEval = element['taux_eval'];
                  model.tauxConf = element['taux_conf'];
                  model.nbConst = element['nb_const'];
                  listCheckList.add(model);
                });
              });
        },
        onError: (error){
              if(kDebugMode) print('error : ${error.toString()}');
              ShowSnackBar.snackBar('Error', error.toString(), Colors.redAccent);
        });
      }
    }
    catch(exception) {
      ShowSnackBar.snackBar('Exception', exception.toString(), Colors.red);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
          onPressed: (){
            Get.back();
            //Get.find<AuditController>().listAudit.clear();
            //Get.find<AuditController>().getData();
            //Get.toNamed(AppRoute.audit);
          },
          child: Icon(Icons.arrow_back, color: Colors.blue,),
        ),
        title: Text(
          'CheckList of Ref Audit N°${widget.model.refAudit}',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(child:
      listCheckList.isNotEmpty
      ? RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: () async { 
            listCheckList.clear();
            getData();
          },
          child: ListView.builder(
            itemCount: listCheckList.length,
              itemBuilder: (context, index){
                return Card(
                  color: Color(0xFFE9EAEE),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'Champ audit : ${listCheckList[index].champ}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text('Taux de controle : ${listCheckList[index].tauxEval}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Taux de conformité : ${listCheckList[index].tauxConf}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Get.to(CritereCheckListPage(modelCheckList: listCheckList[index], modelAudit: widget.model), transition: Transition.fade);
                      },
                      child: Icon(Icons.remove_red_eye, color: Color(0xAE1B23B6), size: 30,),
                    ),
                  ),
                );
              }
          )
      )
      : Center(
        child: Text('empty_list'.tr, style: TextStyle(
      fontSize: 20.0,
      fontFamily: 'Brand-Bold'
      )),
      )
      ),

    );
  }
}
