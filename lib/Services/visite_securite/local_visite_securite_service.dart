import 'package:flutter/foundation.dart';
import 'package:qualipro_flutter/Models/site_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/checklist_critere_model.dart';
import 'package:qualipro_flutter/Models/visite_securite/taux_checklist_vs.dart';
import 'package:qualipro_flutter/Utils/Sqflite/db_helper.dart';
import '../../Models/visite_securite/action_visite_securite.dart';
import '../../Models/visite_securite/checklist_model.dart';
import '../../Models/visite_securite/equipe_model.dart';
import '../../Models/visite_securite/equipe_visite_securite_model.dart';
import '../../Models/visite_securite/unite_model.dart';
import '../../Models/visite_securite/visite_securite_model.dart';
import '../../Models/visite_securite/zone_model.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalVisiteSecuriteService {
  DBHelper dbHelper = DBHelper();

  readVisiteSecurite() async {
    return await dbHelper.readVisiteSecurite();
  }

  searchVisiteSecurite(numero, unite, zone) async {
    return await dbHelper.searchVisiteSecurite(numero, unite, zone);
  }

  readVisiteSecuriteByOnline() async {
    return await dbHelper.readVisiteSecuriteByOnline();
  }

  Future<List<VisiteSecuriteModel>> readListVisiteSecuriteByOnline() async {
    final response = await dbHelper.readVisiteSecuriteByOnline();
    final List result = response;
    return result.map(((e) => VisiteSecuriteModel.fromDBLocal(e))).toList();
  }

  getMaxNumVisiteSecurite() async {
    return await dbHelper.getMaxNumVisiteSecurite();
  }

  saveVisiteSecurite(VisiteSecuriteModel model) async {
    return await dbHelper.insertVisiteSecurite(
        DBTable.visite_securite, model.dataMap());
  }

  saveVisiteSecuriteSync(VisiteSecuriteModel model) async {
    return await dbHelper.insertVisiteSecurite(
        DBTable.visite_securite, model.dataMapSync());
  }

  deleteTableVisiteSecurite() async {
    await dbHelper.deleteTableVisiteSecurite();
    print('delete Table VisiteSecurite');
  }

  readVisiteSecuriteById(numero) async {
    return await dbHelper.readVisiteSecuriteById(
        DBTable.visite_securite, numero);
  }

  getCountVisiteSecurite() async {
    return await dbHelper.getCountVisiteSecurite();
  }

  //checklist
  readCheckList() async {
    return await dbHelper.readCheckList(DBTable.check_list);
  }

  saveCheckList(CheckListModel model) async {
    return await dbHelper.insertCheckList(DBTable.check_list, model.dataMap());
  }

  deleteTableCheckList() async {
    await dbHelper.deleteTableCheckList();
    print('delete table CheckList');
  }

  //unite
  readUniteVisiteSecurite() async {
    return await dbHelper
        .readUniteVisiteSecurite(DBTable.unite_visite_securite);
  }

  saveUniteVisiteSecurite(UniteModel model) async {
    return await dbHelper.insertUniteVisiteSecurite(
        DBTable.unite_visite_securite, model.dataMap());
  }

  deleteTableUniteVisiteSecurite() async {
    await dbHelper.deleteTableUniteVisiteSecurite();
    print('delete table UniteVisiteSecurite');
  }

  //zone
  readZoneVisiteSecurite() async {
    return await dbHelper.readZoneVisiteSecurite(DBTable.zone_visite_securite);
  }

  readZoneByIdUnite(int? idUnite) async {
    return await dbHelper.readZoneByIdUnite(idUnite);
  }

  saveZoneVisiteSecurite(ZoneModel model) async {
    return await dbHelper.insertZoneVisiteSecurite(
        DBTable.zone_visite_securite, model.dataMap());
  }

  deleteTableZoneVisiteSecurite() async {
    await dbHelper.deleteTableZoneVisiteSecurite();
    print('delete table ZoneVisiteSecurite');
  }

  //site
  readSiteVisiteSecurite() async {
    return await dbHelper.readSiteVisiteSecurite(DBTable.site_visite_securite);
  }

  saveSiteVisiteSecurite(SiteModel model) async {
    return await dbHelper.insertSiteVisiteSecurite(
        DBTable.site_visite_securite, model.dataMapVisiteSecurite());
  }

  deleteTableSiteVisiteSecurite() async {
    await dbHelper.deleteTableSiteVisiteSecurite();
    print('delete table SiteVisiteSecurite');
  }

  //equipe
  readEmployeEquipeVisiteSecurite() async {
    return await dbHelper.readEmployeEquipeVisiteSecurite();
  }

  readEquipeVisiteSecurite() async {
    return await dbHelper
        .readEquipeVisiteSecurite(DBTable.equipe_visite_securite);
  }

  saveEquipeVisiteSecurite(EquipeVisiteSecuriteModel model) async {
    return await dbHelper.insertEquipeVisiteSecurite(
        DBTable.equipe_visite_securite, model.dataMap());
  }

  deleteTableEquipeVisiteSecurite() async {
    await dbHelper.deleteTableEquipeVisiteSecurite();
    print('delete table EquipeVisiteSecurite');
  }

  deleteEmployeOfEquipeVisiteSecurite(id) async {
    await dbHelper.deleteEmployeOfEquipeVisiteSecurite(id);
    print('delete employe of EquipeVisiteSecurite');
  }

  //equipe to synchronize
  readEquipeVisiteSecuriteEmploye() async {
    return await dbHelper.readEquipeVisiteSecuriteEmploye(
        DBTable.equipe_visite_securite_employe);
  }

  readEquipeVisiteSecuriteEmployeById(idVisite) async {
    return await dbHelper.readEquipeVisiteSecuriteEmployeById(idVisite);
  }

  Future<List<EquipeModel>> readListEquipeVisiteSecuriteEmployeById(
      idVisite) async {
    final response =
        await dbHelper.readEquipeVisiteSecuriteEmployeById(idVisite);
    final List result = response;
    return result.map(((e) => EquipeModel.fromDBLocal(e))).toList();
  }

  saveEquipeVisiteSecuriteEmploye(EquipeModel model) async {
    return await dbHelper.insertEquipeVisiteSecuriteEmploye(
        DBTable.equipe_visite_securite_employe, model.dataMapToSync());
  }

  deleteTableEquipeVisiteSecuriteEmploye() async {
    await dbHelper.deleteTableEquipeVisiteSecuriteEmploye();
    print('delete table EquipeVisiteSecuriteEmploye');
  }

  //equipe to save in offline
  readEmployeEquipeVisiteSecuriteOffline(idFiche) async {
    return await dbHelper.readEmployeEquipeVisiteSecuriteOffline(idFiche);
  }

  readEquipeVisiteSecuriteOffline() async {
    return await dbHelper.readEquipeVisiteSecuriteOffline(
        DBTable.equipe_visite_securite_offline);
  }

  readEquipeVisiteSecuriteOfflineByIdFiche(idFiche) async {
    return await dbHelper.readEquipeVisiteSecuriteOfflineByIdFiche(idFiche);
  }

  readEquipeVisiteSecuriteOfflineByOnline() async {
    return await dbHelper.readEquipeVisiteSecuriteOfflineByOnline();
  }

  Future<List<EquipeVisiteSecuriteModel>> readListEquipeVSOffline() async {
    final response = await dbHelper.readEquipeVisiteSecuriteOfflineByOnline();
    final List result = response;
    return result.map((e) => EquipeVisiteSecuriteModel.fromSQLite(e)).toList();
  }

  saveEquipeVisiteSecuriteOffline(EquipeVisiteSecuriteModel model) async {
    return await dbHelper.insertEquipeVisiteSecuriteOffline(
        DBTable.equipe_visite_securite_offline, model.dataMapOffline());
  }

  deleteTableEquipeVisiteSecuriteOffline() async {
    await dbHelper.deleteTableEquipeVisiteSecuriteOffline();
    print('delete table EquipeVisiteSecuriteOffline');
  }

  //checklist rattacher
  readCheckListRattacherByidFiche(idFiche) async {
    return await dbHelper.readCheckListRattacherByidFiche(idFiche);
  }

  Future<List<CheckListCritereModel>> readCheckListRattacherByOnline() async {
    final response = await dbHelper.readCheckListRattacherByOnline();
    final List result = response;
    return result.map((e) => CheckListCritereModel.fromSQLite(e)).toList();
  }

  saveCheckListRattacher(CheckListCritereModel model) async {
    return await dbHelper.insertCheckListRattacher(
        DBTable.check_list_vs_rattacher, model.dataMapVS());
  }

  updateCheckListRattacher(CheckListCritereModel model) async {
    return await dbHelper.updateCheckListRattacher(
        DBTable.check_list_vs_rattacher, model.dataMapVS());
  }

  deleteTableCheckListRattacher() async {
    debugPrint('delete Table CheckListVSRattacher');
    return await dbHelper.deleteTableCheckListRattacher();
  }

  //taux checklist vs
  readTauxCheckListVSByidFiche(idFiche) async {
    return await dbHelper.readTauxCheckListVSByidFiche(idFiche);
  }

  saveTauxCheckListVS(TauxCheckListVS model) async {
    return await dbHelper.insertTauxCheckListVS(
        DBTable.taux_checklist_vs, model.dataMap());
  }

  deleteTableTauxCheckListVS() async {
    return await dbHelper.deleteTableTauxCheckListVS();
  }

  //action vs rattacher
  readActionVSRattacherByidFiche(idFiche) async {
    return await dbHelper.readActionVSRattacherByidFiche(idFiche);
  }

  Future<List<ActionVisiteSecurite>> readActionVSRattacherByOnline() async {
    final response = await dbHelper.readActionVSRattacherByOnline();
    final List result = response;
    return result.map((e) => ActionVisiteSecurite.fromSQLite(e)).toList();
  }

  saveActionVSRattacher(ActionVisiteSecurite model) async {
    return await dbHelper.insertActionVSRattacher(
        DBTable.action_visite_securite_rattacher, model.toSQLite());
  }

  deleteTableActionVSRattacher() async {
    debugPrint('delete Table ActionVSRattacher');
    return await dbHelper.deleteTableActionVSRattacher();
  }

  readActionVSARattacher(idFiche) async {
    return await dbHelper.readActionVSARattacher(idFiche);
  }
}
