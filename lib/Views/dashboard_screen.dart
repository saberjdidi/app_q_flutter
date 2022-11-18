import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/user_model.dart';
import 'package:qualipro_flutter/Services/licence_service.dart';
import 'package:qualipro_flutter/Services/login_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Controllers/api_controllers_call.dart';
import '../Controllers/onboarding_controller.dart';
import '../Models/begin_licence_model.dart';
import '../Models/licence_end_model.dart';
import '../Models/licence_model.dart';
import '../Utils/custom_colors.dart';
import '../Widgets/app_bar_title.dart';
import '../Widgets/navigation_drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const String idScreen = "mainScreen";
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  ApiControllersCall apiControllersCall = ApiControllersCall();

  String? licence = '';
  String? client = '';
  String? webservice = '';
  String? mat = '';
  String? nompre = '';
  int? isLicenceEnd = 0;

  @override
  void initState() {
    super.initState();
    getInfoLicence();
    getInfoUser();
    getLicenceEnd();
  }

  getInfoLicence() async {
    final response = await LicenceService().getLicenceInfo();

    setState(() {
      var model = LicenceModel();
      model.client = response.client;
      model.licence = response.licence;
      model.webservice = response.webservice;

      licence = model.licence;
      client = model.client;
      webservice = model.webservice;
    });
  }

  getInfoUser() async {
    final response = await LoginService().readUser();
    response.forEach((data) {
      setState(() {
        var model = UserModel();
        model.mat = data['mat'];
        model.nompre = data['nompre'];

        mat = model.mat;
        nompre = model.nompre;
      });
    });
  }

  getLicenceEnd() async {
    final licenceDevice = await LicenceService().getBeginLicence();
    String? device_id = licenceDevice?.DeviceId;
    final licenceEndModel = await LicenceService().getIsLicenceEnd(device_id);
    setState(() {
      isLicenceEnd = licenceEndModel?.retour;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,

        /// 2- to call ui of AppBarTitle class ///
        title: AppBarTitle(),
        iconTheme: IconThemeData(color: CustomColors.blueAccent),
      ),
      drawer: NavigationDrawerWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListBody(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'licence : ',
                      style: TextStyle(
                          color: Color(0xff060f7d),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Brand-Bold"),
                    ),
                    Text('$licence',
                        style: TextStyle(
                            color: Color(0xff0c2d5e),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Brand-Regular")),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      'client : ',
                      style: TextStyle(
                          color: Color(0xff060f7d),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Brand-Bold"),
                    ),
                    Text('$client',
                        style: TextStyle(
                            color: Color(0xff0c2d5e),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Brand-Regular")),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'webservice : ',
                        style: TextStyle(
                            color: Color(0xff060f7d),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Brand-Bold"),
                      ),
                      Text('$webservice',
                          style: TextStyle(
                              color: Color(0xff0c2d5e),
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Brand-Regular")),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      'Matricule : ',
                      style: TextStyle(
                          color: Color(0xff060f7d),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Brand-Bold"),
                    ),
                    Text('$mat',
                        style: TextStyle(
                            color: Color(0xff0c2d5e),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Brand-Regular")),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      'Nom Prenom : ',
                      style: TextStyle(
                          color: Color(0xff060f7d),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Brand-Bold"),
                    ),
                    Text('$nompre',
                        style: TextStyle(
                            color: Color(0xff0c2d5e),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Brand-Regular")),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      'Is Licence End : ',
                      style: TextStyle(
                          color: Color(0xff060f7d),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Brand-Bold"),
                    ),
                    Text('$isLicenceEnd',
                        style: TextStyle(
                            color: Color(0xff0c2d5e),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Brand-Regular")),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: WebView(
                      initialUrl:
                          'https://www.google.com/maps/@36.8374253,10.1846143,13.25z',
                      /* initialUrl: Uri.dataFromString(
                              '<html><body><iframe src="https://www.youtube.com/watch?v=g0GNuoCOtaQ"></iframe></body></html>',
                              mimeType: 'text/html')
                          .toString(), */
                      javascriptMode: JavascriptMode.unrestricted,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
