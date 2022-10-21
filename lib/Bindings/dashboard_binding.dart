import 'package:get/get.dart';
import 'package:qualipro_flutter/Controllers/document/documentation_controller.dart';
import 'package:qualipro_flutter/Controllers/pnc/new_pnc_controller.dart';
import 'package:qualipro_flutter/Controllers/pnc/pnc_controller.dart';
import 'package:qualipro_flutter/Controllers/reunion/new_reunion_controller.dart';
import '../Controllers/action/action_controller.dart';
import '../Controllers/audit/audit_controller.dart';
import '../Controllers/audit/new_audit_controller.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/incident_environnement/incident_environnement_controller.dart';
import '../Controllers/incident_environnement/new_incident_environnement_controller.dart';
import '../Controllers/incident_securite/incident_securite_controller.dart';
import '../Controllers/incident_securite/new_incident_securite_controller.dart';
import '../Controllers/login_controller.dart';
import '../Controllers/network_controller.dart';
import '../Controllers/onboarding_controller.dart';
import '../Controllers/reunion/reunion_controller.dart';
import '../Controllers/action/sous_action_controller.dart';
import '../Controllers/task_controller.dart';
import '../Controllers/visite_securite/new_visite_securite_controller.dart';
import '../Controllers/visite_securite/visite_securite_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    //Get.put(HomeController(), permanent: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    //Get.lazyPut(() => LoginController());
    Get.put(LoginController(), permanent: true);
    //Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut(() => NetworkController(), fenix: true);
    Get.lazyPut(() => OnBoardingController(), fenix: true);
    //Get.putAsync<ParticipantController>(() async => await ParticipantController());
    Get.lazyPut(() => TaskController(), fenix: true);
    Get.lazyPut(() => ActionController(), fenix: true);
    Get.lazyPut(() => SousActionController(), fenix: true);
    Get.lazyPut(() => PNCController(), fenix: true);
    //Get.put(PNCController(), permanent: true);
    Get.lazyPut(() => NewPNCController(), fenix: true);
    Get.lazyPut(() => ReunionController(), fenix: true);
    //Get.put(ReunionController(), permanent: true);
    Get.lazyPut(() => NewReunionController(), fenix: true);
    Get.lazyPut(() => DocumentationController(), fenix: true);
    Get.lazyPut(() => IncidentEnvironnementController(), fenix: true);
    Get.lazyPut(() => NewIncidentEnvironnementController(), fenix: true);
    Get.lazyPut(() => IncidentSecuriteController(), fenix: true);
    Get.lazyPut(() => NewIncidentSecuriteController(), fenix: true);
    Get.lazyPut(() => VisiteSecuriteController(), fenix: true);
    Get.lazyPut(() => NewVisiteSecuriteController(), fenix: true);
    Get.lazyPut(() => AuditController(), fenix: true);
    Get.lazyPut(() => NewAuditController(), fenix: true);
  }
}