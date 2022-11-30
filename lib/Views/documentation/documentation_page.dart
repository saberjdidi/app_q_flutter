import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/document/documentation_controller.dart';
import 'package:qualipro_flutter/Models/documentation/type_document_model.dart';
import 'package:readmore/readmore.dart';
import '../../Services/document/documentation_service.dart';
import '../../Utils/custom_colors.dart';
import '../../Utils/snack_bar.dart';
import '../../Widgets/empty_list_widget.dart';
import '../../Widgets/loading_widget.dart';
import '../../Widgets/navigation_drawer_widget.dart';
import '../../Widgets/refresh_widget.dart';
import 'details_documentation.dart';

class DocumentationPage extends GetView<DocumentationController> {
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
          'Documentation',
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
          if (controller.listDocument.length > 0) {
            return RefreshWidget(
              keyRefresh: keyRefresh,
              onRefresh: () async {
                Get.find<DocumentationController>().listDocument.clear();
                Get.find<DocumentationController>().getDocument();
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 1.0),
                shrinkWrap: true,
                itemCount: controller.listDocument.length,
                itemBuilder: (BuildContext context, int index) {
                  final status =
                      controller.listDocument[index].fichierLien.toString();
                  Image document_image = Image.asset(
                    "assets/images/logo.png",
                    width: 60.0,
                    height: 60.0,
                  );

                  if (status.contains(".png") || status.contains(".PNG")) {
                    document_image = Image.asset(
                      "assets/images/icon_png.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else if (status.contains(".docx") ||
                      status.contains(".DOCX")) {
                    document_image = Image.asset(
                      "assets/images/word.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else if (status.contains(".txt")) {
                    document_image = Image.asset(
                      "assets/images/word.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else if (status.contains(".xls") ||
                      status.contains(".xlsx")) {
                    document_image = Image.asset(
                      "assets/images/excel.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else if (status.contains(".ppt")) {
                    document_image = Image.asset(
                      "assets/images/ppt.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else if (status.contains(".pdf")) {
                    document_image = Image.asset(
                      "assets/images/pdficon.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  } else {
                    document_image = Image.asset(
                      "assets/images/logo.png",
                      width: 60.0,
                      height: 60.0,
                    );
                  }

                  return Accordion(
                    scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                    disableScrolling: true,
                    maxOpenSections: 1,
                    headerBackgroundColorOpened: Colors.black54,
                    openAndCloseAnimation: true,
                    headerPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
                    sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                    sectionClosingHapticFeedback: SectionHapticFeedback.light,
                    paddingListBottom: 1.0,
                    paddingListTop: 1.0,
                    children: [
                      AccordionSection(
                        isOpen: false,
                        leftIcon: document_image,
                        rightIcon: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.blue,
                            size: 20.0,
                          ),
                        ),
                        headerBackgroundColor: Color(0xFFedf0f8),
                        headerBackgroundColorOpened: Color(0xFFDBF1CC),
                        header: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                    "${controller.listDocument[index].cdi}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Brand-Regular",
                                        fontSize: 15.0,
                                        color: Colors.blue)),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "${controller.listDocument[index].dateCreat}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontFamily: "Brand-Bold"),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: ReadMoreText(
                                  "${controller.listDocument[index].libelle}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),
                                  trimLines: 3,
                                  colorClickableText: CustomColors.bleuCiel,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'more',
                                  trimExpandedText: 'less',
                                  moreStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColors.bleuCiel),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: ReadMoreText(
                                  "Type : ${controller.listDocument[index].typeDI}",
                                  style: TextStyle(
                                      color: Color(0xFF3B465E),
                                      fontWeight: FontWeight.bold),
                                  trimLines: 2,
                                  colorClickableText: CustomColors.bleuCiel,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'more',
                                  trimExpandedText: 'less',
                                  moreStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff4f515a),
                                      fontFamily: "Brand-Bold"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        content: DetailsDocumentation(
                            model: controller.listDocument[index]),
                        contentHorizontalPadding: 2,
                        contentBorderWidth: 1,
                        // onOpenSection: () => print('onOpenSection ...'),
                        // onCloseSection: () => print('onCloseSection ...'),
                      )
                    ],
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
          /* SpeedDialChild(
              child: Icon(Icons.add, color: Colors.blue, size: 32),
              label: '${'new'.tr} Document',
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              onTap: (){
                //Get.to(()=>NewReunionPage(), transition: Transition.zoom, duration: Duration(milliseconds: 500));

              }
          )
          */
          SpeedDialChild(
              labelBackgroundColor: Colors.white,
              backgroundColor: Colors.white,
              child: Icon(Icons.search, color: Colors.blue, size: 32),
              label: '${'search'.tr} Document',
              onTap: () {
                /* showSearch(
                    context: context,
                    delegate: SearchDocumentationDelegate(controller.listDocument),
                  ); */

                //type
                //controller.searchType.value = '';
                //controller.searchTypeOffline.value = '';
                Future<List<TypeDocumentModel>> getTypes(filter) async {
                  try {
                    List<TypeDocumentModel> _typesList =
                        await List<TypeDocumentModel>.empty(growable: true);
                    List<TypeDocumentModel> _typesFilter =
                        await List<TypeDocumentModel>.empty(growable: true);
                    var connection = await Connectivity().checkConnectivity();
                    if (connection == ConnectivityResult.none) {
                      //Get.snackbar("No Connection", "Mode Offline", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      var response = await controller.localDocumentationService
                          .readTypeDocument();
                      response.forEach((data) {
                        var model = TypeDocumentModel();
                        model.codeType = data['codeType'];
                        model.type = data['type'];
                        _typesList.add(model);
                      });
                    } else if (connection == ConnectivityResult.wifi ||
                        connection == ConnectivityResult.mobile) {
                      //Get.snackbar("Internet Connection", "Mode Online", colorText: Colors.blue, snackPosition: SnackPosition.TOP);

                      await DocumentationService().getTypeDocument().then(
                          (resp) async {
                        resp.forEach((data) async {
                          var model = TypeDocumentModel();
                          model.codeType = data['codeTypeDI'];
                          model.type = data['type'];
                          _typesList.add(model);
                        });
                      }, onError: (err) {
                        ShowSnackBar.snackBar(
                            "Error", err.toString(), Colors.red);
                      });
                    }
                    _typesFilter = _typesList.where((u) {
                      var query = u.type!.toLowerCase();
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
                    BuildContext context, TypeDocumentModel? item) {
                  if (item == null) {
                    return Container();
                  } else {
                    return Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          '${item.type}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }
                }

                Widget customPopupItemBuilderType(BuildContext context,
                    TypeDocumentModel? item, bool isSelected) {
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
                        item!.type ?? '',
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
                          '${'search'.tr} Documentation',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Brand-Bold",
                              color: Color(0xFF0769D2),
                              fontSize: 20.0),
                        ),
                      ),
                      titlePadding: EdgeInsets.only(top: 2.0),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: controller.searchCode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Code',
                                hintText: 'code',
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                prefixIcon: Icon(Icons.search),
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: controller.searchLibelle,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: 'Libelle',
                                hintText: 'libelle',
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                prefixIcon: Icon(Icons.search),
                              ),
                              style: TextStyle(fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            DropdownSearch<TypeDocumentModel>(
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
                                        color: Colors.lightBlue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                              ),
                              onFind: (String? filter) => getTypes(filter),
                              onChanged: (data) {
                                controller.searchType.value =
                                    data!.codeType.toString();
                                controller.searchTypeOffline =
                                    data.type.toString();
                                if (data == null) {
                                  controller.searchType.value = '';
                                  controller.searchTypeOffline = '';
                                }
                                debugPrint(
                                    'code type document: ${controller.searchType} type : ${controller.searchTypeOffline}');
                              },
                              dropdownBuilder: customDropDownType,
                              popupItemBuilder: customPopupItemBuilderType,
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
                            Get.find<DocumentationController>()
                                .listDocument
                                .clear();
                            Get.find<DocumentationController>()
                                .searchDocument();
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
                controller.syncDocumentationToWebService();
              })
        ],
      ),
    );
  }
}
