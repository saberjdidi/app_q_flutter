import 'package:qualipro_flutter/Models/Domaine_affectation_model.dart';
import 'package:qualipro_flutter/Models/action/action_realisation_model.dart';
import 'package:qualipro_flutter/Models/action/action_suite_audit.dart';
import 'package:qualipro_flutter/Models/action/action_suivi_model.dart';
import 'package:qualipro_flutter/Models/champ_cache_model.dart';
import 'package:qualipro_flutter/Models/champ_obligatoire_action_model.dart';
import 'package:qualipro_flutter/Models/client_model.dart';
import 'package:qualipro_flutter/Models/employe_model.dart';
import 'package:qualipro_flutter/Models/pnc/type_cause_pnc_model.dart';
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
import '../../Models/fournisseur_model.dart';
import '../../Models/gravite_model.dart';
import '../../Models/pnc/atelier_pnc_model.dart';
import '../../Models/pnc/champ_obligatoire_pnc_model.dart';
import '../../Models/pnc/gravite_pnc_model.dart';
import '../../Models/pnc/pnc_a_corriger_model.dart';
import '../../Models/pnc/pnc_a_traiter_model.dart';
import '../../Models/pnc/pnc_model.dart';
import '../../Models/pnc/pnc_suivre_model.dart';
import '../../Models/pnc/pnc_validation_decision_model.dart';
import '../../Models/pnc/product_pnc_model.dart';
import '../../Models/pnc/source_pnc_model.dart';
import '../../Models/pnc/traitement_decision_model.dart';
import '../../Models/pnc/type_pnc_model.dart';
import '../../Models/resp_cloture_model.dart';
import '../../Models/service_model.dart';
import '../../Models/site_model.dart';
import '../../Models/action/type_action_model.dart';
import '../../Models/type_cause_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalPNCService {

  DBHelper dbHelper = DBHelper();

  //champ obligatoire
  readChampObligatoirePNC() async {
    return await dbHelper.readChampObligatoirePNC(DBTable.champ_obligatoire_pnc);
  }
  saveChampObligatoirePNC(ChampObligatoirePNCModel model) async {
    return await dbHelper.insertChampObligatoirePNC(DBTable.champ_obligatoire_pnc, model.dataMap());
  }
  deleteTableChampObligatoirePNC() async {
    await dbHelper.deleteTableChampObligatoirePNC();
    print('delete table champ obligatoire PNC');
  }
  //Fournisseur
  readFournisseur() async {
    return await dbHelper.readFournisseur(DBTable.fournisseur);
  }
  saveFournisseur(FournisseurModel model) async {
    return await dbHelper.insertFournisseur(DBTable.fournisseur, model.dataMap());
  }
  deleteTableFournisseur() async {
    await dbHelper.deleteTableFournisseur();
    print('delete table Fournisseur');
  }
  //Client
  readClient() async {
    return await dbHelper.readClient(DBTable.client);
  }
  saveClient(ClientModel model) async {
    return await dbHelper.insertClient(DBTable.client, model.dataMap());
  }
  deleteTableClient() async {
    await dbHelper.deleteTableClient();
    print('delete table Client');
  }
  //Type PNC
  readTypePNC() async {
    return await dbHelper.readTypePNC(DBTable.type_pnc);
  }
  saveTypePNC(TypePNCModel model) async {
    return await dbHelper.insertTypePNC(DBTable.type_pnc, model.dataMap());
  }
  deleteTableTypePNC() async {
    await dbHelper.deleteTableTypePNC();
    print('delete table TypePNC');
  }
  //Gravite PNC
  readGravitePNC() async {
    return await dbHelper.readGravitePNC(DBTable.gravite_pnc);
  }
  saveGravitePNC(GravitePNCModel model) async {
    return await dbHelper.insertGravitePNC(DBTable.gravite_pnc, model.dataMap());
  }
  deleteTableGravitePNC() async {
    await dbHelper.deleteTableGravitePNC();
    print('delete table GravitePNC');
  }
  //Source PNC
  readSourcePNC() async {
    return await dbHelper.readSourcePNC(DBTable.source_pnc);
  }
  saveSourcePNC(SourcePNCModel model) async {
    return await dbHelper.insertSourcePNC(DBTable.source_pnc, model.dataMap());
  }
  deleteTableSourcePNC() async {
    await dbHelper.deleteTableSourcePNC();
    print('delete table SourcePNC');
  }
  //Atelier PNC
  readAtelierPNC() async {
    return await dbHelper.readAtelierPNC(DBTable.atelier_pnc);
  }
  saveAtelierPNC(AtelierPNCModel model) async {
    return await dbHelper.insertAtelierPNC(DBTable.atelier_pnc, model.dataMap());
  }
  deleteTableAtelierPNC() async {
    await dbHelper.deleteTableAtelierPNC();
    print('delete table AtelierPNC');
  }
  //PNC
  readPNC() async {
    return await dbHelper.readPNC();
  }
  readPNCByOnline() async {
    return await dbHelper.readPNCByOnline();
  }
  Future<List<PNCModel>> readListPNCByOnline() async {
    final response =  await dbHelper.readPNCByOnline();
    final List result = response;
    return result.map((
            (e) => PNCModel.fromDBLocal(e)
    )).toList();
  }
  getMaxNumPNC() async {
    return await dbHelper.getMaxNumPNC();
  }
  savePNC(PNCModel model) async {
    return await dbHelper.insertPNC(DBTable.pnc, model.dataMap());
  }
  savePNCSync(PNCModel model) async {
    return await dbHelper.insertPNC(DBTable.pnc, model.dataMapSync());
  }
  deleteTablePNC() async {
    await dbHelper.deleteTablePNC();
    print('delete Table PNC');
  }
  deletePNCOffline() async {
    await dbHelper.deletePNCOffline();
    print('delete Table PNC where online=0');
  }
  getPNCByNNC(nnc) async {
    return await dbHelper.readPNCByNNC(DBTable.pnc,nnc);
  }
  getCountPNC() async {
    return await dbHelper.getCountPNC();
  }
  //product PNC
  readProductPNC() async {
    return await dbHelper.readProductPNC(DBTable.product_pnc);
  }
  readProductByNNC(int? nnc) async {
    return await dbHelper.readProductByNNC(nnc);
  }
  readProductPNCByOnline() async {
    return await dbHelper.readProductPNCByOnline();
  }
  Future<List<ProductPNCModel>> readListProductPNCByOnline() async {
    final response =  await dbHelper.readProductPNCByOnline();
    final List result = response;
    return result.map((
            (e) => ProductPNCModel.fromDBLocal(e)
    )).toList();
  }
  saveProductPNC(ProductPNCModel model) async {
    return await dbHelper.insertProductPNC(DBTable.product_pnc, model.dataMap());
  }
  getMaxNumProductPNC() async {
    return await dbHelper.getMaxNumProductPNC();
  }
  deleteTableProductPNC() async {
    await dbHelper.deleteTableProductPNC();
    print('delete table ProductPNC');
  }
  //type cause PNC
  readTypeCausePNC() async {
    return await dbHelper.readTypeCausePNC(DBTable.type_cause_pnc);
  }
  readTypeCauseByNNC(int? nnc) async {
    return await dbHelper.readTypeCauseByNNC(nnc);
  }
  readTypeCauseByOnline() async {
    return await dbHelper.readTypeCauseByOnline();
  }
  Future<List<TypeCausePNCModel>> readListTypeCausePNCByOnline() async {
    final response =  await dbHelper.readTypeCauseByOnline();
    final List result = response;
    return result.map((
            (e) => TypeCausePNCModel.fromDBLocal(e)
    )).toList();
  }
  saveTypeCausePNC(TypeCausePNCModel model) async {
    return await dbHelper.insertTypeCausePNC(DBTable.type_cause_pnc, model.dataMap());
  }
  deleteTableTypeCausePNC() async {
    await dbHelper.deleteTableTypeCausePNC();
    print('delete table TypeCausePNC');
  }
  getMaxNumTypeCausePNC() async {
    return await dbHelper.getMaxNumTypeCausePNC();
  }
  //type cause a rattacher
  readAllTypeCausePNCARattacher() async {
    return await dbHelper.readAllTypeCausePNCARattacher(DBTable.type_cause_a_rattacher_pnc);
  }
  readTypeCausePNCARattacher(int? nnc) async {
    return await dbHelper.readTypeCausePNCARattacher(nnc);
  }
  saveTypeCausePNCARattacher(TypeCausePNCModel model) async {
    return await dbHelper.insertTypeCausePNCARattacher(DBTable.type_cause_a_rattacher_pnc, model.dataMapARattacher());
  }
  deleteTableTypeCausePNCARattacher() async {
    await dbHelper.deleteTableTypeCausePNCARattacher();
    print('delete table TypeCausePNCARattacher');
  }

  //Agenda
  //pnc a valider
  readPNCValider() async {
    return await dbHelper.readPNCValider(DBTable.pnc_valider);
  }
  savePNCValider(PNCCorrigerModel model) async {
    return await dbHelper.insertPNCValider(DBTable.pnc_valider, model.dataMapPNCValider());
  }
  deleteTablePNCValider() async {
    await dbHelper.deleteTablePNCValider();
    print('delete Table PNCValider ');
  }
  getCountPNCValider() async {
    return await dbHelper.getCountPNCValider();
  }
  //pnc a corriger
  readPNCACorriger() async {
    return await dbHelper.readPNCACorriger(DBTable.pnc_corriger);
  }
  savePNCACorriger(PNCCorrigerModel model) async {
    return await dbHelper.insertPNCACorriger(DBTable.pnc_corriger, model.dataMapPNCCorriger());
  }
  deleteTablePNCACorriger() async {
    await dbHelper.deleteTablePNCACorriger();
    print('delete Table PNCACorriger ');
  }
  getCountPNCACorriger() async {
    return await dbHelper.getCountPNCACorriger();
  }
  //pnc investigation effectuer
  readPNCInvestigationEffectuer() async {
    return await dbHelper.readPNCInvestigationEffectuer(DBTable.pnc_investigation_effectuer);
  }
  savePNCInvestigationEffectuer(PNCSuivreModel model) async {
    return await dbHelper.insertPNCInvestigationEffectuer(DBTable.pnc_investigation_effectuer, model.dataMapPNCInvestigationEffectuer());
  }
  deleteTablePNCInvestigationEffectuer() async {
    await dbHelper.deleteTablePNCInvestigationEffectuer();
    print('delete Table PNCInvestigationEffectuer ');
  }
  getCountPNCInvestigationEffectuer() async {
    return await dbHelper.getCountPNCInvestigationEffectuer();
  }
  //pnc investigation approuver
  readPNCInvestigationApprouver() async {
    return await dbHelper.readPNCInvestigationApprouver(DBTable.pnc_investigation_approuver);
  }
  savePNCInvestigationApprouver(PNCSuivreModel model) async {
    return await dbHelper.insertPNCInvestigationApprouver(DBTable.pnc_investigation_approuver, model.dataMapPNCInvestigationApprouver());
  }
  deleteTablePNCInvestigationApprouver() async {
    await dbHelper.deleteTablePNCInvestigationApprouver();
    print('delete Table PNCInvestigationApprouver');
  }
  getCountPNCInvestigationApprouver() async {
    return await dbHelper.getCountPNCInvestigationApprouver();
  }
  //pnc Decision
  readPNCDecision() async {
    return await dbHelper.readPNCDecision(DBTable.pnc_decision);
  }
  savePNCDecision(TraitementDecisionModel model) async {
    return await dbHelper.insertPNCDecision(DBTable.pnc_decision, model.dataMapPNCDecision());
  }
  deleteTablePNCDecision() async {
    await dbHelper.deleteTablePNCDecision();
    print('delete Table PNCDecision');
  }
  getCountPNCDecision() async {
    return await dbHelper.getCountPNCDecision();
  }
  //pnc a traiter
  readPNCATraiter() async {
    return await dbHelper.readPNCATraiter(DBTable.pnc_traiter);
  }
  savePNCATraiter(PNCTraiterModel model) async {
    return await dbHelper.insertPNCATraiter(DBTable.pnc_traiter, model.dataMapPNCATraiter());
  }
  deleteTablePNCATraiter() async {
    await dbHelper.deleteTablePNCATraiter();
    print('delete Table PNCATraiter');
  }
  getCountPNCATraiter() async {
    return await dbHelper.getCountPNCATraiter();
  }
  //pnc a suivre
  readPNCASuivre() async {
    return await dbHelper.readPNCASuivre(DBTable.pnc_suivre);
  }
  savePNCASuivre(PNCSuivreModel model) async {
    return await dbHelper.insertPNCASuivre(DBTable.pnc_suivre, model.dataMapPNCSuivre());
  }
  deleteTablePNCASuivre() async {
    await dbHelper.deleteTablePNCASuivre();
    print('delete Table PNCASuivre');
  }
  getCountPNCASuivre() async {
    return await dbHelper.getCountPNCASuivre();
  }
  //pnc approbation finale
  readPNCApprobationFinale() async {
    return await dbHelper.readPNCApprobationFinale(DBTable.pnc_approbation_finale);
  }
  savePNCApprobationFinale(PNCSuivreModel model) async {
    return await dbHelper.insertPNCApprobationFinale(DBTable.pnc_approbation_finale, model.dataMapPNCApprobationFinale());
  }
  deleteTablePNCApprobationFinale() async {
    await dbHelper.deleteTablePNCApprobationFinale();
    print('delete Table PNCApprobationFinale');
  }
  getCountPNCApprobationFinale() async {
    return await dbHelper.getCountPNCApprobationFinale();
  }
  //pnc decision validation
  readPNCDecisionValidation() async {
    return await dbHelper.readPNCDecisionValidation(DBTable.pnc_decision_validation);
  }
  savePNCDecisionValidation(PNCValidationTraitementModel model) async {
    return await dbHelper.insertPNCDecisionValidation(DBTable.pnc_decision_validation, model.dataMap());
  }
  deleteTablePNCDecisionValidation() async {
    await dbHelper.deleteTablePNCDecisionValidation();
    print('delete Table PNCDecisionValidation');
  }
  getCountPNCDecisionValidation() async {
    return await dbHelper.getCountPNCDecisionValidation();
  }
}