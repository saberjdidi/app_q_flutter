import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../Controllers/action/action_controller.dart';
import '../../Models/action/type_action_model.dart';
import '../../Services/api_services_call.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/empty_list_widget.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'action_widget.dart';
import 'new_action.dart';
import 'sous_action/sous_action_page.dart';
import 'types_causes_action_page.dart';

class ActionPage extends GetView<ActionController> {
  @override
  Widget build(BuildContext context) {
    final keyRefresh = GlobalKey<RefreshIndicatorState>();
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        centerTitle: true,
        /* leading: RaisedButton(
          onPressed: (){
            //Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
            Get.offAll(DashboardScreen());
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.blue,),
          color: Colors.white,
        ), */
        title: Text(
          'Actions',
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
          if (controller.listAction.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<ActionController>().listAction.clear();
                Get.find<ActionController>().getActions();
              },
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: controller.listAction.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      // Specify a key if the Slidable is dismissible.
                      key: const ValueKey(0),
                      // The child of the Slidable is what the user sees when the
                      // component is not dragged.
                      child: ActionWidget(
                        actionModel: controller.listAction[index],
                        color: Colors.blueGrey,
                      ),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          // A SlidableAction can have an icon and/or a label.
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(TypesCausesActionPage(
                                  idAction: controller.listAction[index].nAct));
                            },
                            backgroundColor: Color(0xFF2639E8),
                            foregroundColor: Colors.white,
                            icon: Icons.remove_red_eye,
                            label: 'Types Causes',
                          ),
                          /* SlidableAction(
                            onPressed: (context) {
                              Get.to(ProductsActionPage(idAction: controller.listAction[index].nAct));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.list,
                            label: 'Products',
                          ), */
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
                              //print('sous action');
                              /* Get.off(()=>EditTask(
                                    taskModel: controller.listAction[index],
                                  )); */
                              Get.to(SousActionPage(), arguments: {
                                "id_action": controller.listAction[index].nAct
                              });
                            },
                            backgroundColor: Color(0xFF0DBD90),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Sous Action',
                          ),
                          /* SlidableAction(
                                onPressed: (context){print('edit');},
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Save',
                              ), */
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
              label: '${'new'.tr} Action',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: () {
                Get.to(() => NewActionPage(),
                    transition: Transition.zoom,
                    duration: Duration(milliseconds: 500));
                //Get.to(()=>AddAction(), transition: Transition.zoom, duration: Duration(milliseconds: 500));
              }),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Action',
              onTap: () {
                controller.searchType = '';
                /* showSearch(
                  context: context,
                  delegate: SearchActionDelegate(controller.listAction),
                ); */
                //type action
                Future<List<TypeActionModel>> getTypes(filter) async {
                  try {
                    List<TypeActionModel> _typesList =
                        await List<TypeActionModel>.empty(growable: true);
                    List<TypeActionModel> _typesFilter =
                        await List<TypeActionModel>.empty(growable: true);
                    var connection = await Connectivity().checkConnectivity();
                    if (connection == ConnectivityResult.none) {
                      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      var response =
                          await controller.localActionService.readTypeAction();
                      response.forEach((data) {
                        var sourceModel = TypeActionModel();
                        sourceModel.codetypeAct = data['codetypeAct'];
                        sourceModel.typeAct = data['typeAct'];
                        sourceModel.actSimpl = data['actSimpl'];
                        sourceModel.analyseCause = data['analyseCause'];
                        _typesList.add(sourceModel);
                      });
                    } else if (connection == ConnectivityResult.wifi ||
                        connection == ConnectivityResult.mobile) {
                      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      await ApiServicesCall()
                          .getTypeAction({"nom": "", "lang": ""}).then(
                              (resp) async {
                        resp.forEach((data) async {
                          var model = TypeActionModel();
                          model.codetypeAct = data['codetypeAct'];
                          model.typeAct = data['typeAct'];
                          model.actSimpl = data['act_simpl'];
                          model.analyseCause = data['analyse_cause'];
                          _typesList.add(model);
                        });
                      }, onError: (err) {
                        ShowSnackBar.snackBar(
                            "Error", err.toString(), Colors.red);
                      });
                    }
                    _typesFilter = _typesList.where((u) {
                      var query = u.typeAct!.toLowerCase();
                      return query.contains(filter);
                    }).toList();
                    return _typesFilter;
                  } catch (exception) {
                    ShowSnackBar.snackBar(
                        "Exception", exception.toString(), Colors.red);
                    return Future.error('service : ${exception.toString()}');
                  }
                }

                Widget customDropDownType(
                    BuildContext context, TypeActionModel? item) {
                  if (item == null) {
                    return Container();
                  } else {
                    return Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '${item.typeAct}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }
                }

                Widget customPopupItemBuilderType(BuildContext context,
                    TypeActionModel? item, bool isSelected) {
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
                      title: Text(
                        item!.typeAct ?? '',
                        style: TextStyle(color: Colors.black),
                      ),
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
                      title: Center(
                        child: Text(
                          "${'search'.tr} Action",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Brand-Bold",
                              color: Color(0xFF0769D2),
                              fontSize: 25.0),
                        ),
                      ),
                      titlePadding: EdgeInsets.only(top: 2.0),
                      content: SingleChildScrollView(child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return ListBody(
                            children: <Widget>[
                              TextFormField(
                                controller: controller.searchNumAction,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'N° Action',
                                  hintText: 'number'.tr,
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: controller.searchAction,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Action',
                                  hintText: 'action',
                                  labelStyle: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                style: TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              DropdownSearch<TypeActionModel>(
                                showSelectedItems: true,
                                showClearButton:
                                    controller.typeActionModel?.typeAct == ""
                                        ? false
                                        : true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Type",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                ),
                                onFind: (String? filter) => getTypes(filter),
                                onChanged: (data) {
                                  if (controller.checkOffline.value == 1) {
                                    controller.searchType =
                                        data?.codetypeAct.toString();
                                    //controller.typeActionModel = data;
                                    debugPrint(
                                        'type action: ${controller.searchType}');
                                  } else {
                                    controller.searchType =
                                        data?.typeAct.toString();
                                    //controller.typeActionModel = data;
                                    debugPrint(
                                        'type action: ${controller.searchType}');
                                  }
                                },
                                dropdownBuilder: customDropDownType,
                                popupItemBuilder: customPopupItemBuilderType,
                              )
                            ],
                          );
                        },
                      )),
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
                            Get.find<ActionController>().listAction.clear();
                            Get.find<ActionController>().getActions();
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
              label: controller.countActionLocal == 0
                  ? 'No data exist to synchronized'
                  : 'Synchronisation',
              onTap: () {
                controller.syncActionToWebService();
              })
        ],
      ),
    );
  }
}
