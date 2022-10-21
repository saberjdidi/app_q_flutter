import 'package:flutter/foundation.dart';
import 'package:qualipro_flutter/Models/incident_environnement/type_consequence_incident_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/cause_typique_model.dart';
import 'package:qualipro_flutter/Models/incident_securite/poste_travail_model.dart';

import '../../Models/category_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/incident_environnement/cout_estime_inc_env_model.dart';
import '../../Models/incident_environnement/type_cause_incident_model.dart';
import '../../Models/incident_securite/champ_obligatore_incident_securite_model.dart';
import '../../Models/incident_securite/evenement_declencheur_model.dart';
import '../../Models/incident_securite/incident_securite_agenda_model.dart';
import '../../Models/incident_securite/incident_securite_model.dart';
import '../../Models/incident_securite/site_lesion_model.dart';
import '../../Models/secteur_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Models/type_consequence_model.dart';
import '../../Models/type_incident_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalIncidentSecuriteService {

  DBHelper dbHelper = DBHelper();

  //incident securite
  readIncidentSecurite() async {
    return await dbHelper.readIncidentSecurite();
  }
  searchIncidentSecurite(numero, designation, type) async {
    return await dbHelper.searchIncidentSecurite(numero, designation, type);
  }
  readIncidentSecuriteByOnline() async {
    return await dbHelper.readIncidentSecuriteByOnline();
  }
  Future<List<IncidentSecuriteModel>> readListIncidentSecuriteByOnline() async {
    final response =  await dbHelper.readIncidentSecuriteByOnline();
    final List result = response;
    return result.map((
            (e) => IncidentSecuriteModel.fromDBLocal(e)
    )).toList();
  }
  getMaxNumIncidentSecurite() async {
    return await dbHelper.getMaxNumIncidentSecurite();
  }
  saveIncidentSecurite(IncidentSecuriteModel model) async {
    return await dbHelper.insertIncidentSecurite(DBTable.incident_securite, model.dataMap());
  }
  saveIncidentSecuriteSync(IncidentSecuriteModel model) async {
    return await dbHelper.insertIncidentSecurite(DBTable.incident_securite, model.dataMapSync());
  }
  deleteTableIncidentSecurite() async {
    await dbHelper.deleteTableIncidentSecurite();
    print('delete Table IncidentSecurite');
  }
  getIncidentSecuriteByNumero(numero) async {
    return await dbHelper.readIncidentSecuriteByNumero(DBTable.incident_securite, numero);
  }
  getCountIncidentSecurite() async {
    return await dbHelper.getCountIncidentSecurite();
  }
  //champ obligatoire
  readChampObligatoireIncidentSecurite() async {
    return await dbHelper.readChampObligatoireIncidentSecurite(DBTable.champ_obligatoire_incident_securite);
  }
  saveChampObligatoireIncidentSecurite(ChampObligatoireIncidentSecuriteModel model) async {
    return await dbHelper.insertChampObligatoireIncidentSecurite(DBTable.champ_obligatoire_incident_securite, model.dataMap());
  }
  deleteTableChampObligatoireIncidentSecurite() async {
    await dbHelper.deleteTableChampObligatoireIncidentSecurite();
    print('delete table ChampObligatoireIncidentSecurite');
  }
  //poste travail
  readPosteTravail() async {
    return await dbHelper.readPosteTravail(DBTable.poste_travail);
  }
  savePosteTravail(PosteTravailModel model) async {
    return await dbHelper.insertPosteTravail(DBTable.poste_travail, model.dataMap());
  }
  deleteTablePosteTravail() async {
    await dbHelper.deleteTablePosteTravail();
    print('delete table PosteTravail');
  }
  //type
  readTypeIncidentSecurite() async {
    return await dbHelper.readTypeIncidentSecurite(DBTable.type_incident_securite);
  }
  saveTypeIncidentSecurite(TypeIncidentModel model) async {
    return await dbHelper.insertTypeIncidentSecurite(DBTable.type_incident_securite, model.dataMap());
  }
  deleteTableTypeIncidentSecurite() async {
    await dbHelper.deleteTableTypeIncidentSecurite();
    print('delete table TypeIncidentSecurite');
  }
  //category
  readCategoryIncidentSecurite() async {
    return await dbHelper.readCategoryIncidentSecurite(DBTable.category_incident_securite);
  }
  saveCategoryIncidentSecurite(CategoryModel model) async {
    return await dbHelper.insertCategoryIncidentSecurite(DBTable.category_incident_securite, model.dataMap());
  }
  deleteTableCategoryIncidentSecurite() async {
    await dbHelper.deleteTableCategoryIncidentSecurite();
    print('delete table CategoryIncidentSecurite');
  }
  //type cause
  readTypeCauseIncidentSecurite() async {
    return await dbHelper.readTypeCauseIncidentSecurite(DBTable.type_cause_incident_securite);
  }
  readTypeCauseIncSecARattacher(incident) async {
    return await dbHelper.readTypeCauseIncSecARattacher(incident);
  }
  saveTypeCauseIncidentSecurite(TypeCauseIncidentModel model) async {
    return await dbHelper.insertTypeCauseIncidentSecurite(DBTable.type_cause_incident_securite, model.dataMapIncidentEnv());
  }
  deleteTableTypeCauseIncidentSecurite() async {
    await dbHelper.deleteTableTypeCauseIncidentSecurite();
    print('delete table TypeCauseIncidentSecurite');
  }
  //type cause rattacher
  readTypeCauseIncSecRattacher(incident) async {
    return await dbHelper.readTypeCauseIncSecRattacher(DBTable.type_cause_incident_securite_rattacher, incident);
  }
  Future<List<TypeCauseIncidentModel>> readTypeCauseIncidentSecRattacherByOnline() async {
    final response =  await dbHelper.readTypeCauseIncidentSecRattacherByOnline();
    final List result = response;
    return result.map((
            (e) => TypeCauseIncidentModel.fromDBLocalIncSec(e)
    )).toList();
  }
  saveTypeCauseIncSecRattacher(TypeCauseIncidentModel model) async {
    return await dbHelper.insertTypeCauseIncSecRattacher(DBTable.type_cause_incident_securite_rattacher, model.dataMapIncidentSecRattacher());
  }
  deleteTableTypeCauseIncSecRattacher() async {
    await dbHelper.deleteTableTypeCauseIncSecRattacher();
    debugPrint('delete table TypeCauseIncidentSecRattacher');
  }
  getMaxNumTypeCauseIncSecRattacher() async {
    return await dbHelper.getMaxNumTypeCauseIncSecRattacher();
  }
  //type consequence
  readTypeConsequenceIncidentSecurite() async {
    return await dbHelper.readTypeConsequenceIncidentSecurite(DBTable.type_consequence_incident_securite);
  }
  readTypeConsequenceIncSecARattacher(incident) async {
    return await dbHelper.readTypeConsequenceIncSecARattacher(incident);
  }
  saveTypeConsequenceIncidentSecurite(TypeConsequenceModel model) async {
    return await dbHelper.insertTypeConsequenceIncidentSecurite(DBTable.type_consequence_incident_securite, model.dataMapIncidentEnv());
  }
  deleteTableTypeConsequenceIncidentSecurite() async {
    await dbHelper.deleteTableTypeConsequenceIncidentSecurite();
    print('delete table TypeConsequenceIncidentSecurite');
  }
  //type conseq rattacher
  readTypeConsequenceIncSecRattacher(incident) async {
    return await dbHelper.readTypeConsequenceIncSecRattacher(DBTable.type_consequence_incident_securite_rattacher, incident);
  }
  Future<List<TypeConsequenceIncidentModel>> readTypeConsequenceIncSecRattacherByOnline() async {
    final response =  await dbHelper.readTypeConsequenceIncSecRattacherByOnline();
    final List result = response;
    return result.map((
            (e) => TypeConsequenceIncidentModel.fromDBLocalIncSec(e)
    )).toList();
  }
  saveTypeConsequenceIncSecRattacher(TypeConsequenceIncidentModel model) async {
    return await dbHelper.insertTypeConsequenceIncSecRattacher(DBTable.type_consequence_incident_securite_rattacher, model.dataMapIncSecRattacher());
  }
  deleteTableTypeConsequenceIncSecRattacher() async {
    await dbHelper.deleteTableTypeConsequenceIncSecRattacher();
    debugPrint('delete table TypeConsequenceIncidentSecRattacher');
  }
  getMaxNumTypeConsequenceIncSecRattacher() async {
    return await dbHelper.getMaxNumTypeConsequenceIncSecRattacher();
  }
  //Cause Typique a rattacher
  readCauseTypiqueIncidentSecurite() async {
    return await dbHelper.readCauseTypiqueIncidentSecurite(DBTable.cause_typique_incident_securite);
  }
  readCauseTypiqueIncSecARattacherByIncident(incident) async {
    return await dbHelper.readCauseTypiqueIncSecARattacherByIncident(incident);
  }
  saveCauseTypiqueIncidentSecurite(CauseTypiqueModel model) async {
    return await dbHelper.insertCauseTypiqueIncidentSecurite(DBTable.cause_typique_incident_securite, model.dataMapIncSecARattacher());
  }
  deleteTableCauseTypiqueIncidentSecurite() async {
    await dbHelper.deleteTableCauseTypiqueIncidentSecurite();
    print('delete table CauseTypiqueIncidentSecurite');
  }
  //cause typique rattacher
  Future<List<CauseTypiqueModel>> readCauseTypiqueIncSecRattacherByOnline() async {
    final response =  await dbHelper.readCauseTypiqueIncSecRattacherByOnline();
    final List result = response;
    return result.map((
            (e) => CauseTypiqueModel.fromDBLocal(e)
    )).toList();
  }
  readCauseTypiqueIncSecRattacher(incident) async {
    return await dbHelper.readCauseTypiqueIncSecRattacher(DBTable.cause_typique_incident_securite_rattacher, incident);
  }
  saveCauseTypiqueIncSecRattacher(CauseTypiqueModel model) async {
    return await dbHelper.insertCauseTypiqueIncSecRattacher(DBTable.cause_typique_incident_securite_rattacher, model.dataMapIncSecRattacher());
  }
  deleteTableCauseTypiqueIncSecRattacher() async {
    debugPrint('delete table CauseTypiqueIncSecRattacher');
    return await dbHelper.deleteTableCauseTypiqueIncSecRattacher();
  }
  getMaxNumCauseTypiqueIncSecRattacher() async {
    return await dbHelper.getMaxNumCauseTypiqueIncSecRattacher();
  }
  //site lesion
  readSiteLesionIncidentSecurite() async {
    return await dbHelper.readSiteLesionIncidentSecurite(DBTable.site_lesion_incident_securite);
  }
  readSiteLesionIncSecARattacherByIncident(incident) async {
    return await dbHelper.readSiteLesionIncSecARattacherByIncident(incident);
  }
  saveSiteLesionIncidentSecurite(SiteLesionModel model) async {
    return await dbHelper.insertSiteLesionIncidentSecurite(DBTable.site_lesion_incident_securite, model.dataMapSiteLesionARattacher());
  }
  deleteTableSiteLesionIncidentSecurite() async {
    await dbHelper.deleteTableSiteLesionIncidentSecurite();
    print('delete table SiteLesion');
  }
  //site lesion rattacher
  readSiteLesionIncSecRattacher(incident) async {
    return await dbHelper.readSiteLesionIncSecRattacher(DBTable.site_lesion_incident_securite_rattacher, incident);
  }
  Future<List<SiteLesionModel>> readSiteLesionIncSecRattacherByonline() async {
    final response = await dbHelper.readSiteLesionIncSecRattacherByonline();
    final List reslut = response;
    return reslut.map(
            (data) => SiteLesionModel.fromDBLocal(data)
    ).toList();
  }
  saveSiteLesionIncSecRattacher(SiteLesionModel model) async {
    return await dbHelper.insertSiteLesionIncSecRattacher(DBTable.site_lesion_incident_securite_rattacher, model.dataMapSiteLesionRattacher());
  }
  deleteTableSiteLesionIncSecRattacher() async {
    debugPrint('delete table SiteLesionIncSecRattacher');
    return await dbHelper.deleteTableSiteLesionIncSecRattacher();
  }
  getMaxNumSiteLesionIncSecRattacher() async {
    return await dbHelper.getMaxNumSiteLesionIncSecRattacher();
  }
  //gravite
  readGraviteIncidentSecurite() async {
    return await dbHelper.readGraviteIncidentSecurite(DBTable.gravite_incident_securite);
  }
  saveGraviteIncidentSecurite(GraviteModel model) async {
    return await dbHelper.insertGraviteIncidentSecurite(DBTable.gravite_incident_securite, model.dataMap());
  }
  deleteTableGraviteIncidentSecurite() async {
    await dbHelper.deleteTableGraviteIncidentSecurite();
    print('delete table GraviteIncidentSecurite');
  }
  //secteur
  readSecteurIncidentSecurite() async {
    return await dbHelper.readSecteurIncidentSecurite(DBTable.secteur_incident_securite);
  }
  saveSecteurIncidentSecurite(SecteurModel model) async {
    return await dbHelper.insertSecteurIncidentSecurite(DBTable.secteur_incident_securite, model.dataMapIncidentEnv());
  }
  deleteTableSecteurIncidentSecurite() async {
    await dbHelper.deleteTableSecteurIncidentSecurite();
    print('delete table SecteurIncidentSecurite');
  }
  //cout esteme
  readCoutEstimeIncidentSecurite() async {
    return await dbHelper.readCoutEstimeIncidentSecurite(DBTable.cout_estime_incident_securite);
  }
  saveCoutEstimeIncidentSecurite(CoutEstimeIncidentEnvModel model) async {
    return await dbHelper.insertCoutEstimeIncidentSecurite(DBTable.cout_estime_incident_securite, model.dataMap());
  }
  deleteTableCoutEstimeIncidentSecurite() async {
    await dbHelper.deleteTableCoutEstimeIncidentSecurite();
    print('delete table CoutEstimeIncidentSecurite');
  }
  //evenement declencheur
  readEvenementDeclencheurIncidentSecurite() async {
    return await dbHelper.readEvenementDeclencheurIncidentSecurite(DBTable.evenement_declencheur_incident_securite);
  }
  saveEvenementDeclencheurIncidentSecurite(EvenementDeclencheurModel model) async {
    return await dbHelper.insertEvenementDeclencheurIncidentSecurite(DBTable.evenement_declencheur_incident_securite, model.dataMap());
  }
  deleteTableEvenementDeclencheurIncidentSecurite() async {
    await dbHelper.deleteTableEvenementDeclencheurIncidentSecurite();
    print('delete table EvenementDeclencheurIncidentSecurite');
  }
  //Agenda
  //decision traitement
  readIncidentSecuriteDecisionTraitement() async {
    return await dbHelper.readIncidentSecuriteDecisionTraitement(DBTable.incident_securite_decision_traitement);
  }
  saveIncidentSecuriteDecisionTraitement(IncidentSecuriteAgendaModel model) async {
    return await dbHelper.insertIncidentSecuriteDecisionTraitement(DBTable.incident_securite_decision_traitement, model.dataMap());
  }
  deleteTableIncidentSecuriteDecisionTraitement() async {
    await dbHelper.deleteTableIncidentSecuriteDecisionTraitement();
    print('delete Table IncidentSecuriteDecisionTraitement');
  }
  getCountIncidentSecuriteDecisionTraitement() async {
    return await dbHelper.getCountIncidentSecuriteDecisionTraitement();
  }
  //incident a traiter
  readIncidentSecuriteATraiter() async {
    return await dbHelper.readIncidentSecuriteATraiter(DBTable.incident_securite_a_traiter);
  }
  saveIncidentSecuriteATraiter(IncidentSecuriteAgendaModel model) async {
    return await dbHelper.insertIncidentSecuriteATraiter(DBTable.incident_securite_a_traiter, model.dataMap());
  }
  deleteTableIncidentSecuriteATraiter() async {
    await dbHelper.deleteTableIncidentSecuriteATraiter();
    print('delete Table IncidentSecuriteATraiter');
  }
  getCountIncidentSecuriteATraiter() async {
    return await dbHelper.getCountIncidentSecuriteATraiter();
  }
  //incident a cloturer
  readIncidentSecuriteACloturer() async {
    return await dbHelper.readIncidentSecuriteACloturer(DBTable.incident_securite_a_cloturer);
  }
  saveIncidentSecuriteACloturer(IncidentSecuriteAgendaModel model) async {
    return await dbHelper.insertIncidentSecuriteACloturer(DBTable.incident_securite_a_cloturer, model.dataMap());
  }
  deleteTableIncidentSecuriteACloturer() async {
    await dbHelper.deleteTableIncidentSecuriteACloturer();
    print('delete Table IncidentSecuriteACloturer');
  }
  getCountIncidentSecuriteACloturer() async {
    return await dbHelper.getCountIncidentSecuriteACloturer();
  }
}