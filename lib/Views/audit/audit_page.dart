import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:qualipro_flutter/Controllers/audit/audit_controller.dart';
import 'package:qualipro_flutter/Services/audit/audit_service.dart';
import 'package:qualipro_flutter/Views/audit/auditeur/auditeur_externe_page.dart';
import '../../Models/pnc/isps_pnc_model.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/build_shimmer.dart';
import '../../Widgets/empty_list_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'audit_widget.dart';
import 'auditeur/auditeur_interne_page.dart';
import 'checklist/check_list_page.dart';
import 'constat/constat_audit_page.dart';
import 'new_audit_page.dart';

class AuditPage extends GetView<AuditController> {
  final _contentStyleHeader = const TextStyle(
      color: Color(0xff060f7d),
      fontSize: 15,
      fontWeight: FontWeight.w700,
      fontFamily: "Brand-Bold");
  final _contentStyle = const TextStyle(
      color: Color(0xff0c2d5e),
      fontSize: 14,
      fontWeight: FontWeight.normal,
      fontFamily: "Brand-Regular");

  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Audit',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return BuildShimmer();
              });
          /* return Center(
            child: LoadingView(),
          ); */
        } else {
          if (controller.listAudit.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<AuditController>().listAudit.clear();
                Get.find<AuditController>().getData();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 5.0),
                shrinkWrap: true,
                itemCount: controller.listAudit.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      key: const ValueKey(0),
                      child: AuditWidget(model: controller.listAudit[index]),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(ConstatAuditPage(
                                  model: controller.listAudit[index]));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.list,
                            label: 'Constat',
                          ),
                        ],
                      ),
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) async {
                              /* try {
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
                                  else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                                      await AuditService().getAuditByRefAudit(controller.listAudit[index].refAudit)
                                          .then((response){
                                        controller.nomAudit.value = response['audit'];

                                        print(' audit : ${controller.nomAudit.value}');
                                      },
                                      onError: (error){
                                        ShowSnackBar.snackBar('error', error.toString(), Colors.red);
                                      });
                                  }
                                }
                                catch(exception) {
                                  ShowSnackBar.snackBar('Exception', exception.toString(), Colors.red);
                                }
                                */

                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30))),
                                  builder: (context) =>
                                      DraggableScrollableSheet(
                                        expand: false,
                                        initialChildSize: 0.8,
                                        maxChildSize: 0.9,
                                        minChildSize: 0.6,
                                        builder: (context, scrollController) =>
                                            SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Center(
                                                child: Text(
                                                  'Ref Audit N°${controller.listAudit[index].refAudit}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: "Brand-Bold",
                                                      color: Color(0xFF0769D2),
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Column(
                                                children: [
                                                  ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 50),
                                                    child: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(CustomColors
                                                                    .googleBackground),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .all(14)),
                                                      ),
                                                      icon: Icon(Icons.list),
                                                      label: Text(
                                                        '${'auditeur'.tr} ${'interne'.tr}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Get.to(AuditeurInternePage(
                                                            numFiche: controller
                                                                .listAudit[
                                                                    index]
                                                                .refAudit));
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 50),
                                                    child: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFD10B3E3)),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .all(14)),
                                                      ),
                                                      icon: Icon(Icons.list),
                                                      label: Text(
                                                        '${'auditeur'.tr} ${'externe'.tr}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Get.to(AuditeurExternePage(
                                                            numFiche: controller
                                                                .listAudit[
                                                                    index]
                                                                .refAudit));
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ConstrainedBox(
                                                    constraints:
                                                        BoxConstraints.tightFor(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 50),
                                                    child: ElevatedButton.icon(
                                                      style: ButtonStyle(
                                                        shape:
                                                            MaterialStateProperty
                                                                .all(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xFF6C13D2)),
                                                        padding:
                                                            MaterialStateProperty
                                                                .all(EdgeInsets
                                                                    .all(14)),
                                                      ),
                                                      icon: Icon(Icons.list),
                                                      label: Text(
                                                        'Checklist',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Get.to(CheckListPage(
                                                            model: controller
                                                                    .listAudit[
                                                                index]));
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Divider(
                                                      height: 2.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: ListBody(
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'id Audit : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].idAudit}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Ref. Audit : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].refAudit}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Description Audit : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].audit}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '${'champ_audit'.tr} : ',
                                                                style:
                                                                    _contentStyleHeader,
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width /
                                                                    1.5,
                                                                child: Html(
                                                                  data: controller
                                                                      .listAudit[
                                                                          index]
                                                                      .champ, //htmlData,
                                                                  //tagsList: Html.tags..remove(Platform.isAndroid ? "-" : ""),
                                                                  style: {
                                                                    "body": Style(
                                                                        //backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                                                        fontSize: FontSize.medium,
                                                                        fontWeight: FontWeight.normal,
                                                                        margin: EdgeInsets.zero,
                                                                        textTransform: TextTransform.none),
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        //SizedBox(height: 5.0,),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${'date_debut_prevue'.tr} : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                controller
                                                                            .listAudit[
                                                                                index]
                                                                            .dateDebPrev ==
                                                                        null
                                                                    ? ''
                                                                    : controller.langue ==
                                                                            'fr'
                                                                        ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.listAudit[index].dateDebPrev.toString()))}'
                                                                        : '${DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.listAudit[index].dateDebPrev.toString()))}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${'date_fin_prevue'.tr} : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                controller
                                                                            .listAudit[
                                                                                index]
                                                                            .dateFinPrev ==
                                                                        null
                                                                    ? ''
                                                                    : controller.langue ==
                                                                            'fr'
                                                                        ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.listAudit[index].dateFinPrev.toString()))}'
                                                                        : '${DateFormat('MM/dd/yyyy').format(DateTime.parse(controller.listAudit[index].dateFinPrev.toString()))}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Site : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].site}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Type audit : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].typeA}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Objective : ',
                                                              style:
                                                                  _contentStyleHeader,
                                                            ),
                                                            Text(
                                                                '${controller.listAudit[index].objectif}',
                                                                style:
                                                                    _contentStyle),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        (controller
                                                                        .listAudit[
                                                                            index]
                                                                        .rapportClot ==
                                                                    null ||
                                                                controller
                                                                        .listAudit[
                                                                            index]
                                                                        .rapportClot ==
                                                                    '')
                                                            ? Text('')
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    '${'rapport'.tr} ${'cloture'.tr} : ',
                                                                    style:
                                                                        _contentStyleHeader,
                                                                  ),
                                                                  Text(
                                                                      '${controller.listAudit[index].rapportClot}',
                                                                      style:
                                                                          _contentStyle),
                                                                ],
                                                              ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            //icon: Icons.list,
                            label: 'Details',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return EmptyListWidget();
          }
        }
      }),
      floatingActionButton: SpeedDial(
        buttonSize: Size(50, 50),
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10.0,
        closeManually: false,
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 15.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.add, color: Colors.blue, size: 32),
              label: '${'new'.tr} Audit',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: () {
                Get.to(() => NewAuditPage(),
                    transition: Transition.zoom,
                    duration: Duration(milliseconds: 500));
              }),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Audit',
              onTap: () {
                //etat
                Future<List<ISPSPNCModel>> getEtat(filter) async {
                  try {
                    List<ISPSPNCModel> ispsList = [
                      ISPSPNCModel(value: "1", name: 'non_encore_realise'.tr),
                      ISPSPNCModel(value: "2", name: 'realise'.tr),
                      ISPSPNCModel(value: "3", name: 'reporte'.tr),
                      ISPSPNCModel(value: "4", name: 'annule'.tr),
                      ISPSPNCModel(
                          value: "5", name: 'en_cours_de_validation'.tr),
                      ISPSPNCModel(value: "6", name: 'en_cours_elaboration'.tr),
                    ];

                    return ispsList;
                  } catch (exception) {
                    ShowSnackBar.snackBar(
                        "Exception", exception.toString(), Colors.red);
                    return Future.error('service : ${exception.toString()}');
                  }
                }

                //ISPS
                Widget _customDropDownEtat(
                    BuildContext context, ISPSPNCModel? item) {
                  if (item == null) {
                    return Container();
                  }
                  return Container(
                    child: (item.name == null)
                        ? ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(""),
                          )
                        : ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text('${item.name}'),
                          ),
                  );
                }

                Widget _customPopupItemBuilderEtat(
                    BuildContext context, ISPSPNCModel? item, bool isSelected) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: !isSelected
                        ? null
                        : BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                    child: ListTile(
                      selected: isSelected,
                      title: Text(item?.name ?? ''),
                      //subtitle: Text(item?.value.toString() ?? ''),
                    ),
                  );
                }

                //dialog
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: Center(
                        child: Text(
                          '${'search'.tr} Audit',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Signatra",
                              color: Color(0xFF0769D2),
                              fontSize: 30.0),
                        ),
                      ),
                      titlePadding: EdgeInsets.only(top: 2.0),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller.searchNumero,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: new InputDecoration(
                                      hintText: 'Ref Audit',
                                      border: InputBorder.none),
                                ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchNumero.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller.searchType,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'Type',
                                      border: InputBorder.none),
                                ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchType.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: DropdownSearch<ISPSPNCModel>(
                                showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: false,
                                isFilteredOnline: true,
                                mode: Mode.DIALOG,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: 'etat'.tr,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                                onFind: (String? filter) => getEtat(filter),
                                onChanged: (data) {
                                  controller.search_etat = data?.value;
                                  if (data == null) {
                                    controller.search_etat = "0";
                                  }
                                  print(
                                      'etat value :${controller.search_etat}');
                                },
                                dropdownBuilder: _customDropDownEtat,
                                popupItemBuilder: _customPopupItemBuilderEtat,
                              ),
                            )
                          ],
                        ),
                      ),
                      contentPadding: EdgeInsets.only(right: 5.0, left: 5.0),
                      actionsPadding: EdgeInsets.all(1.0),
                      actions: <Widget>[
                        TextButton(
                          child: Text('cancel'.tr),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.find<AuditController>().listAudit.clear();
                            Get.find<AuditController>().searchAudit();
                            Get.back();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              CustomColors.googleBackground,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'search'.tr,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: CustomColors.firebaseWhite,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label: 'Synchronisation',
              onTap: () {
                controller.syncAuditToWebService();
              })
        ],
      ),
    );
  }
}
