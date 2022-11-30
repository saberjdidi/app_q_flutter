import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Widgets/refresh_widget.dart';
import 'package:readmore/readmore.dart';
import '../../../Models/pnc/pnc_suivre_model.dart';
import '../../../Services/pnc/local_pnc_service.dart';
import '../../../Services/pnc/pnc_service.dart';
import '../../../Utils/custom_colors.dart';
import '../../../Utils/shared_preference.dart';
import '../../../Utils/snack_bar.dart';
import '../../../Views/home_page.dart';
import '../../../Widgets/empty_list_widget.dart';
import 'remplir_pnc_investigation_approuver.dart';

class PNCInvestigationApprouverPage extends StatefulWidget {
  PNCInvestigationApprouverPage({Key? key}) : super(key: key);

  @override
  State<PNCInvestigationApprouverPage> createState() =>
      _PNCInvestigationApprouverPageState();
}

class _PNCInvestigationApprouverPageState
    extends State<PNCInvestigationApprouverPage> {
  PNCService localService = PNCService();
  final matricule = SharedPreference.getMatricule();
  final keyRefresh = GlobalKey<RefreshIndicatorState>();
  List<PNCSuivreModel> listPNCInvestigation =
      List<PNCSuivreModel>.empty(growable: true);
  List<PNCSuivreModel> listFiltered = [];
  TextEditingController controller = TextEditingController();
  String _searchResult = '';

  @override
  void initState() {
    super.initState();
    getPNCInvestigation();
  }

  void getPNCInvestigation() async {
    try {
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        var response = await LocalPNCService().readPNCInvestigationApprouver();
        response.forEach((data) {
          setState(() {
            var model = PNCSuivreModel();
            model.nnc = data['nnc'];
            model.dateDetect = data['dateDetect'];
            model.produit = data['produit'];
            model.typeNC = data['typeNC'];
            model.qteDetect = data['qteDetect'];
            model.codepdt = data['codepdt'];
            model.nlot = data['nlot'];
            model.ind = data['ind'];
            model.nomClt = data['nomClt'];
            listPNCInvestigation.add(model);
            listFiltered = listPNCInvestigation;
          });
        });
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.BOTTOM, duration: Duration(milliseconds: 900));
        //rest api
        await PNCService().getPNCInvestigationApprouver(matricule).then(
            (resp) async {
          //isDataProcessing(false);
          resp.forEach((data) async {
            setState(() {
              var model = PNCSuivreModel();
              model.nnc = data['nnc'];
              model.dateDetect = data['dateDetect'];
              model.produit = data['produit'];
              model.typeNC = data['typeNC'];
              model.qteDetect = data['qteDetect'];
              model.codepdt = data['codepdt'];
              model.nlot = data['nlot'];
              model.ind = data['ind'];
              model.nomClt = data['nomClt'];
              listPNCInvestigation.add(model);
              listFiltered = listPNCInvestigation;
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
        resizeToAvoidBottomInset: false,
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
            '${'investigation_a_approuver'.tr} : ${listPNCInvestigation.length}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: listPNCInvestigation.isNotEmpty
                ? RefreshWidget(
                    keyRefresh: keyRefresh,
                    onRefresh: () async {
                      controller.clear();
                      listPNCInvestigation.clear();
                      getPNCInvestigation();
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
                                      listFiltered = listPNCInvestigation;
                                    });
                                  },
                                  child: controller.text.trim() == ''
                                      ? Text('')
                                      : Icon(Icons.cancel),
                                ),
                                hintText: 'search'.tr,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.blue))),
                            onChanged: (value) {
                              setState(() {
                                _searchResult = value;
                                listFiltered = listPNCInvestigation
                                    .where((user) =>
                                        user.nnc
                                            .toString()
                                            .contains(_searchResult) ||
                                        user.typeNC!
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
                              final num_pnc = listFiltered[index].nnc;

                              return Card(
                                color: Color(0xFFFCF9F9),
                                child: ListTile(
                                  title: Text(
                                    'P.N.C N°${num_pnc}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
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
                                                      '${listFiltered[index].dateDetect}'),

                                              //TextSpan(text: '${action.declencheur}'),
                                            ],
                                          ),
                                        ),
                                        listFiltered[index].nomClt == null
                                            ? Text('')
                                            : RichText(
                                                textAlign: TextAlign.start,
                                                text: TextSpan(
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '${'client'.tr} : ${listFiltered[index].nomClt}'),
                                                  ],
                                                ),
                                              ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Html(
                                            data:
                                                '${'product'.tr} : ${listFiltered[index].produit}', //htmlData,
                                            //tagsList: Html.tags..remove(Platform.isAndroid ? "-" : ""),
                                            style: {
                                              "body": Style(
                                                  fontSize: FontSize.large,
                                                  fontWeight: FontWeight.w500,
                                                  margin: EdgeInsets.zero,
                                                  textTransform:
                                                      TextTransform.none),
                                            },
                                          ),
                                        ),
                                        ReadMoreText(
                                          "Type : ${listFiltered[index].typeNC}",
                                          style: TextStyle(
                                              color: Color(0xFF3B465E),
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
                                  trailing: IconButton(
                                    onPressed: () async {
                                      Get.to(RemplirPNCInvestigationApprouver(
                                        nnc: listFiltered[index].nnc,
                                      ));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                    tooltip: 'Investigation',
                                  ),
                                  onTap: () {
                                    Get.to(RemplirPNCInvestigationApprouver(
                                      nnc: listFiltered[index].nnc,
                                    ));
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
                : EmptyListWidget()),
      ),
    );
  }
}
