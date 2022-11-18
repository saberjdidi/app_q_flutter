import 'package:qualipro_flutter/Models/Domaine_affectation_model.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';
import 'package:qualipro_flutter/Models/action/action_suite_audit.dart';
import 'package:qualipro_flutter/Models/action/action_suivi_model.dart';
import 'package:qualipro_flutter/Models/champ_cache_model.dart';
import 'package:qualipro_flutter/Models/champ_obligatoire_action_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/priorite_model.dart';
import 'package:qualipro_flutter/Models/processus_employe_model.dart';
import 'package:qualipro_flutter/Models/processus_model.dart';
import 'package:qualipro_flutter/Models/product_model.dart';
import 'package:qualipro_flutter/Models/action/source_action_model.dart';
import 'package:qualipro_flutter/Models/action/sous_action_model.dart';
import '../../Models/action/action_model.dart';
import '../../Models/action/action_sync.dart';
import '../../Models/activity_model.dart';
import '../../Models/audit_action_model.dart';
import '../../Models/direction_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/resp_cloture_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/action/type_action_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalActionService {
  DBHelper dbHelper = DBHelper();

  //Domaine Affectation
  readDomaineAffectation() async {
    return await dbHelper.readDomaineAffectation(DBTable.domaine_affectation);
  }

  readDomaineAffectationByModule(String? module, String? fiche) async {
    return await dbHelper.readDomaineAffectationByModule(module, fiche);
  }

  saveDomaineAffectation(DomaineAffectationModel model) async {
    return await dbHelper.insertDomaineAffectation(
        DBTable.domaine_affectation, model.dataMap());
  }

  deleteTableDomaineAffectation() async {
    await dbHelper.deleteTableDomaineAffectation();
    print('delete table DomaineAffectation');
  }

  //Champ Cache
  readChampCache() async {
    return await dbHelper.readChampCache(DBTable.champ_cache);
  }

  readChampCacheByModule(String? module, String? fiche) async {
    return await dbHelper.readChampCacheByModule(module, fiche);
  }

  saveChampCache(ChampCacheModel model) async {
    return await dbHelper.insertChampCache(
        DBTable.champ_cache, model.dataMap());
  }

  deleteTableChampCache() async {
    await dbHelper.deleteTableChampCache();
    print('delete table ChampCache');
  }

  //champ obligatoire
  readChampObligatoireAction() async {
    return await dbHelper
        .readChampObligatoireAction(DBTable.champ_obligatoire_action);
  }

  saveChampObligatoireAction(ChampObligatoireActionModel model) async {
    return await dbHelper.insertChampObligatoireAction(
        DBTable.champ_obligatoire_action, model.dataMap());
  }

  deleteTableChampObligatoireAction() async {
    await dbHelper.deleteTableChampObligatoireAction();
    print('delete all champ obligatoire');
  }

  //source action
  readSourceAction() async {
    return await dbHelper.readSourceAction(DBTable.source_action);
  }

  saveSourceAction(SourceActionModel model) async {
    return await dbHelper.insertSourceAction(
        DBTable.source_action, model.dataMap());
  }

  deleteAllSourceAction() async {
    await dbHelper.deleteAllSourceAction();
    print('delete all source action');
  }

  //type action
  readTypeAction() async {
    return await dbHelper.readTypeAction(DBTable.type_action);
  }

  saveTypeAction(TypeActionModel model) async {
    return await dbHelper.insertTypeAction(
        DBTable.type_action, model.dataMap());
  }

  deleteAllTypeAction() async {
    await dbHelper.deleteAllTypeAction();
    print('delete all type action');
  }

  //type cause action
  readTypeCauseAction() async {
    return await dbHelper.readTypeCauseAction(DBTable.type_cause_action);
  }

  Future<List<TypeCauseModel>> readTypeCauseActionOffline() async {
    final response = await dbHelper.readTypeCauseActionOffline();
    final List result = response;
    return result.map(((e) => TypeCauseModel.fromDBLocal(e))).toList();
  }

  readTypeCauseActionById(nAct) async {
    return await dbHelper.readTypeCauseActionById(nAct);
  }

  saveTypeCauseAction(TypeCauseModel model) async {
    return await dbHelper.insertTypeCauseAction(
        DBTable.type_cause_action, model.dataMapAction());
  }

  deleteTableTypeCauseAction() async {
    await dbHelper.deleteTableTypeCauseAction();
    print('delete table type cause action');
  }

  getMaxNumTypeCauseAction() async {
    return await dbHelper.getMaxNumTypeCauseAction();
  }

  //type cause action a rattacher
  readTypeCauseActionARattacher() async {
    return await dbHelper
        .readTypeCauseActionARattacher(DBTable.type_cause_action_a_rattacher);
  }

  readTypeCauseActionARattacherById(int? nAct) async {
    return await dbHelper.readTypeCauseActionARattacherById(nAct);
  }

  saveTypeCauseActionARattacher(TypeCauseModel model) async {
    return await dbHelper.insertTypeCauseActionARattacher(
        DBTable.type_cause_action_a_rattacher, model.dataMapActionARattacher());
  }

  deleteTableTypeCauseActionARattacher() async {
    await dbHelper.deleteTableTypeCauseActionARattacher();
    print('delete table TypeCauseActionARattacher');
  }

  //responsable cloture
  readResponsableCloture() async {
    return await dbHelper.readResponsableCloture(DBTable.resp_cloture);
  }

  readResponsableClotureParams(int? codeSite, int? codeProcessus) async {
    return await dbHelper.readResponsableClotureParams(codeSite, codeProcessus);
  }

  saveResponsableCloture(RespClotureModel model) async {
    return await dbHelper.insertResponsableCloture(
        DBTable.resp_cloture, model.dataMap());
  }

  deleteAllResponsableCloture() async {
    await dbHelper.deleteAllResponsableCloture();
    print('delete all responsable cloture');
  }

  //site
  readSite() async {
    return await dbHelper.readSite(DBTable.site);
  }

  readSiteByModule(module, fiche) async {
    return await dbHelper.readSiteByModule(module, fiche);
  }

  saveSite(SiteModel model) async {
    return await dbHelper.insertSite(DBTable.site, model.dataMap());
  }

  deleteAllSite() async {
    await dbHelper.deleteAllSite();
    print('delete all site');
  }

  //processus
  readProcessus() async {
    return await dbHelper.readProcessus(DBTable.processus);
  }

  readProcessusByModule(module, fiche) async {
    return await dbHelper.readProcessusByModule(module, fiche);
  }

  saveProcessus(ProcessusModel model) async {
    return await dbHelper.insertProcessus(DBTable.processus, model.dataMap());
  }

  deleteAllProcessus() async {
    await dbHelper.deleteAllProcessus();
    print('delete all processus');
  }

  //processus employe
  readProcessusByEmploye(String? mat) async {
    return await dbHelper.readProcessusByEmploye(mat);
  }

  saveProcessusEmploye(ProcessusEmployeModel model) async {
    return await dbHelper.insertProcessusEmploye(
        DBTable.processus_employe, model.dataMap());
  }

  deleteTableProcessusEmploye() async {
    await dbHelper.deleteTableProcessusEmploye();
    print('delete all processus employe');
  }

  //product
  readProduct() async {
    return await dbHelper.readProduct(DBTable.product);
  }

  saveProduct(ProductModel model) async {
    return await dbHelper.insertProduct(DBTable.product, model.dataMap());
  }

  deleteAllProduct() async {
    await dbHelper.deleteAllProduct();
    print('delete all product');
  }

  //direction
  readDirection() async {
    return await dbHelper.readDirection(DBTable.direction);
  }

  readDirectionByModule(module, fiche) async {
    return await dbHelper.readDirectionByModule(module, fiche);
  }

  saveDirection(DirectionModel model) async {
    return await dbHelper.insertDirection(DBTable.direction, model.dataMap());
  }

  deleteAllDirection() async {
    await dbHelper.deleteAllDirection();
    print('delete all direction');
  }

  //service
  readService() async {
    return await dbHelper.readService(DBTable.service);
  }

  readServiceByModuleAndDirection(module, fiche, codeDirection) async {
    return await dbHelper.readServiceByModuleAndDirection(
        module, fiche, codeDirection);
  }

  readServiceByCodeDirection(int? codeDirection) async {
    return await dbHelper.readServiceByCodeDirection(codeDirection);
  }

  saveService(ServiceModel model) async {
    return await dbHelper.insertService(DBTable.service, model.dataMap());
  }

  deleteAllService() async {
    await dbHelper.deleteAllService();
    print('delete all Service');
  }

  //activity
  readActivity() async {
    return await dbHelper.readActivity(DBTable.activity);
  }

  readActivityByModule(module, fiche) async {
    return await dbHelper.readActivityByModule(module, fiche);
  }

  saveActivity(ActivityModel model) async {
    return await dbHelper.insertActivity(DBTable.activity, model.dataMap());
  }

  deleteAllActivity() async {
    await dbHelper.deleteAllActivity();
    print('delete all activity');
  }

  //employe
  readEmploye() async {
    return await dbHelper.readEmploye(DBTable.employe);
  }

  saveEmploye(EmployeModel model) async {
    return await dbHelper.insertEmploye(DBTable.employe, model.dataMap());
  }

  deleteAllEmploye() async {
    print('delete all employe');
    return await dbHelper.deleteAllEmploye();
  }

  //audit action
  readAuditAction() async {
    return await dbHelper.readAuditAction(DBTable.audit_action);
  }

  saveAuditAction(AuditActionModel model) async {
    return await dbHelper.insertAuditAction(
        DBTable.audit_action, model.dataMap());
  }

  deleteAllAuditAction() async {
    await dbHelper.deleteAllAuditAction();
    print('delete all audit action');
  }

  //action
  readAction() async {
    return await dbHelper.readAction();
    //return await dbHelper.readAction2(DBTable.action);
  }

  searchAction(nAction, act, type) async {
    return await dbHelper.searchAction(nAction, act, type);
  }

  readNActionMax() async {
    return await dbHelper.readNActionMax();
  }

  getMaxNumAction() async {
    return await dbHelper.getMaxNumAction();
  }

  saveAction(ActionModel action) async {
    return await dbHelper.insertAction(DBTable.action, action.dataMap());
  }

  deleteAllAction() async {
    await dbHelper.deleteAllAction();
    print('delete all action');
  }

  editAction(ActionModel action) async {
    return await dbHelper.updateAction(DBTable.action, action.dataMap());
  }

  deleteAction(final id) async {
    return await dbHelper.deleteAction(DBTable.action, "nAct = ${id}");
  }

  getActionById(id) async {
    return await dbHelper.readActionById(DBTable.action, id);
  }

  //action sync
  readActionSync() async {
    return await dbHelper.readActionSync();
  }

  Future<List<ActionSync>> readListActionSync() async {
    final response = await dbHelper.readActionSync();
    final List result = response;
    return result.map(((e) => ActionSync.fromDBLocal(e))).toList();
  }

  readActionSync2() async {
    return await dbHelper.readActionSync2(DBTable.action_sync);
  }

  readIdActionSyncMax() async {
    return await dbHelper.readIdActionSyncMax();
  }

  saveActionSync(ActionSync action) async {
    return await dbHelper.insertActionSync(
        DBTable.action_sync, action.dataMap());
  }

  deleteTableActionSync() async {
    await dbHelper.deleteAllActionSync();
    print('delete table action sync');
  }

  getCountActionSync() async {
    return await dbHelper.getCountActionSync();
  }

  //priorite
  readPriorite() async {
    return await dbHelper.readPriorite(DBTable.priorite);
  }

  savePriorite(PrioriteModel model) async {
    return await dbHelper.insertPriorite(DBTable.priorite, model.dataMap());
  }

  deleteAllPriorite() async {
    await dbHelper.deleteAllPriorite();
    print('delete all priorite');
  }

  //gravite
  readGravite() async {
    return await dbHelper.readGravite(DBTable.gravite);
  }

  saveGravite(GraviteModel model) async {
    return await dbHelper.insertGravite(DBTable.gravite, model.dataMap());
  }

  deleteAllGravite() async {
    await dbHelper.deleteAllGravite();
    print('delete all Gravite');
  }

  //sous-action
  readSousAction() async {
    return await dbHelper.readSousAction(DBTable.sous_action);
  }

  readSousActionByNumAction(int? numAction) async {
    return await dbHelper.readSousActionByNumAction(numAction);
  }

  readSousActionByOnline() async {
    return await dbHelper.readSousActionByOnline();
  }

  Future<List<SousActionModel>> readListSousActionByOnline() async {
    final response = await dbHelper.readSousActionByOnline();
    final List result = response;
    return result.map(((e) => SousActionModel.fromDBLocal(e))).toList();
  }

  getMaxNumSousAction(int? numAction) async {
    return await dbHelper.getMaxNumSousAction(numAction);
  }

  saveSousAction(SousActionModel model) async {
    return await dbHelper.insertSousAction(
        DBTable.sous_action, model.dataMap());
  }

  deleteAllSousAction() async {
    await dbHelper.deleteAllSousAction();
    print('delete all SousAction');
  }

  deleteSousActionOffline() async {
    return await dbHelper.deleteSousActionOffline();
  }

  getCountSousActionOffline() async {
    return await dbHelper.getCountSousActionOffline();
  }

  //Agenda
  //action realisation
  readActionRealisation() async {
    return await dbHelper.readActionRealisation(DBTable.action_realisation);
  }

  saveActionRealisation(ActionRealisationModel model) async {
    return await dbHelper.insertActionRealisation(
        DBTable.action_realisation, model.dataMap());
  }

  deleteAllActionRealisation() async {
    await dbHelper.deleteAllActionRealisation();
    print('delete all ActionRealisation');
  }

  getCountActionRealisation() async {
    return await dbHelper.getCountActionRealisation();
  }

  //action suivi
  readActionSuivi() async {
    return await dbHelper.readActionSuivi(DBTable.action_suivi);
  }

  saveActionSuivi(ActionSuiviModel model) async {
    return await dbHelper.insertActionSuivi(
        DBTable.action_suivi, model.dataMap());
  }

  deleteAllActionSuivi() async {
    await dbHelper.deleteAllActionSuivi();
    print('delete all ActionSuivi');
  }

  getCountActionSuivi() async {
    return await dbHelper.getCountActionSuivi();
  }

  //action suite audit
  readActionSuiteAudit() async {
    return await dbHelper.readActionSuiteAudit(DBTable.action_suite_audit);
  }

  saveActionSuiteAudit(ActionSuiteAudit model) async {
    return await dbHelper.insertActionSuiteAudit(
        DBTable.action_suite_audit, model.dataMap());
  }

  deleteAllActionSuiteAudit() async {
    await dbHelper.deleteAllActionSuiteAudit();
    print('delete all ActionSuiteAudit');
  }

  getCountActionSuiteAudit() async {
    return await dbHelper.getCountActionSuiteAudit();
  }
}
