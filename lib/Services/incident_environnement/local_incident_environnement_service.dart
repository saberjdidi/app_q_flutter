import 'package:flutter/foundation.dart';
import 'package:qualipro_flutter/Models/incident_environnement/champ_obligatore_incident_env_model.dart';
import 'package:qualipro_flutter/Models/incident_environnement/cout_estime_inc_env_model.dart';
import 'package:qualipro_flutter/Models/incident_environnement/incident_env_model.dart';
import 'package:qualipro_flutter/Models/lieu_model.dart';
import 'package:qualipro_flutter/Models/secteur_model.dart';
import 'package:qualipro_flutter/Models/type_consequence_model.dart';
import '../../Models/category_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/incident_environnement/action_inc_env.dart';
import '../../Models/incident_environnement/incident_env_agenda_model.dart';
import '../../Models/incident_environnement/source_inc_env_model.dart';
import '../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../Models/incident_environnement/type_consequence_incident_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalIncidentEnvironnementService {
  DBHelper dbHelper = DBHelper();

  //incident environnement
  readIncidentEnvironnement() async {
    return await dbHelper.readIncidentEnvironnement();
  }

  searchIncidentEnvironnement(numero, type, designation) async {
    return await dbHelper.searchIncidentEnvironnement(
        numero, type, designation);
  }

  readIncidentEnvironnementByOnline() async {
    return await dbHelper.readIncidentEnvironnementByOnline();
  }

  Future<List<IncidentEnvModel>> readListIncidentEnvironnementByOnline() async {
    final response = await dbHelper.readIncidentEnvironnementByOnline();
    final List result = response;
    return result.map(((e) => IncidentEnvModel.fromDBLocal(e))).toList();
  }

  getMaxNumIncidentEnvironnement() async {
    return await dbHelper.getMaxNumIncidentEnvironnement();
  }

  saveIncidentEnvironnement(IncidentEnvModel model) async {
    return await dbHelper.insertIncidentEnvironnement(
        DBTable.incident_environnement, model.dataMap());
  }

  saveIncidentEnvironnementSync(IncidentEnvModel model) async {
    return await dbHelper.insertIncidentEnvironnement(
        DBTable.incident_environnement, model.dataMapSync());
  }

  deleteTableIncidentEnvironnement() async {
    await dbHelper.deleteTableIncidentEnvironnement();
    print('delete Table IncidentEnvironnement');
  }

  deleteIncidentEnvironnementOffline() async {
    await dbHelper.deleteIncidentEnvironnementOffline();
    print('delete Table IncidentEnv where online=0');
  }

  getIncidentEnvironnementByNumero(numero) async {
    return await dbHelper.readIncidentEnvironnementByNumero(
        DBTable.incident_environnement, numero);
  }

  getCountIncidentEnvironnement() async {
    return await dbHelper.getCountIncidentEnvironnement();
  }

  //Champ obligatoire
  readChampObligatoireIncidentEnv() async {
    return await dbHelper.readChampObligatoireIncidentEnv(
        DBTable.champ_obligatoire_incident_env);
  }

  saveChampObligatoireIncidentEnv(
      ChampObligatoireIncidentEnvModel model) async {
    return await dbHelper.insertChampObligatoireIncidentEnv(
        DBTable.champ_obligatoire_incident_env, model.dataMap());
  }

  deleteTableChampObligatoireIncidentEnv() async {
    await dbHelper.deleteTableChampObligatoireIncidentEnv();
    print('delete table ChampObligatoireIncidentEnv');
  }

  //Type Cause
  readTypeCauseIncidentEnv() async {
    return await dbHelper
        .readTypeCauseIncidentEnv(DBTable.type_cause_incident_env);
  }

  readTypeCauseIncidentEnvARattacher(incident) async {
    return await dbHelper.readTypeCauseIncidentEnvARattacher(incident);
  }

  saveTypeCauseIncidentEnv(TypeCauseIncidentModel model) async {
    return await dbHelper.insertTypeCauseIncidentEnv(
        DBTable.type_cause_incident_env, model.dataMapIncidentEnv());
  }

  deleteTableTypeCauseIncidentEnv() async {
    await dbHelper.deleteTableTypeCauseIncidentEnv();
    print('delete table TypeCauseIncidentEnv');
  }

  //type cause rattacher
  readTypeCauseRattacherEnvByIncident(incident) async {
    return await dbHelper.readTypeCauseRattacherEnvByIncident(
        DBTable.type_cause_incident_env_rattacher, incident);
  }

  Future<List<TypeCauseIncidentModel>>
      readTypeCauseIncidentEnvRattacherByOnline() async {
    final response = await dbHelper.readTypeCauseIncidentEnvRattacherByOnline();
    final List result = response;
    return result
        .map(((e) => TypeCauseIncidentModel.fromDBLocalIncEnv(e)))
        .toList();
  }

  saveTypeCauseRattacherIncidentEnv(TypeCauseIncidentModel model) async {
    return await dbHelper.insertTypeCauseRattacherIncidentEnv(
        DBTable.type_cause_incident_env_rattacher,
        model.dataMapIncidentEnvRattacher());
  }

  deleteTableTypeCauseIncidentEnvRattacher() async {
    await dbHelper.deleteTableTypeCauseIncidentEnvRattacher();
    debugPrint('delete table TypeCauseIncidentEnvRattacher');
  }

  getMaxNumTypeCauseIncidentEnvironnementRattacher() async {
    return await dbHelper.getMaxNumTypeCauseIncidentEnvironnementRattacher();
  }

  //Category
  readCategoryIncidentEnv() async {
    return await dbHelper
        .readCategoryIncidentEnv(DBTable.category_incident_env);
  }

  saveCategoryIncidentEnv(CategoryModel model) async {
    return await dbHelper.insertCategoryIncidentEnv(
        DBTable.category_incident_env, model.dataMap());
  }

  deleteTableCategoryIncidentEnv() async {
    await dbHelper.deleteTableCategoryIncidentEnv();
    print('delete table CategoryIncidentEnv');
  }

  //Type Consequence
  readTypeConsequenceIncidentEnv() async {
    return await dbHelper
        .readTypeConsequenceIncidentEnv(DBTable.type_consequence_incident_env);
  }

  readTypeConsequenceIncidentEnvARattacher(incident) async {
    return await dbHelper.readTypeConsequenceIncidentEnvARattacher(incident);
  }

  saveTypeConsequenceIncidentEnv(TypeConsequenceIncidentModel model) async {
    return await dbHelper.insertTypeConsequenceIncidentEnv(
        DBTable.type_consequence_incident_env, model.dataMapIncidentEnv());
  }

  deleteTableTypeConsequenceIncidentEnv() async {
    await dbHelper.deleteTableTypeConsequenceIncidentEnv();
    print('delete table TypeConsequenceIncidentEnv');
  }

  //type consequence rattacher
  readTypeConsequenceRattacherEnvByIncident(incident) async {
    return await dbHelper.readTypeConsequenceRattacherEnvByIncident(
        DBTable.type_consequence_incident_env_rattacher, incident);
  }

  Future<List<TypeConsequenceIncidentModel>>
      readTypeConsequenceIncidentEnvRattacherByOnline() async {
    final response =
        await dbHelper.readTypeConsequenceIncidentEnvRattacherByOnline();
    final List result = response;
    return result
        .map(((e) => TypeConsequenceIncidentModel.fromDBLocalIncEnv(e)))
        .toList();
  }

  saveTypeConsequenceRattacherIncidentEnv(
      TypeConsequenceIncidentModel model) async {
    return await dbHelper.insertTypeConsequenceRattacherIncidentEnv(
        DBTable.type_consequence_incident_env_rattacher,
        model.dataMapIncidentEnvRattacher());
  }

  deleteTableTypeConsequenceIncidentEnvRattacher() async {
    debugPrint('delete table TypeConsequenceIncidentEnvRattacher');
    return await dbHelper.deleteTableTypeConsequenceIncidentEnvRattacher();
  }

  getMaxNumTypeConsequenceIncidentEnvironnementRattacher() async {
    return await dbHelper
        .getMaxNumTypeConsequenceIncidentEnvironnementRattacher();
  }

  //Type
  readTypeIncidentEnv() async {
    return await dbHelper.readTypeIncidentEnv(DBTable.type_incident_env);
  }

  saveTypeIncidentEnv(TypeIncidentModel model) async {
    return await dbHelper.insertTypeIncidentEnv(
        DBTable.type_incident_env, model.dataMap());
  }

  deleteTableTypeIncidentEnv() async {
    await dbHelper.deleteTableTypeIncidentEnv();
    print('delete table TypeIncidentEnv');
  }

  //Lieu
  readLieuIncidentEnv() async {
    return await dbHelper.readLieuIncidentEnv(DBTable.lieu_incident_env);
  }

  saveLieuIncidentEnv(LieuModel model) async {
    return await dbHelper.insertLieuIncidentEnv(
        DBTable.lieu_incident_env, model.dataMapIncidentEnv());
  }

  deleteTableLieuIncidentEnv() async {
    await dbHelper.deleteTableLieuIncidentEnv();
    print('delete table LieuIncidentEnv');
  }

  //Source
  readSourceIncidentEnv() async {
    return await dbHelper.readSourceIncidentEnv(DBTable.source_incident_env);
  }

  saveSourceIncidentEnv(SourceIncidentEnvModel model) async {
    return await dbHelper.insertSourceIncidentEnv(
        DBTable.source_incident_env, model.dataMap());
  }

  deleteTableSourceIncidentEnv() async {
    await dbHelper.deleteTableSourceIncidentEnv();
    print('delete table SourceIncidentEnv');
  }

  //Cout Estime
  readCoutEstimeIncidentEnv() async {
    return await dbHelper
        .readCoutEstimeIncidentEnv(DBTable.cout_estime_incident_env);
  }

  saveCoutEstimeIncidentEnv(CoutEstimeIncidentEnvModel model) async {
    return await dbHelper.insertCoutEstimeIncidentEnv(
        DBTable.cout_estime_incident_env, model.dataMap());
  }

  deleteTableCoutEstimeIncidentEnv() async {
    await dbHelper.deleteTableCoutEstimeIncidentEnv();
    print('delete table CoutEstimeIncidentEnv');
  }

  //gravite
  readGraviteIncidentEnv() async {
    return await dbHelper.readGraviteIncidentEnv(DBTable.gravite_incident_env);
  }

  saveGraviteIncidentEnv(GraviteModel model) async {
    return await dbHelper.insertGraviteIncidentEnv(
        DBTable.gravite_incident_env, model.dataMap());
  }

  deleteTableGraviteIncidentEnv() async {
    await dbHelper.deleteTableGraviteIncidentEnv();
    print('delete table GraviteIncidentEnv');
  }

  //secteur
  readSecteurIncidentEnv() async {
    return await dbHelper.readSecteurIncidentEnv(DBTable.secteur_incident_env);
  }

  saveSecteurIncidentEnv(SecteurModel model) async {
    return await dbHelper.insertSecteurIncidentEnv(
        DBTable.secteur_incident_env, model.dataMapIncidentEnv());
  }

  deleteTableSecteurIncidentEnv() async {
    await dbHelper.deleteTableSecteurIncidentEnv();
    print('delete table SecteurIncidentEnv');
  }

  //action inc env rattacher
  readActionIncEnvRattacherByidFiche(idFiche) async {
    return await dbHelper.readActionIncEnvRattacherByidFiche(idFiche);
  }

  Future<List<ActionIncEnv>> readActionIncEnvRattacherByOnline() async {
    final response = await dbHelper.readActionIncEnvRattacherByOnline();
    final List result = response;
    return result.map((e) => ActionIncEnv.fromSQLite(e)).toList();
  }

  saveActionIncEnvRattacher(ActionIncEnv model) async {
    return await dbHelper.insertActionIncEnvRattacher(
        DBTable.action_inc_env_rattacher, model.toSQLite());
  }

  deleteTableActionIncEnvRattacher() async {
    debugPrint('delete Table ActionIncEnvRattacher');
    return await dbHelper.deleteTableActionIncEnvRattacher();
  }

  readActionIncEnvARattacher(idFiche) async {
    return await dbHelper.readActionIncEnvARattacher(idFiche);
  }

  //Agenda
  //decision traitement
  readIncidentEnvDecisionTraitement() async {
    return await dbHelper.readIncidentEnvDecisionTraitement(
        DBTable.incident_env_decision_traitement);
  }

  saveIncidentEnvDecisionTraitement(IncidentEnvAgendaModel model) async {
    return await dbHelper.insertIncidentEnvDecisionTraitement(
        DBTable.incident_env_decision_traitement, model.dataMap());
  }

  deleteTableIncidentEnvDecisionTraitement() async {
    await dbHelper.deleteTableIncidentEnvDecisionTraitement();
    print('delete Table IncidentEnvDecisionTraitement ');
  }

  getCountIncidentEnvDecisionTraitement() async {
    return await dbHelper.getCountIncidentEnvDecisionTraitement();
  }

  //incident a traiter
  readIncidentEnvATraiter() async {
    return await dbHelper
        .readIncidentEnvATraiter(DBTable.incident_env_a_traiter);
  }

  saveIncidentEnvATraiter(IncidentEnvAgendaModel model) async {
    return await dbHelper.insertIncidentEnvATraiter(
        DBTable.incident_env_a_traiter, model.dataMap());
  }

  deleteTableIncidentEnvATraiter() async {
    await dbHelper.deleteTableIncidentEnvATraiter();
    print('delete Table IncidentEnvATraiter ');
  }

  getCountIncidentEnvATraiter() async {
    return await dbHelper.getCountIncidentEnvATraiter();
  }

  //incident a cloturer
  readIncidentEnvACloturer() async {
    return await dbHelper
        .readIncidentEnvACloturer(DBTable.incident_env_a_cloturer);
  }

  saveIncidentEnvACloturer(IncidentEnvAgendaModel model) async {
    return await dbHelper.insertIncidentEnvACloturer(
        DBTable.incident_env_a_cloturer, model.dataMap());
  }

  deleteTableIncidentEnvACloturer() async {
    await dbHelper.deleteTableIncidentEnvACloturer();
    print('delete Table IncidentEnvACloturer ');
  }

  getCountIncidentEnvACloturer() async {
    return await dbHelper.getCountIncidentEnvACloturer();
  }
}
