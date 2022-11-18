import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';

import '../../../Models/action/action_realisation_model.dart';
import '../../../Models/action/action_suite_audit.dart';
import '../../../Models/action/action_model.dart';
import '../../../Services/action/action_service.dart';
import '../../../Services/action/local_action_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/action/sous_action/sous_action_page.dart';
import '../../../Views/home_page.dart';
import '../../../Widgets/loading_widget.dart';
import 'remplir_action_realisation.dart';

class ActionSuiteAuditPage extends StatefulWidget {
  ActionSuiteAuditPage({Key? key}) : super(key: key);

  @override
  State<ActionSuiteAuditPage> createState() => _ActionSuiteAuditPageState();
}

class _ActionSuiteAuditPageState extends State<ActionSuiteAuditPage> {
  LocalActionService localService = LocalActionService();
  final matricule = SharedPreference.getMatricule();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<ActionSuiteAudit> listAction =
      List<ActionSuiteAudit>.empty(growable: true);
  List<ActionSuiteAudit> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getActionsSuiteAudit();
  }

  void getActionsSuiteAudit() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        var response = await localService.readActionSuiteAudit();
        response.forEach((data) {
          setState(() {
            var model = ActionSuiteAudit();
            model.nact = data['nAct'];
            model.act = data['act'];
            model.ind = data['ind'];
            model.datsuivPrv = data['datsuivPrv'];
            model.isd = data['isd'];
            listAction.add(model);
            listFiltered = listAction;
            listAction.forEach((element) {
              print('element act ${element.act}, id act: ${element.act}');
            });
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
        //rest api
        await ActionService().getActionSuiteAudit(matricule).then((resp) async {
          resp.forEach((data) async {
            setState(() {
              var model = ActionSuiteAudit();
              model.nact = data['nact'];
              model.act = data['act'];
              model.ind = data['ind'];
              model.datsuivPrv = data['datsuiv_prv'];
              model.isd = data['isd'];
              listAction.add(model);
              listFiltered = listAction;
              listAction.forEach((element) {
                print('element act ${element.act}, id act: ${element.act}');
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
            'Actions suite à audit ${listAction.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listAction.isNotEmpty
                ? RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: () async {
                      controller.clear();
                      listAction.clear();
                      getActionsSuiteAudit();
                    },
                    child: Column(
                      children: <Widget>[
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
                                      listFiltered = listAction;
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
                                listFiltered = listAction
                                    .where((user) =>
                                        user.nact
                                            .toString()
                                            .contains(_searchResult) ||
                                        user.act!
                                            .toLowerCase()
                                            .contains(_searchResult))
                                    .toList();
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            itemCount: listFiltered.length,
                            itemBuilder: (context, index) {
                              final num_action = listFiltered[index].nact;
                              return Card(
                                color: Color(0xF2F2F2F2),
                                clipBehavior: Clip.antiAlias,
                                child: ListTile(
                                  title: Text(
                                    ' Action N° ${num_action}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: RichText(
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
                                                        '${listFiltered[index].datsuivPrv}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ReadMoreText(
                                          "${listFiltered[index].act}",
                                          style: TextStyle(
                                              color: Color(0xFF2F6AA8),
                                              fontWeight: FontWeight.bold),
                                          trimLines: 3,
                                          colorClickableText:
                                              CustomColors.bleuCiel,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'more',
                                          trimExpandedText: 'less',
                                          moreStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CustomColors.bleuCiel),
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    padding: EdgeInsets.only(top: 25.0),
                                    child: IconButton(
                                      onPressed: () async {
                                        Get.to(SousActionPage(), arguments: {
                                          "id_action": num_action
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
