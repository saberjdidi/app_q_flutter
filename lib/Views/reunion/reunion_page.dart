import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import '../../Controllers/reunion/reunion_controller.dart';
import '../../Models/reunion/type_reunion_model.dart';
import '../../Services/reunion/reunion_service.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/empty_list_widget.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'decision/decision_page.dart';
import 'new_reunion.dart';
import 'participant/participant_page.dart';
import 'reunion_widget.dart';
import 'search_reunion.dart';

class ReunionPage extends GetView<ReunionController> {
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
          'Reunion',
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
          if (controller.listReunion.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                /* await Future.delayed(Duration(seconds: 1),
                                (){
                              controller.lstTask;
                            }
                        ); */
                Get.find<ReunionController>().listReunion.clear();
                Get.find<ReunionController>().getReunion();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 1.0),
                shrinkWrap: true,
                itemCount: controller.listReunion.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, bottom: 0.0),
                    child: Slidable(
                      key: const ValueKey(0),
                      child: ReunionWidget(
                        model: controller.listReunion[index],
                        color: Colors.blueGrey,
                      ),
                      // The start action pane is the one at the left or the top side.
                      startActionPane: ActionPane(
                        // A motion is a widget used to control how the pane animates.
                        motion: const ScrollMotion(),

                        // All actions are defined in the children parameter.
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(ParticipantPage(
                                  nReunion:
                                      controller.listReunion[index].nReunion));
                            },
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.list,
                            label: 'Participants',
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
                              Get.to(DecisionPage(
                                  nReunion:
                                      controller.listReunion[index].nReunion));
                            },
                            backgroundColor: Color(0xFF0DBD90),
                            foregroundColor: Colors.white,
                            icon: Icons.account_tree_rounded,
                            label: 'Decisions',
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
              label: '${'new'.tr} Reunion',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: () {
                Get.to(() => NewReunionPage(),
                    transition: Transition.zoom,
                    duration: Duration(milliseconds: 500));
              }),
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Reunion',
              onTap: () {
                /* showSearch(
                  context: context,
                  delegate: SearchReunionDelegate(controller.listReunion),
                ); */
                controller.searchCodeType = '';

                Future<List<TypeReunionModel>> getTypeReunion(filter) async {
                  try {
                    List<TypeReunionModel> _typeList =
                        await List<TypeReunionModel>.empty(growable: true);
                    List<TypeReunionModel> _typeFilter =
                        await List<TypeReunionModel>.empty(growable: true);
                    var connection = await Connectivity().checkConnectivity();
                    if (connection == ConnectivityResult.none) {
                      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      var response = await controller.localReunionService
                          .readTypeReunion();
                      response.forEach((data) {
                        var model = TypeReunionModel();
                        model.codeTypeR = data['codeTypeR'];
                        model.typeReunion = data['typeReunion'];
                        _typeList.add(model);
                      });
                    } else if (connection == ConnectivityResult.wifi ||
                        connection == ConnectivityResult.mobile) {
                      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      await ReunionService().getTypeReunion().then(
                          (resp) async {
                        resp.forEach((data) async {
                          var model = TypeReunionModel();
                          model.codeTypeR = data['codeTypeR'];
                          model.typeReunion = data['type_Reunion'];
                          _typeList.add(model);
                        });
                      }, onError: (err) {
                        ShowSnackBar.snackBar(
                            "Error", err.toString(), Colors.red);
                      });
                    }
                    _typeFilter = _typeList.where((u) {
                      var query = u.typeReunion!.toLowerCase();
                      return query.contains(filter);
                    }).toList();
                    return _typeFilter;
                  } catch (exception) {
                    ShowSnackBar.snackBar(
                        "Exception", exception.toString(), Colors.red);
                    return Future.error('service : ${exception.toString()}');
                  }
                }

                Widget customDropDownType(
                    BuildContext context, TypeReunionModel? item) {
                  if (item == null) {
                    return Container();
                  } else {
                    return Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text('${item?.typeReunion}'),
                      ),
                    );
                  }
                }

                Widget customPopupItemBuilderType(BuildContext context,
                    TypeReunionModel item, bool isSelected) {
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
                      title: Text(item.typeReunion ?? ''),
                      subtitle: Text(item.codeTypeR.toString() ?? ''),
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
                          '${'search'.tr} ${'reunion'.tr}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Brand-Bold",
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
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'N° ${'reunion'.tr}',
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
                                  controller: controller.searchDesignation,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: 'order'.tr,
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
                            SizedBox(
                              height: 5.0,
                            ),
                            Card(
                              color: Color(0xffa5e1f5),
                              child: DropdownSearch<TypeReunionModel>(
                                showSelectedItems: true,
                                showClearButton: true,
                                showSearchBox: true,
                                isFilteredOnline: true,
                                compareFn: (i, s) => i?.isEqual(s) ?? false,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Type",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.lightBlue, width: 0),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(1))),
                                ),
                                onFind: (String? filter) =>
                                    getTypeReunion(filter),
                                onChanged: (data) {
                                  controller.searchCodeType =
                                      data?.codeTypeR.toString();
                                  debugPrint(
                                      ' type reunion: ${data?.typeReunion}, code : ${controller.searchCodeType}');
                                },
                                dropdownBuilder: customDropDownType,
                                popupItemBuilder: customPopupItemBuilderType,
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
                            Get.find<ReunionController>().listReunion.clear();
                            Get.find<ReunionController>().searchReunion();
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
                controller.syncReunionToWebService();
              })
        ],
      ),
    );
  }
}
