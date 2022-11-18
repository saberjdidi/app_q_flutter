import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/incident_environnement/upload_image_model.dart';
import 'package:qualipro_flutter/Services/visite_securite/local_visite_securite_service.dart';
import 'package:qualipro_flutter/Services/visite_securite/visite_securite_service.dart';
import 'package:qualipro_flutter/Utils/snack_bar.dart';
import '../../Widgets/loading_widget.dart';

class ImageVisiteSecurite extends StatefulWidget {
  final numFiche;
  const ImageVisiteSecurite({Key? key, required this.numFiche})
      : super(key: key);

  @override
  State<ImageVisiteSecurite> createState() => _ImageVisiteSecuriteState();
}

class _ImageVisiteSecuriteState extends State<ImageVisiteSecurite> {
  bool isDataProcessing = false;
  List<UploadImageModel> listImages =
      List<UploadImageModel>.empty(growable: true);

  getData() async {
    try {
      isDataProcessing = true;
      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        final response =
            await LocalVisiteSecuriteService().readImagesVisiteSecurite();
        response.forEach((data) {
          setState(() {
            var model = UploadImageModel();
            model.idFiche = data.idFiche;
            model.image = data.image;
            model.fileName = data.fileName;
            listImages.add(model);
          });
        });
        ShowSnackBar.snackBar(
            'Mode Offline', 'image_not_accessible'.tr, Colors.blue);
      } else if (connection == ConnectivityResult.mobile ||
          connection == ConnectivityResult.wifi) {
        await VisiteSecuriteService().getImageVisiteSec(widget.numFiche).then(
            (response) {
          response.forEach((element) {
            setState(() {
              var model = UploadImageModel();
              model.idPiece = element['id_piece'];
              model.idFiche = element['idFiche'];
              model.image = element['piece'];
              model.fileName = element['objet'];
              listImages.add(model);
              debugPrint(
                  'fiche : ${model.idFiche} - name file : ${model.fileName}');
            });
          });
        }, onError: (error) {
          isDataProcessing = false;
          ShowSnackBar.snackBar('Error', error.toString(), Colors.red);
        });
      }
    } catch (Exception) {
      setState(() {
        isDataProcessing = false;
      });
      ShowSnackBar.snackBar('Exception', Exception.toString(), Colors.red);
    } finally {
      setState(() {
        isDataProcessing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            onPressed: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
          title: Text(
            'Images Visite Sec N°${widget.numFiche}',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        body: isDataProcessing == true
            ? Container(
                color: Colors.white54,
                child: Center(
                  child: LoadingView(),
                ),
              )
            : SafeArea(
                child: Container(
                  child: listImages.length > 0 && isDataProcessing == false
                      ? Container(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200,
                                      childAspectRatio: 3 / 3,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 5),
                              itemCount: listImages.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: InkWell(
                                    onTap: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false, //
                                        useSafeArea:
                                            false, // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            scrollable: true,
                                            /* title: const Center(
                                              child: Text(
                                                'Image Visite Securite',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Brand-Bold",
                                                    color: Color(0xFF0769D2),
                                                    fontSize: 25.0),
                                              ),
                                            ),*/
                                            titlePadding:
                                                EdgeInsets.only(top: 2.0),
                                            content: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(1.0),
                                              decoration: BoxDecoration(
                                                  color: Color(0xFDEFEEEE),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Center(
                                                  child: Image.memory(
                                                    base64Decode(
                                                        listImages[index]
                                                            .image
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                    height:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                right: 1.0,
                                                left: 1.0,
                                                top: 1.0),
                                            actionsPadding: EdgeInsets.all(1.0),
                                            actionsAlignment:
                                                MainAxisAlignment.start,
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.blueAccent,
                                                    size: 35,
                                                  ))
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                          color: Color(0xFDEFEEEE),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Image.memory(
                                        base64Decode(
                                            listImages[index].image.toString()),
                                        fit: BoxFit.cover,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(
                          child: Center(
                            child: Text('empty_list'.tr,
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: 'Brand-Bold')),
                          ),
                        ),
                ),
              ));
  }
}
