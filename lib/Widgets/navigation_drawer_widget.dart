import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Models/licence_model.dart';
import 'package:qualipro_flutter/Services/licence_service.dart';
import 'package:qualipro_flutter/Views/login/login_screen.dart';
import '../Controllers/login_controller.dart';
import '../Controllers/reunion/reunion_controller.dart';
import '../Route/app_route.dart';
import '../Utils/custom_colors.dart';
import '../Utils/shared_preference.dart';
import '../Views/dashboard_screen.dart';
import 'divider.dart';
import 'multi_language.dart';

//stateful NavigationDrawerWidget
class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    //getLicenceInfo();
  }

  getLicenceInfo() async {
    //final response = await LicenceService().readLicenceInfo();
    LicenceModel response = await LicenceService().getLicenceInfo();
    setState(() {
      print('licence data : ${response.licence}');
    });
  }

  @override
  Widget build(BuildContext context) {
    logout() {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.INFO,
          body: Center(
            child: Text(
              'exit'.tr,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          title: 'signout'.tr,
          btnOk: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.blue,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () async {
              //Get.put(() => LoginController());
              //Get.find<LoginController>();
              Get.find<LoginController>().usernameController.clear();
              Get.find<LoginController>().passwordController.clear();
              await SharedPreference.clearSharedPreference();
              //SharedPreference.removeSharedPreferenceByKey(SharedPreference.getMatricule().toString());
              //SharedPreference.removeSharedPreferenceByKey(SharedPreference.getNomPrenom().toString());

              LicenceModel response = await LicenceService().getLicenceInfo();
              await SharedPreference.setLicenceKey(response.licence.toString());
              await SharedPreference.setWebServiceKey(
                  response.webservice.toString());
              await SharedPreference.setNbDaysKey(response.nbDays.toString());
              await SharedPreference.setDeviceIdKey(
                  response.deviceId.toString());
              await SharedPreference.setDeviceNameKey(
                  response.deviceName.toString());
              await SharedPreference.setIsVisibleAction(
                  int.parse(response.action.toString()));
              await SharedPreference.setIsVisibleAudit(
                  int.parse(response.audit.toString()));
              await SharedPreference.setIsVisiblePNC(
                  int.parse(response.pnc.toString()));
              await SharedPreference.setIsVisibleDocumentation(
                  int.parse(response.docm.toString()));
              await SharedPreference.setIsVisibleReunion(
                  int.parse(response.reunion.toString()));
              await SharedPreference.setIsVisibleIncidentEnvironnement(
                  int.parse(response.incinv.toString()));
              await SharedPreference.setIsVisibleIncidentSecurite(
                  int.parse(response.incsecu.toString()));
              await SharedPreference.setIsVisibleVisiteSecurite(
                  int.parse(response.visite.toString()));
              Get.offAll(LoginScreen());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Ok',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          closeIcon: Icon(
            Icons.close,
            color: Colors.red,
          ),
          btnCancel: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.redAccent,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          )).show();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          builDrawerHeader(),
          DividerWidget(),

          buildDrawerItem(
            icon: Icons.home,
            text: 'home'.tr,
            onTap: () => navigate(0),
            tileColor: Get.currentRoute == AppRoute.dashboard
                ? CustomColors.whiteGrey
                : null,
            textIconColor: Get.currentRoute == AppRoute.dashboard
                ? Colors.blue
                : Colors.black,
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleAction() == 1 ? true : false,
            child: buildDrawerItem(
              icon: Icons.pending_actions,
              text: "Action",
              onTap: () => navigate(1),
              tileColor: Get.currentRoute == AppRoute.action
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.action
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleAudit() == 1 ? true : false,
            child: buildDrawerItem(
              icon: Icons.check_box_outlined,
              text: "Audit",
              onTap: () => navigate(8),
              tileColor: Get.currentRoute == AppRoute.audit
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.audit
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisiblePNC() == 1 ? true : false,
            child: buildDrawerItem(
              icon: Icons.compare_rounded,
              text: "P.N.C",
              onTap: () => navigate(2),
              tileColor: Get.currentRoute == AppRoute.pnc
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor:
                  Get.currentRoute == AppRoute.pnc ? Colors.blue : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleDocumentation() == 1
                ? true
                : false,
            child: buildDrawerItem(
              icon: Icons.description,
              text: "Documentation",
              onTap: () => navigate(3),
              tileColor: Get.currentRoute == AppRoute.documentation
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.documentation
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleReunion() == 1 ? true : false,
            child: buildDrawerItem(
              icon: Icons.album_outlined,
              text: 'reunion'.tr,
              onTap: () => navigate(4),
              tileColor: Get.currentRoute == AppRoute.reunion
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.reunion
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleIncidentEnvironnement() == 1
                ? true
                : false,
            child: buildDrawerItem(
              icon: Icons.approval,
              text: 'incident_environnement'.tr,
              onTap: () => navigate(5),
              tileColor: Get.currentRoute == AppRoute.incident_environnement
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.incident_environnement
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleIncidentSecurite() == 1
                ? true
                : false,
            child: buildDrawerItem(
              icon: Icons.security,
              text: 'incident_securite'.tr,
              onTap: () => navigate(6),
              tileColor: Get.currentRoute == AppRoute.incident_securite
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.incident_securite
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
          Visibility(
            visible: SharedPreference.getIsVisibleVisiteSecurite() == 1
                ? true
                : false,
            child: buildDrawerItem(
              icon: Icons.settings_display,
              text: 'visite_securite'.tr,
              onTap: () => navigate(7),
              tileColor: Get.currentRoute == AppRoute.visite_securite
                  ? CustomColors.whiteGrey
                  : null,
              textIconColor: Get.currentRoute == AppRoute.visite_securite
                  ? Colors.blue
                  : Colors.black,
            ),
          ),

          DividerWidget(),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  title: 'choose_langue'.tr,
                  backgroundColor: Colors.white,
                  titleStyle: TextStyle(color: Colors.black),
                  middleTextStyle: TextStyle(color: Colors.white),
                  textCancel: "OK",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.blue,
                  barrierDismissible: false,
                  radius: 20,
                  content: MultiLanguage());
            },
            child: ListTile(
              leading: Icon(Icons.translate, color: Colors.black),
              title: Text(
                'language'.tr,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
            ),
          ),
          // MultiLanguage(),
          GestureDetector(
            onTap: () {
              logout();
            },
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text(
                'signout'.tr,
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
            ),
          ),
          /* GestureDetector(
            onTap: () {
              Get.to(DashboardScreen());
            },
            child: ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text(
                'Settings',
                style: TextStyle(fontSize: 15.0, color: Colors.black),
              ),
            ),
          ) */
        ],
      ),
    );
  }

  Widget builDrawerHeader() {
    String? nomprenom = SharedPreference.getNomPrenom();

    return Container(
      height: 160.0,
      child: DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Row(
          children: [
            Image.asset(
              "assets/images/user_icon.png",
              height: 65.0,
              width: 65.0,
            ),
            SizedBox(
              width: 16.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Qualipro",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Brand-Bold",
                      color: Colors.white),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Text(
                  '${nomprenom}',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: "Brand-Bold",
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    /*
    return UserAccountsDrawerHeader(
        accountName: Text('${nomprenom}',
          style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold", ),),
        accountEmail: Text("Qualipro", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/user_icon.png'),
      ),
      currentAccountPictureSize: Size.square(70),
    );
     */
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required Color textIconColor,
    required Color? tileColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(
        text,
        style: TextStyle(color: textIconColor),
      ),
      tileColor: tileColor,
      onTap: onTap,
    );
  }

  navigate(int index) {
    if (index == 0) {
      Get.offAllNamed(AppRoute.dashboard);
    } else if (index == 1) {
      //Get.offAllNamed(AppRoute.action);
      //Get.find<ActionController>().listAction.clear();
      //Get.find<ActionController>().getActions();
      Get.toNamed(AppRoute.action);
    } else if (index == 2) {
      //Get.find<PNCController>().listPNC.clear();
      //Get.find<PNCController>().getPNC();
      //Get.offAllNamed(AppRoute.pnc);
      Get.toNamed(AppRoute.pnc);
    } else if (index == 3) {
      //Get.find<DocumentationController>().listDocument.clear();
      //Get.find<DocumentationController>().getDocument();
      //Get.offAllNamed(AppRoute.documentation);
      Get.toNamed(AppRoute.documentation);
    } else if (index == 4) {
      Get.find<ReunionController>().listReunion.clear();
      Get.find<ReunionController>().getReunion();
      //Get.offAllNamed(AppRoute.reunion);
      Get.toNamed(AppRoute.reunion);
    } else if (index == 5) {
      //Get.find<IncidentEnvironnementController>().listIncident.clear();
      //Get.find<IncidentEnvironnementController>().getIncident();
      Get.toNamed(AppRoute.incident_environnement);
    } else if (index == 6) {
      //Get.find<IncidentSecuriteController>().listIncident.clear();
      //Get.find<IncidentSecuriteController>().getIncident();
      Get.toNamed(AppRoute.incident_securite);
    } else if (index == 7) {
      //Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
      //Get.find<VisiteSecuriteController>().getData();
      Get.toNamed(AppRoute.visite_securite);
    } else if (index == 8) {
      // Get.find<AuditController>().listAudit.clear();
      //Get.find<AuditController>().getData();
      Get.toNamed(AppRoute.audit);
    }
  }
}

//stateless NavigationDrawerWidget
/*
class NavigationDrawerWidget  extends StatelessWidget {
  const NavigationDrawerWidget ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    logout() {
      AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.INFO,
          body: Center(child: Text(
            'exit'.tr,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),),
          title: 'signout'.tr,
          btnOk: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.blue,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () async {
              //Get.put(() => LoginController());
              //Get.find<LoginController>();
              Get.find<LoginController>().usernameController.clear();
              Get.find<LoginController>().passwordController.clear();
              SharedPreference.clearSharedPreference();
              //SharedPreference.removeSharedPreferenceByKey(SharedPreference.getMatricule().toString());
              //SharedPreference.removeSharedPreferenceByKey(SharedPreference.getNomPrenom().toString());
              Get.offAll(LoginScreen());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ok',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          closeIcon: Icon(Icons.close, color: Colors.red,),
          btnCancel: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.redAccent,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          )
      ).show();
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          builDrawerHeader(),
          DividerWidget(),

          buildDrawerItem(
            icon: Icons.home,
            text: 'home'.tr,
            onTap: () => navigate(0),
            tileColor: Get.currentRoute == AppRoute.dashboard ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.dashboard
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.pending_actions,
            text: "Action",
            onTap: () => navigate(1),
            tileColor: Get.currentRoute == AppRoute.action ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.action
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.check_box_outlined,
            text: "Audit",
            onTap: () => navigate(8),
            tileColor: Get.currentRoute == AppRoute.audit ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.audit
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.compare_rounded,
            text: "PNC",
            onTap: () => navigate(2),
            tileColor: Get.currentRoute == AppRoute.pnc ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.pnc
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.description,
            text: "Documentation",
            onTap: () => navigate(3),
            tileColor: Get.currentRoute == AppRoute.documentation ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.documentation
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.album_outlined,
            text: "Reunion",
            onTap: () => navigate(4),
            tileColor: Get.currentRoute == AppRoute.reunion ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.reunion
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.approval,
            text: "Incident Environnemental",
            onTap: () => navigate(5),
            tileColor: Get.currentRoute == AppRoute.incident_environnement ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.incident_environnement
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.security,
            text: "Incident Securite",
            onTap: () => navigate(6),
            tileColor: Get.currentRoute == AppRoute.incident_securite ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.incident_securite
                ? Colors.blue
                : Colors.black,
          ),
          buildDrawerItem(
            icon: Icons.settings_display,
            text: "Visite Securite",
            onTap: () => navigate(7),
            tileColor: Get.currentRoute == AppRoute.visite_securite ? CustomColors.whiteGrey : null,
            textIconColor: Get.currentRoute == AppRoute.visite_securite
                ? Colors.blue
                : Colors.black,
          ),

          DividerWidget(),
          GestureDetector(
            onTap: (){
              Get.defaultDialog(
                  title: 'choose_langue'.tr,
                  backgroundColor: Colors.white,
                  titleStyle: TextStyle(color: Colors.black),
                  middleTextStyle: TextStyle(color: Colors.white),
                  textCancel: "OK",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.blue,
                  barrierDismissible: false,
                  radius: 20,
                  content: MultiLanguage()
              );
            },
            child: ListTile(
              leading: Icon(Icons.translate, color: Colors.black),
              title: Text('language'.tr,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                ),
              ),
            ),
          ),
         // MultiLanguage(),
          GestureDetector(
            onTap: (){
              logout();
            },
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('signout'.tr,
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget builDrawerHeader(){
    String? nomprenom = SharedPreference.getNomPrenom();

    return Container(
      height: 160.0,
      child: DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Row(
          children: [
            Image.asset("assets/images/user_icon.png", height: 65.0, width: 65.0,),
            SizedBox(width: 16.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Qualipro", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold", color: Colors.white),),
                SizedBox(height: 6.0,),
                Text('${nomprenom}',
                  style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold", color: Colors.white, ),),
              ],
            )
          ],
        ),
      ),
    );
    /*
    return UserAccountsDrawerHeader(
        accountName: Text('${nomprenom}',
          style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold", ),),
        accountEmail: Text("Qualipro", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/user_icon.png'),
      ),
      currentAccountPictureSize: Size.square(70),
    );
     */
  }

  Widget buildDrawerItem({
    required String text,
    required IconData icon,
    required Color textIconColor,
    required Color? tileColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: textIconColor),
      title: Text(
        text,
        style: TextStyle(color: textIconColor),
      ),
      tileColor: tileColor,
      onTap: onTap,
    );
  }

  navigate(int index) {
    if (index == 0) {
      Get.offAllNamed(AppRoute.dashboard);
    }
    else if (index == 1) {
      //Get.offAllNamed(AppRoute.action);
      //Get.find<ActionController>().listAction.clear();
      //Get.find<ActionController>().getActions();
      Get.toNamed(AppRoute.action);
    }
    else if (index == 2) {
      //Get.find<PNCController>().listPNC.clear();
      //Get.find<PNCController>().getPNC();
      //Get.offAllNamed(AppRoute.pnc);
      Get.toNamed(AppRoute.pnc);
    }
    else if (index == 3) {
      //Get.find<DocumentationController>().listDocument.clear();
      //Get.find<DocumentationController>().getDocument();
      //Get.offAllNamed(AppRoute.documentation);
      Get.toNamed(AppRoute.documentation);
    }
    else if (index == 4) {
      Get.find<ReunionController>().listReunion.clear();
      Get.find<ReunionController>().getReunion();
      //Get.offAllNamed(AppRoute.reunion);
      Get.toNamed(AppRoute.reunion);
    }
    else if (index == 5) {
      //Get.find<IncidentEnvironnementController>().listIncident.clear();
      //Get.find<IncidentEnvironnementController>().getIncident();
      Get.toNamed(AppRoute.incident_environnement);
    }
    else if (index == 6) {
      //Get.find<IncidentSecuriteController>().listIncident.clear();
      //Get.find<IncidentSecuriteController>().getIncident();
      Get.toNamed(AppRoute.incident_securite);
    }
    else if (index == 7) {
      //Get.find<VisiteSecuriteController>().listVisiteSecurite.clear();
      //Get.find<VisiteSecuriteController>().getData();
      Get.toNamed(AppRoute.visite_securite);
    }
    else if (index == 8) {
     // Get.find<AuditController>().listAudit.clear();
      //Get.find<AuditController>().getData();
      Get.toNamed(AppRoute.audit);
    }
  }

  /*logout(){
    //Get.put(() => LoginController());
    //Get.find<LoginController>();
    Get.find<LoginController>().usernameController.clear();
    Get.find<LoginController>().passwordController.clear();
    SharedPreference.clearSharedPreference();
    Get.offAll(LoginScreen());
  } */

}
*/
