import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qualipro_flutter/Models/module_licence_model.dart';
import 'package:qualipro_flutter/Services/licence_service.dart';
import 'package:qualipro_flutter/Views/login/login_screen.dart';

import '../Models/begin_licence_model.dart';
import '../Models/licence_model.dart';
import '../Services/login_service.dart';
import '../Utils/shared_preference.dart';
import '../Utils/snack_bar.dart';
import 'login_controller.dart';

class LicenceController extends GetxController {
  final GlobalKey<FormState> licenceFormKey = GlobalKey<FormState>();

  var listLicences = List<LicenceModel>.empty(growable: true).obs;
  late TextEditingController licenceController;
  var isDataProcessing = false.obs;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var device_name = ''.obs;
  var device_id = ''.obs;
  var isExistDeviceId = false.obs;
  var loginNB = 0.obs;
  var nbInstallTaken = 0.obs;

  var email = '';

  @override
  void onInit() {
    super.onInit();
    licenceController = TextEditingController();
    initPlatformState();
    //getData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    licenceController.dispose();
  }

  String? validateLicence(String value) {
    if (value.isEmpty) {
      isDataProcessing(false);
      return "Licence required";
    }
    return null;
  }

  getData() async {
    await FirebaseFirestore.instance
        .collection('licences')
        //.where('licence', isEqualTo: licenceController.text)
        .snapshots()
        .listen((event) async {
      for (var i = 0; i < event.docs.length; i++) {
        print('id : ${event.docs[i].id}');
        print('licence ${event.docs[i].data()['licence']}');
        var model = LicenceModel();
        model.client = event.docs[i].data()['client'];
        model.licence = event.docs[i].data()['licence'];
        model.downloadLink = event.docs[i].data()['downloadLink'];
        model.host = event.docs[i].data()['host'];
        model.nbDays = event.docs[i].data()['nbDays'];
        model.nbInstall = event.docs[i].data()['nbInstall'];
        model.nbInstallTaken = event.docs[i].data()['nbInstallTaken'];
        model.webservice = event.docs[i].data()['webservice'];
        listLicences.add(model);

        /* if(event.docs[i].data()['licence'] == licenceController.text ) {
          ShowSnackBar.snackBar("Data exist", event.docs[i].data()['licence'], Colors.green);
          await FirebaseFirestore.instance
              .collection('licences')
              .doc(event.docs[i].id)
              .update({
            'devices' : FieldValue.arrayUnion([{
              'deviceid' : '012245112',
              'devicename' : 'sumsung',
              'loginNB' : '1',
              'date' : Timestamp.now()
            }])
          });
          return;
        }
        else {
          ShowSnackBar.snackBar("Data not exist", licenceController.text, Colors.red);
          return;
        } */

      }
      /*  event.docs.forEach((element) async {
           assert(element.data()['licence'] != null, "licence not exist");
          if(element.data()['licence'] == licenceController.text ) {
            ShowSnackBar.snackBar("Data exist", element.data()['licence'], Colors.green);
            await FirebaseFirestore.instance
                .collection('licences')
                .doc(element.id)
                .update({
                'devices' : FieldValue.arrayUnion([{
                'deviceid' : '012245112',
                'devicename' : 'sumsung',
                'loginNB' : '1',
                'date' : Timestamp.now()
              }])
            });
          }
          else {
            ShowSnackBar.snackBar("Data not exist", licenceController.text, Colors.red);
          }

          print('id : ${element.id}');
          print('licence ${element.data()['licence']}');
          var model = LicenceModel();
          model.client = element.data()['client'];
          model.licence = element.data()['licence'];
          model.downloadLink = element.data()['downloadLink'];
          model.host = element.data()['host'];
          model.nbDays = element.data()['nbDays'];
          model.nbInstall = element.data()['nbInstall'];
          model.nbInstallTaken = element.data()['nbInstallTaken'];
          model.webservice = element.data()['webservice'];
          listLicences.add(model);
          listLicences.forEach((element) {
            print('licence : ${model.client} - ${model.licence} - webservice : ${model.webservice}');
          });
        }); */
    });
  }

  //Geolocalisation
  var location = ''.obs;

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      Get.snackbar("Position", 'Please Turn On your position',
          icon: Icon(Icons.podcasts),
          backgroundColor: Color(0xFD1598AA),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP);
      /* Get.defaultDialog(
          title: "Position",
          backgroundColor: Colors.lightBlue,
          titleStyle: TextStyle(color: Colors.white),
          middleTextStyle: TextStyle(color: Colors.white),
          textConfirm: "Confirm",
          textCancel: "Cancel",
          cancelTextColor: Colors.white,
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          barrierDismissible: false,
          radius: 20,
          content: Text(
            'Please Turn On your position to get your address',
            style: TextStyle(color: Colors.black),
          ),
          onConfirm: () {},
          onCancel: () {
            location.value = '';
          }); */
      //return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  //geocoding
  Future<void> getAddressFromLatLong(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemark[0];
    print('place : $place');
    location.value =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print('location.value : ${location.value}');
  }

  //device info
  Future<void> initPlatformState() async {
    try {
      if (Platform.isAndroid) {
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      ShowSnackBar.snackBar(
          "Error device info", 'Failed to get platform version.', Colors.green);
    }
  }

  _readAndroidBuildData(AndroidDeviceInfo build) {
    device_name.value = build.model;
    device_id.value = build.androidId;
    //debugPrint('device name : ${device_name.value}');
    //debugPrint('device id : ${device_id.value}');
  }

  _readIosDeviceInfo(IosDeviceInfo data) {
    device_name.value = data.name;
    device_id.value = data.identifierForVendor;
    debugPrint('device name : ${device_name.value}');
    debugPrint('device id : ${device_id.value}');
  }

  void checkLicence() async {
    try {
      final isValid = licenceFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      licenceFormKey.currentState!.save();

      var connection = await Connectivity().checkConnectivity();
      if (connection == ConnectivityResult.none) {
        Get.snackbar("No internet connexion", 'Verify your internet connexion',
            icon: Icon(Icons.voice_over_off_sharp),
            backgroundColor: Color(0xFDCB7810),
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP);
      } else if (connection == ConnectivityResult.wifi ||
          connection == ConnectivityResult.mobile) {
        isDataProcessing.value = true;

        final response = await FirebaseFirestore.instance
            .collection('licences')
            .where('licence', isEqualTo: licenceController.text.trim())
            .get();
        final result = response.docs.first.data();
        final uid = response.docs.first.id;
        debugPrint('Result : id: $uid - licence: ${result['licence']}');
        assert(
            response.docs.first.data()['licence'] != null, "licence not exist");
        if (result['licence'] == licenceController.text.trim()) {
          if (int.parse(result['nbInstall'].toString())
                  .isEqual(int.parse(result['nbInstallTaken'].toString())) ||
              int.parse(result['nbInstall'].toString()).isLowerThan(
                  int.parse(result['nbInstallTaken'].toString()))) {
            ShowSnackBar.snackBar("Qualipro",
                'Vous avez dépassé le nombre d' 'installation', Colors.orange);
          } else {
            //Geolocator
            Position position = await _determinePosition();
            debugPrint(
                'location : Lat: ${position.latitude} - Long: ${position.longitude}');
            //getAddressFromLatLong(position);
            List<Placemark> placemark = await placemarkFromCoordinates(
                position.latitude, position.longitude);

            Placemark place = placemark[0];
            print('place : $place');
            String currentLocation =
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
            print('currentLocation : ${currentLocation}');
            //end localisation

            ShowSnackBar.snackBar(
                "Successfully", result['licence'], Colors.green);
            //final docsDevices = await FirebaseFirestore.instance.collection('licences').doc(uid).collection('tests').get();
            final docsDevices = await FirebaseFirestore.instance
                .collection('licences')
                .doc(uid)
                .collection('devices')
                .where('deviceid', isEqualTo: device_id.value.toString())
                .get();
            if (docsDevices.docs.length == [] ||
                docsDevices.docs.isEmpty ||
                docsDevices.docs.length == 0) {
              isExistDeviceId.value = false;
              //add new device
              await FirebaseFirestore.instance
                  .collection('licences')
                  .doc(uid)
                  .collection('devices')
                  .doc(device_id.value)
                  .set({
                'uid': uid,
                'deviceid': device_id.value,
                'devicename': device_name.value,
                'loginNB': '1',
                'date': Timestamp.now(),
                'address': currentLocation, //location.value,
                //'lat_lang' : GeoPoint(position.latitude, position.longitude)
              }).then((value) {
                debugPrint('Devices added successfully');
              }).onError((error, stackTrace) async {
                debugPrint('stackTrace : ${stackTrace.toString()}');
              });
              //update nbre installation
              nbInstallTaken.value =
                  int.parse(result['nbInstallTaken'].toString()) + 1;
              await FirebaseFirestore.instance
                  .collection('licences')
                  .doc(uid)
                  .update({
                'nbInstallTaken': nbInstallTaken.value.toString()
              }).then((value) {
                debugPrint('nbInstallTaken update successfully');
              }).onError((error, stackTrace) async {
                debugPrint('stackTrace : ${stackTrace.toString()}');
              });
            } else {
              loginNB.value = int.parse(
                      docsDevices.docs.first.data()['loginNB'].toString()) +
                  1;
              isExistDeviceId.value = true;
              //update device
              await FirebaseFirestore.instance
                  .collection('licences')
                  .doc(uid)
                  .collection('devices')
                  .doc(device_id.value)
                  .update({
                'loginNB': loginNB.value.toString(),
                'date': Timestamp.now(), //DateTime.now()
                'address': currentLocation //location.value,
              }).then((value) {
                debugPrint('Devices update successfully');
              }).onError((error, stackTrace) async {
                debugPrint('stackTrace : ${stackTrace.toString()}');
              });
            }
            var modelLicence = LicenceModel();
            modelLicence.client = result['client'];
            modelLicence.licence = result['licence'];
            modelLicence.downloadLink = result['downloadLink'];
            modelLicence.host = result['host'];
            modelLicence.nbDays = result['nbDays'];
            modelLicence.nbInstall = result['nbInstall'];
            modelLicence.nbInstallTaken = result['nbInstallTaken'];
            modelLicence.webservice = result['webservice'];
            modelLicence.deviceId = device_id.value.toString();
            modelLicence.deviceName = device_name.value.toString();
            modelLicence.action =
                int.parse(result['module']['action'].toString());
            modelLicence.audit =
                int.parse(result['module']['audit'].toString());
            modelLicence.pnc = int.parse(result['module']['pnc'].toString());
            modelLicence.docm = int.parse(result['module']['docm'].toString());
            modelLicence.reunion =
                int.parse(result['module']['reunion'].toString());
            modelLicence.incinv =
                int.parse(result['module']['incinv'].toString());
            modelLicence.incsecu =
                int.parse(result['module']['incsecu'].toString());
            modelLicence.visite =
                int.parse(result['module']['visite'].toString());
            //debugPrint('licence : client:${modelLicence.client} - licence:${modelLicence.licence} - webservice:${modelLicence.webservice} ');
            //saving url in shared preference
            await SharedPreference.setWebServiceKey(
                modelLicence.webservice.toString());
            //save licence info in sqlite
            await LicenceService().deleteTableLicenceInfo();
            await LicenceService().saveLicenceInfo(modelLicence);

            //begin licence
            if (isExistDeviceId.value == false) {
              await LoginService().beginLicenceService({
                "days": int.parse(modelLicence.nbDays.toString()),
                "deviceid": modelLicence.deviceId.toString(),
                "key": modelLicence.licence.toString()
              }).then((responseBeginLicence) async {
                debugPrint(
                    'responseBeginLicence : ${responseBeginLicence['done']}');
                //save licence info in db local
                /* await LoginService()
                      .LicenceDeviceByLicenceId(modelLicence.deviceId.toString())
                      .then((data) async {
                    //delete table if exist
                    await LicenceService().deleteTableBeginLicence();
                    var model = BeginLicenceModel();
                    String? dateLicenceStart = DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(data['licenseStart']));
                    String? dateLicenceEnd = DateFormat('yyyy-MM-dd')
                        .format(DateTime.parse(data['licenseEnd']));
                    model.LicenseStart = dateLicenceStart;
                    model.LicenseEnd = dateLicenceEnd;
                    model.DeviceId = data['deviceId'];
                    model.LicenseKey = data['licenseKey'];
                    //save data in sqlite
                    await LicenceService().saveBeginLicence(model);
                    debugPrint(
                        'Inserting data in table MobileLicence : ${model.LicenseEnd} - ${model.DeviceId} ');
                  }, onError: (errorSavingLicence) {
                    ShowSnackBar.snackBar("Error saving Licence in DB Local",
                        errorSavingLicence.toString(), Colors.red);
                  }); */
              }, onError: (errorBeginLicence) {
                ShowSnackBar.snackBar("Error saving Licence in DB",
                    errorBeginLicence.toString(), Colors.red);
              });
            }

            //save licence info in db local
            await LoginService()
                .LicenceDeviceByLicenceId(modelLicence.deviceId.toString())
                .then((data) async {
              //delete table if exist
              await LicenceService().deleteTableBeginLicence();
              var model = BeginLicenceModel();
              String? dateLicenceStart = DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(data['licenseStart']));
              String? dateLicenceEnd = DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(data['licenseEnd']));
              model.LicenseStart = dateLicenceStart;
              model.LicenseEnd = dateLicenceEnd;
              model.DeviceId = data['deviceId'];
              model.LicenseKey = data['licenseKey'];
              //save data in sqlite
              await LicenceService().saveBeginLicence(model);
              debugPrint(
                  'Inserting data in table MobileLicence : ${model.LicenseEnd} - ${model.DeviceId} ');
            }, onError: (errorSavingLicence) {
              ShowSnackBar.snackBar("Error saving Licence in DB Local",
                  errorSavingLicence.toString(), Colors.red);
            });

            //verify licence if 0(licence not expired) or 1(licence expired)
            await LoginService().isLicenceEndService({
              "deviceid": modelLicence.deviceId.toString(),
            }).then((responseLicenceEnd) async {
              debugPrint(
                  'responseLicenceEnd : ${responseLicenceEnd['retour']}');
              if (responseLicenceEnd['retour'] == 0) {
                //save data in shared preference
                await SharedPreference.setLicenceKey(
                    modelLicence.licence.toString());
                await SharedPreference.setNbDaysKey(
                    modelLicence.nbDays.toString());
                await SharedPreference.setDeviceIdKey(
                    modelLicence.deviceId.toString());
                await SharedPreference.setDeviceNameKey(
                    modelLicence.deviceName.toString());
                await SharedPreference.setIsVisibleAction(
                    int.parse(modelLicence.action.toString()));
                await SharedPreference.setIsVisibleAudit(
                    int.parse(modelLicence.audit.toString()));
                await SharedPreference.setIsVisiblePNC(
                    int.parse(modelLicence.pnc.toString()));
                await SharedPreference.setIsVisibleDocumentation(
                    int.parse(modelLicence.docm.toString()));
                await SharedPreference.setIsVisibleReunion(
                    int.parse(modelLicence.reunion.toString()));
                await SharedPreference.setIsVisibleIncidentEnvironnement(
                    int.parse(modelLicence.incinv.toString()));
                await SharedPreference.setIsVisibleIncidentSecurite(
                    int.parse(modelLicence.incsecu.toString()));
                await SharedPreference.setIsVisibleVisiteSecurite(
                    int.parse(modelLicence.visite.toString()));
                //navigate to login page
                Get.off(LoginScreen());
              } else {
                ShowSnackBar.snackBar(modelLicence.licence.toString(),
                    'Your licence has expired', Colors.lightBlueAccent);
              }
            }, onError: (errorLicenceEnd) {
              ShowSnackBar.snackBar(
                  "Error Licence End", errorLicenceEnd.toString(), Colors.red);
            });
          }
        } else {
          ShowSnackBar.snackBar(
              "Licence not exist in Firebase", 'No Licence', Colors.red);
        }
      }
    } on FirebaseException catch (e) {
      debugPrint('Firebase Exception : ${e.toString()}');
      ShowSnackBar.snackBar("Firebase Exception", e.toString(), Colors.red);
    } catch (exception) {
      isDataProcessing(false);
      ShowSnackBar.snackBar(
          "Licence not exist in Firebase", exception.toString(), Colors.red);
      debugPrint('exception : ${exception.toString()}');
    } finally {
      //isDataProcessing(false);
      isDataProcessing.value = false;
    }
  }
}
