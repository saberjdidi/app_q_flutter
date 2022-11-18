import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';

import '../../../Models/action/action_realisation_model.dart';
import '../../../Models/action/action_suivi_model.dart';
import '../../../Models/action/action_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import '../../../Widgets/loading_widget.dart';
import 'remplir_action_realisation.dart';
import 'remplir_action_suivi.dart';

class ActionSuiviPage extends StatefulWidget {
  ActionSuiviPage({Key? key}) : super(key: key);

  @override
  State<ActionSuiviPage> createState() => _ActionSuiviPageState();
}

class _ActionSuiviPageState extends State<ActionSuiviPage> {
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  LocalActionService localService = LocalActionService();
  final matricule = SharedPreference.getMatricule();
  List<ActionSuiviModel> listActionSuivi =
      List<ActionSuiviModel>.empty(growable: true);
  List<ActionSuiviModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    //checkConnectivity();
    getActionsSuivi();
  }

  Future<void> checkConnectivity() async {
    var connection = await Connectivity().checkConnectivity();
    if (connection == ConnectivityResult.none) {
      Get.snackbar("No Connection", "Mode Offline",
          colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    } else if (connection == ConnectivityResult.wifi ||
        connection == ConnectivityResult.mobile) {
      Get.snackbar("Internet Connection", "Mode Online",
          colorText: Colors.blue, snackPosition: SnackPosition.TOP);
    }
  }

  void getActionsSuivi() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await localService.readActionSuivi();
        response.forEach((data) {
          setState(() {
            var model = ActionSuiviModel();
            model.nSousAct = data['nSousAct'];
            model.pourcentReal = data['pourcentReal'];
            model.causeModif = data['causeModif'];
            model.dateSuivi = data['dateSuivi'];
            model.act = data['act'];
            model.dateReal = data['dateReal'];
            model.nAct = data['nAct'];
            model.sousAct = data['sousAct'];
            model.delaiSuivi = data['delaiSuivi'];
            model.nomprerr = data['nomPrenom'];
            model.pourcentSuivie = data['pourcentSuivie'];
            model.rapportEff = data['rapportEff'];
            model.depense = data['depense'];
            model.commentaire = data['commentaire'];
            model.dateSaisieSuiv = data['dateSaisieSuiv'];
            model.priorite = data['priorite'];
            model.gravite = data['gravite'];
            listActionSuivi.add(model);
            listFiltered = listActionSuivi;
            listActionSuivi.forEach((element) {
              print('element act ${element.act}, id act: ${element.nAct}');
            });
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

        //rest api
        await ActionService().getActionSuivi({
          "mat": matricule.toString(),
          "ch_s": "0",
          "nact": 0,
          "nsact": ""
        }).then((resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = ActionSuiviModel();
              model.nSousAct = data['nSousAct'];
              model.pourcentReal = data['pourcentReal'];
              model.causeModif = data['causeModif'];
              model.dateSuivi = data['dateSuivi'];
              model.act = data['act'];
              model.dateReal = data['dateReal'];
              model.nAct = data['nAct'];
              model.sousAct = data['sousAct'];
              model.delaiSuivi = data['delaiSuivi'];
              model.nomprerr = data['nomprerr'];
              model.pourcentSuivie = data['pourcentSuivie'];
              model.rapportEff = data['rapportEff'];
              model.depense = data['depense'];
              model.isd = data['isd'];
              model.expr1 = data['expr1'];
              model.designation = data['designation'];
              model.commentaire = data['commentaire'];
              model.dateSaisieSuiv = data['date_Saisie_Suiv'];
              model.ind = data['ind'];
              model.priorite = data['priorite'];
              model.gravite = data['gravite'];
              listActionSuivi.add(model);
              listFiltered = listActionSuivi;
              listActionSuivi.forEach((element) {
                print('element act ${element.act}, id act: ${element.nAct}');
              });
            });
          });
        }, onError: (err) {
          ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
        });
      }
    } catch (exception) {
      ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
    } finally {
      //isDataProcessing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            lightPrimary,
            darkPrimary,
          ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Get.offAll(HomePage());
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Actions à suivre ${listActionSuivi.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listActionSuivi.isNotEmpty
                ? RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: () async {
                      controller.clear();
                      listActionSuivi.clear();
                      getActionsSuivi();
                    },
                    child: Column(
                      children: <Widget>[
                        /* Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                          controller: controller,
                          decoration: new InputDecoration(
                              hintText: 'Search', border: InputBorder.none),
                          onChanged: (value) {
                            setState(() {
                              _searchResult = value;
                              listFiltered = listActionSuivi.where((user) => user.nAct.toString().contains(_searchResult)
                                  || user.nSousAct.toString().toLowerCase().contains(_searchResult)
                                  || user.nomprerr!.toLowerCase().contains(_searchResult)
                                  || user.rapportEff!.toLowerCase().contains(_searchResult)
                              ).toList();
                            });
                            print('controller change');
                          }),
                      trailing: new IconButton(
                        icon: controller.text.trim()=='' ?Text('') :Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            controller.clear();
                            _searchResult = '';
                            listFiltered = listActionSuivi;
                          });
                        },
                      ),
                    ),
                  ), */
                        Card(
                          //margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      controller.clear();
                                      _searchResult = '';
                                      listFiltered = listActionSuivi;
                                    });
                                  },
                                  child: controller.text.trim() == ''
                                      ? Text('')
                                      : Icon(Icons.cancel),
                                ),
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.blue))),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                listFiltered = listActionSuivi
                                    .where((user) =>
                                        user.nAct
                                            .toString()
                                            .contains(_searchResult) ||
                                        user.nomprerr!
                                            .toLowerCase()
                                            .contains(_searchResult))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final num_action = listFiltered[index].nAct;
                              final num_sous_action =
                                  listFiltered[index].nSousAct;
                              return Card(
                                color: Color(0xF2F2F2F2),
                                child: ListTile(
                                  title: Text(
                                    ' Action: ${num_action}   \n Sous Action: ${num_sous_action}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Icon(
                                                      Icons.calendar_today),
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '${listFiltered[index].dateSuivi}'),

                                              //TextSpan(text: '${action.declencheur}'),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            children: [
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 2.0),
                                                  child: Icon(Icons.person),
                                                ),
                                              ),
                                              TextSpan(
                                                  text:
                                                      '${listFiltered[index].nomprerr}'),

                                              //TextSpan(text: '${action.declencheur}'),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'Taux real : ${listFiltered[index].pourcentReal} %',
                                          style: TextStyle(
                                              color: Color(0xff111558),
                                              fontSize: 15),
                                        ),
                                        listFiltered[index].rapportEff == ''
                                            ? Text('')
                                            : ReadMoreText(
                                                "Rapport : ${listFiltered[index].rapportEff}",
                                                style: TextStyle(
                                                    color: Color(0xFF3B465E),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                trimLines: 2,
                                                colorClickableText:
                                                    CustomColors.bleuCiel,
                                                trimMode: TrimMode.Line,
                                                trimCollapsedText: 'more',
                                                trimExpandedText: 'less',
                                                moreStyle: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        CustomColors.bleuCiel),
                                              )
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child: IconButton(
                                      onPressed: () async {
                                        Get.to(RemplirActionSuivi(
                                            actionsuivi: listFiltered[index]));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),

                                  /// this function uses to navigate (move to next screen) User Details page and pass user objects into the User Details page. ///
                                  onTap: () {
                                    Get.to(RemplirActionSuivi(
                                        actionsuivi: listFiltered[index]));
                                  },
                                ),
                              );
                            },
                            itemCount: listFiltered.length,
                            //itemCount: actionsList.length + 1,
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: Text('Empty List',
                        style: TextStyle(
                            fontSize: 20.0, fontFamily: 'Brand-Bold')),
                  )),
      ),
    );
  }
}
