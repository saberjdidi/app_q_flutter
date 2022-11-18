import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Models/audit/check_list_model.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Services/audit/local_audit_service.dart';
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
  List<CheckListAuditModel> listCheckList =
      List<CheckListAuditModel>.empty(growable: true);

  getData() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        final response =
            await LocalAuditService().readCheckListAudit(widget.model.refAudit);
        response.forEach((element) {
          setState(() {
            var model = new CheckListAuditModel();
            model.online = element['online'];
            model.refAudit = element['refAudit'];
            model.codeChamp = element['codeChamp'];
            model.champ = element['champ'];
            model.tauxEval = element['tauxEval'];
            model.tauxConf = element['tauxConf'];
            model.nbConst = element['nbConst'];
            listCheckList.add(model);
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        await AuditService()
            .getCheckListByRefAudit(widget.model.refAudit, 1)
            .then((response) {
          response.forEach((element) {
            setState(() {
              var model = new CheckListAuditModel();
              model.online = 1;
              model.refAudit = element['refAudit'];
              model.codeChamp = element['code_champ'];
              model.champ = element['champ'];
              model.tauxEval = element['taux_eval'];
              model.tauxConf = element['taux_conf'];
              model.nbConst = element['nb_const'];
              listCheckList.add(model);
            });
          });
        }, onError: (error) {
          if (kDebugMode) print('error : ${error.toString()}');
          ShowSnackBar.snackBar('Error', error.toString(), Colors.redAccent);
        });
      }
    } catch (exception) {
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
          onPressed: () {
            Get.back();
            //Get.find<AuditController>().listAudit.clear();
            //Get.find<AuditController>().getData();
            //Get.toNamed(AppRoute.audit);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
        title: Text(
          'CheckList Ref Audit N°${widget.model.refAudit}',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
          child: listCheckList.isNotEmpty
              ? RefreshWidget(
                  keyRefresh: keyRefresh,
                  onRefresh: () async {
                    listCheckList.clear();
                    getData();
                  },
                  child: ListView.builder(
                      itemCount: listCheckList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFFE9EAEE),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '${'champ_audit'.tr} : ${listCheckList[index].champ}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                    '${'taux_controle'.tr} : ${listCheckList[index].tauxEval}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    '${'taux_conformite'.tr} : ${listCheckList[index].tauxConf}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                Get.to(
                                    CritereCheckListPage(
                                        modelCheckList: listCheckList[index],
                                        modelAudit: widget.model),
                                    transition: Transition.fade);
                              },
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Color(0xAE1B23B6),
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      }))
              : Center(
                  child: Text('empty_list'.tr,
                      style:
                          TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold')),
                )),
    );
  }
}
