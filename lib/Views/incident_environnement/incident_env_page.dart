import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../Controllers/incident_environnement/incident_environnement_controller.dart';
import '../../Controllers/reunion/reunion_controller.dart';
import '../../Models/type_incident_model.dart';
import '../../Services/incident_environnement/incident_environnement_service.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'action/action_incident_environnement_page.dart';
import 'incident_env_widget.dart';
import 'new_incident_environnement.dart';
import 'type_cause/type_cause_incident_env_page.dart';
import 'type_consequence/type_consequence_incident_env_page.dart';

class IncidentEnvironnementPage extends GetView<IncidentEnvironnementController> {
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
          'Incident Environnement',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: (lightPrimary),
        elevation: 0,
        actions: [],
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return Center(
            child: LoadingView(),
          );
        } else {
          if (controller.listIncident.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<IncidentEnvironnementController>().listIncident.clear();
                Get.find<IncidentEnvironnementController>().getIncident();
              },
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: controller.listIncident.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      key: const ValueKey(0),
                      child: IncidentEnvWidget(model: controller.listIncident[index]),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30)
                                      )
                                  ),
                                  builder: (context) => DraggableScrollableSheet(
                                    expand: false,
                                    initialChildSize: 0.6,
                                    maxChildSize: 0.8,
                                    minChildSize: 0.4,
                                    builder: (context, scrollController) => SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          SizedBox(height: 5.0,),
                                          Center(
                                            child: Text('Incident Securite N°${controller.listIncident[index].n}', style: TextStyle(
                                                fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                                                color: Color(0xFF0769D2), fontSize: 25.0
                                            ),),
                                          ),
                                          SizedBox(height: 20.0,),
                                          Column(
                                            children: [

                                              ConstrainedBox(
                                                constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                                child: ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                    MaterialStateProperty.all(CustomColors.googleBackground),
                                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                                  ),
                                                  icon: Icon(Icons.list),
                                                  label: Text(
                                                    'Type Cause',
                                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(TypeCauseIncidentEnvPage(numIncident: controller.listIncident[index].n));
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              ConstrainedBox(
                                                constraints: BoxConstraints.tightFor(width: MediaQuery.of(context).size.width / 1.1, height: 50),
                                                child: ElevatedButton.icon(
                                                  style: ButtonStyle(
                                                    shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                    MaterialStateProperty.all(Color(0xFF0DBD90)),
                                                    padding: MaterialStateProperty.all(EdgeInsets.all(14)),
                                                  ),
                                                  icon: Icon(Icons.library_books),
                                                  label: Text(
                                                    'Type Consequence',
                                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(TypeConsequenceIncidentEnvPage(numIncident: controller.listIncident[index].n));
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            //icon: Icons.list,
                            label: 'Details',
                          ),
                        ],
                      ),
                      // The end action pane is the one at the right or the bottom side.
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            // An action can be bigger than the others.
                            flex: 2,
                            onPressed: (context) {
                              Get.to(ActionIncidentEnvironnementPage(numFiche: controller.listIncident[index].n));
                            },
                            backgroundColor: Color(0xFF0DBD90),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Actions',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text(
                'empty_list'.tr,
                style: TextStyle(fontSize: 25),
              ),
            );
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
              label: '${'new'.tr} Incident',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: (){
                Get.to(()=>NewIncidentEnvironnementPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Incident',
              onTap: (){
                //type incident
                controller.searchCodeType = '';
                controller.searchType = '';
                Future<List<TypeIncidentModel>> getTypeIncident(filter) async {
                  try {
                    List<TypeIncidentModel> _typeList = await List<TypeIncidentModel>.empty(growable: true);
                    List<TypeIncidentModel> _typeFilter = await List<TypeIncidentModel>.empty(growable: true);
                    var connection = await Connectivity().checkConnectivity();
                    if(connection == ConnectivityResult.none) {
                      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                      var response = await controller.localIncidentEnvironnementService.readTypeIncidentEnv();
                      response.forEach((data){
                        var model = TypeIncidentModel();
                        model.idType = data['idType'];
                        model.typeIncident = data['typeIncident'];
                        _typeList.add(model);
                      });
                    }
                    else if(connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile) {
                      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);
                      await IncidentEnvironnementService().getTypeIncidentEnv().then((resp) async {
                        resp.forEach((data) async {
                          var model = TypeIncidentModel();
                          model.idType = data['idType'];
                          model.typeIncident = data['type_Incident_Env'];
                          _typeList.add(model);
                        });
                      }
                          , onError: (err) {
                            ShowSnackBar.snackBar("Error", err.toString(), Colors.red);
                          });
                    }
                    _typeFilter = _typeList.where((u) {
                      var query = u.typeIncident!.toLowerCase();
                      return query.contains(filter);
                    }).toList();
                    return _typeFilter;

                  } catch (exception) {
                    ShowSnackBar.snackBar("Exception", exception.toString(), Colors.red);
                    return Future.error('service : ${exception.toString()}');
                  }
                }
                Widget customDropDownType(BuildContext context, TypeIncidentModel? item) {
                  if (item == null) {
                    return Container();
                  }
                  else{
                    return Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text('${item.typeIncident}', style: TextStyle(color: Colors.black),),
                      ),
                    );
                  }
                }
                Widget customPopupItemBuilderType(
                    BuildContext context, TypeIncidentModel? item, bool isSelected) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: !isSelected
                        ? null
                        : BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      selected: isSelected,
                      title: Text(item!.typeIncident ?? '', style: TextStyle(color: Colors.black),),
                      //subtitle: Text(item?.TypeAct ?? ''),
                    ),
                  );
                }

                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      scrollable: true,
                      title: const Center(
                        child: Text('Search Incident', style: TextStyle(
                            fontWeight: FontWeight.w500, fontFamily: "Brand-Bold",
                            color: Color(0xFF0769D2), fontSize: 30.0
                        ),),
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
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        hintText: 'N° Incident',
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
                            SizedBox(height: 5.0,),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: new ListTile(
                                leading: new Icon(Icons.search),
                                title: new TextField(
                                  controller: controller.searchDesignation,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'Incident',
                                      border: InputBorder.none),
                                ),
                                trailing: new IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    controller.searchDesignation.clear();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0,),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: DropdownSearch<TypeIncidentModel>(
                                showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Type",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.lightBlue, width: 0),
                                      borderRadius: BorderRadius.all(Radius.circular(1))
                                  ),
                                ),
                                onFind: (String? filter) => getTypeIncident(filter),
                                onChanged: (data) {
                                  controller.searchCodeType = data?.idType.toString();
                                  controller.searchType = data?.typeIncident.toString();
                                  controller.typeIncidentModel = data;
                                  if(controller.typeIncidentModel == null){
                                    controller.searchCodeType = '';
                                    controller.searchType = '';
                                  }
                                  print(' type incident: ${controller.searchType}, code : ${controller.searchCodeType}');
                                },
                                dropdownBuilder: customDropDownType,
                                popupItemBuilder: customPopupItemBuilderType,
                              ),
                            )
                            /*Card(
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
                            ), */
                          ],
                        ),
                      ),
                      contentPadding: EdgeInsets.only(right: 5.0, left: 5.0),
                      actionsPadding: EdgeInsets.all(1.0),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Get.find<IncidentEnvironnementController>().listIncident.clear();
                            Get.find<IncidentEnvironnementController>().searchIncident();
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
                            child: Text('Search',
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
              }
          ),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.sync, color: Colors.blue, size: 32),
              label: 'Synchronisation',
              onTap: (){
                controller.syncIncidentToWebService();
              }
          )
        ],
      ),
    );
  }

}