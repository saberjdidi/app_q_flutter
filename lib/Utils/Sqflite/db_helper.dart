import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_table.dart';

class DBHelper {
  // ? accept null
  //! return !null
  static Database? _db; //_db static and private

  Future<Database?> get db async {
    if (_db == null) {
      //intialization
      _db = await initializeDb();
      return _db;
    } else {
      return _db;
    }
  }

  //initialize the database
  initializeDb() async {
    // Get a location using getDatabasesPath
    String databasepath = await getDatabasesPath();
    // Set your path to the database.
    String path = join(databasepath, DBTable.DB_Name);
    // to Opening a database path
    Database mydb = await openDatabase(path,
        onCreate: _onCreatingDatabase,
        version: 1,
        onUpgrade: _onUpgradingDatabase);
    return mydb;
  }

  _onCreatingDatabase(Database database, int version) async {
    //add on table
    /*await database.execute("CREATE TABLE site(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    print("create database and table"); */

    //many tables
    //Batch use when add many table in database
    Batch batch = database.batch();
    batch.execute(
        "CREATE TABLE ${DBTable.licence_info}(id INTEGER PRIMARY KEY AUTOINCREMENT, client TEXT, licence TEXT, nbInstall TEXT, nbInstallTaken TEXT, webservice TEXT, downloadLink TEXT, host TEXT, nbDays TEXT, deviceId TEXT, deviceName TEXT, action INTEGER, audit INTEGER, docm INTEGER, incinv INTEGER, incsecu INTEGER, pnc INTEGER, reunion INTEGER, visite INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.mobile_licence}(id INTEGER PRIMARY KEY AUTOINCREMENT, LicenseStart TEXT, LicenseEnd TEXT, DeviceId TEXT, LicenseKey TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.user}(id INTEGER PRIMARY KEY AUTOINCREMENT, mat TEXT, nompre TEXT, supeer INTEGER, change INTEGER, bloque INTEGER, login TEXT, password TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.resp_cloture}(id INTEGER PRIMARY KEY AUTOINCREMENT, mat TEXT, codeSite INTEGER, codeProcessus INTEGER, nompre TEXT, site TEXT, processus TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.site}(id INTEGER PRIMARY KEY AUTOINCREMENT, codesite INTEGER, site TEXT, module TEXT, fiche TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.processus}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeProcessus INTEGER, processus TEXT, module TEXT, fiche TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.processus_employe}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeProcessus INTEGER, processus TEXT, mat TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.product}(id INTEGER PRIMARY KEY AUTOINCREMENT, codePdt TEXT, produit TEXT, prix INTEGER, typeProduit TEXT, codeTypeProduit INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.direction}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeDirection INTEGER, direction TEXT, module TEXT, fiche TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.employe}(id INTEGER PRIMARY KEY AUTOINCREMENT, mat TEXT, nompre TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.activity}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeDomaine INTEGER, domaine TEXT, module TEXT, fiche TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.service}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeService INTEGER, service TEXT, codeDirection INTEGER, module TEXT, fiche TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.domaine_affectation}(id INTEGER, module TEXT, fiche TEXT, vSite INTEGER, oSite INTEGER, rSite INTEGER, vProcessus INTEGER, oProcessus INTEGER, rProcessus INTEGER, vDomaine INTEGER, oDomaine INTEGER, rDomaine INTEGER, vDirection INTEGER, oDirection INTEGER, rDirection INTEGER, vService INTEGER, oService INTEGER, rService INTEGER, vEmpSite INTEGER, vEmpProcessus INTEGER, vEmpDomaine INTEGER, vEmpDirection INTEGER, vEmpService INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.priorite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codepriorite INTEGER, priorite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.gravite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codegravite INTEGER, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.champ_cache}(id INTEGER, module TEXT, fiche TEXT, listOrder INTEGER, nomParam TEXT, visible INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.fournisseur}(id INTEGER PRIMARY KEY AUTOINCREMENT, raisonSociale TEXT, activite TEXT, codeFr TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.client}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeclt TEXT, nomClient TEXT)");
    //-----------------------------------------Module Action-----------------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.source_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeSouceAct INTEGER, sourceAct TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, codetypeAct INTEGER, typeAct TEXT, actSimpl INTEGER, analyseCause INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nAct INTEGER, idTypeCause INTEGER, codetypecause INTEGER, typecause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_action_a_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, codetypecause INTEGER, typecause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.audit_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, idaudit INTEGER, refAudit TEXT, interne TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.champ_obligatoire_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, commentaire_Realisation_Action INTEGER, rapport_Suivi_Action INTEGER, delai_Suivi_Action INTEGER, priorite INTEGER, gravite INTEGER, commentaire INTEGER)");
    //batch.execute("CREATE TABLE ${DBTable.action}(nAct INTEGER PRIMARY KEY AUTOINCREMENT, site TEXT, sourceAct TEXT, typeAct TEXT, cloture INTEGER, date TEXT, act TEXT, matdeclencheur TEXT, nomOrigine TEXT, respClot INTEGER, idAudit INTEGER, actionPlus0 TEXT, actionPlus1 TEXT, datsuivPrv TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.action}(id INTEGER PRIMARY KEY AUTOINCREMENT, nAct INTEGER, site TEXT, sourceAct TEXT, typeAct TEXT, cloture INTEGER, date TEXT, act TEXT, matdeclencheur TEXT, nomOrigine TEXT, respClot INTEGER, idAudit INTEGER, actionPlus0 TEXT, actionPlus1 TEXT, online INTEGER)");
    //    batch.execute("CREATE TABLE ${DBTable.action_sync}(id INTEGER PRIMARY KEY AUTOINCREMENT, action TEXT, typea INTEGER, codesource INTEGER, refAudit TEXT, descpb TEXT, cause TEXT, datepa TEXT, cloture INTEGER, codesite INTEGER, matdeclencheur TEXT, commentaire TEXT, respsuivi TEXT, datesaisie TEXT, matOrigine TEXT, objectif TEXT, respclot TEXT, annee INTEGER, refInterne TEXT, direction INTEGER, process INTEGER, domaine INTEGER, service INTEGER, listProduct TEXT, listTypeCause BLOB)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_sync}(id INTEGER PRIMARY KEY AUTOINCREMENT, action TEXT, typea INTEGER, codesource INTEGER, refAudit TEXT, descpb TEXT, cause TEXT, datepa TEXT, cloture INTEGER, codesite INTEGER, matdeclencheur TEXT, commentaire TEXT, respsuivi TEXT, datesaisie TEXT, matOrigine TEXT, objectif TEXT, respclot TEXT, annee INTEGER, refInterne TEXT, direction INTEGER, process INTEGER, domaine INTEGER, service INTEGER, listTypeCause BLOB)");
    batch.execute(
        "CREATE TABLE ${DBTable.sous_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, nSousAct INTEGER, nAct INTEGER, cloture INTEGER, sousAct TEXT, delaiReal TEXT, delaiSuivi TEXT, dateReal TEXT, dateSuivi TEXT, coutPrev INTEGER, pourcentReal INTEGER, depense INTEGER, pourcentSuivie INTEGER, rapportEff TEXT, commentaire TEXT, respRealNompre TEXT, respSuiviNompre TEXT, respRealMat TEXT, respSuiviMat TEXT, priorite TEXT, codePriorite INTEGER, gravite TEXT, codeGravite INTEGER, processus TEXT, risques TEXT, online INTEGER)");

    //------------------------------------Module PNC-------------------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.champ_obligatoire_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, numInterne INTEGER, enregistre INTEGER, dateLivr INTEGER, numOf INTEGER, numLot INTEGER, fournisseur INTEGER, qteDetect INTEGER, qteProduite INTEGER, unite INTEGER, gravite INTEGER, source INTEGER, atelier INTEGER, origine INTEGER, nonConf INTEGER, traitNc INTEGER, typeTrait INTEGER, respTrait INTEGER, delaiTrait INTEGER, respSuivi INTEGER, datTrait INTEGER, coutTrait INTEGER, quantite INTEGER, valeur INTEGER, rapTrait INTEGER, datClo INTEGER, rapClo INTEGER, pourcTypenc INTEGER, detectPar INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeTypeNC INTEGER, typeNC TEXT, color TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.gravite_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, nGravite INTEGER, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.source_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeSourceNC INTEGER, sourceNC TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.atelier_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeAtelier INTEGER, atelier TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nnc INTEGER, codePdt TEXT, codeTypeNC INTEGER, dateDetect TEXT, dateLivraison TEXT, nc TEXT, unite TEXT, valRej INTEGER, qteDetect INTEGER, recep TEXT, traitee INTEGER, etatNC INTEGER, actionIm TEXT, dateSaisie TEXT, codeFournisseur TEXT, codeClient TEXT, numInterne TEXT, qteProduct INTEGER, numeroOf TEXT, numeroLot TEXT, matOrigine TEXT, isps TEXT, codeGravite INTEGER, codeSource INTEGER, codeSite INTEGER, codeProcessus INTEGER, codeDirection INTEGER, codeService INTEGER, codeActivity INTEGER, codeAtelier INTEGER, bloque INTEGER, isole INTEGER, pourcentage INTEGER, typeNC TEXT, produit TEXT, site TEXT, fournisseur TEXT, rapportT TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.product_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nnc INTEGER, idNCProduct INTEGER, codeProduit TEXT, produit TEXT, numOf TEXT, numLot TEXT, qdetect INTEGER, qprod INTEGER, typeProduit TEXT, unite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nnc INTEGER, idTypeCause INTEGER, codetypecause INTEGER, typecause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_a_rattacher_pnc}(id INTEGER PRIMARY KEY AUTOINCREMENT, codetypecause INTEGER, typecause TEXT)");
    //---------------------------------Module Reunion------------------------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.type_reunion}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeTypeR INTEGER, typeReunion TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.reunion}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nReunion INTEGER, typeReunion TEXT, codeTypeReunion INTEGER, datePrev TEXT, dateReal TEXT, etat TEXT, lieu TEXT, site TEXT, ordreJour TEXT, dureePrev TEXT, heureDeb TEXT, heureFin TEXT, dureeReal TEXT, commentaire TEXT, codeSite INTEGER, codeProcessus INTEGER, codeDirection INTEGER, codeService INTEGER, codeActivity INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.participant_reunion}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nReunion INTEGER, mat TEXT, nompre TEXT, comment TEXT, aparticipe INTEGER, confirm INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_reunion_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, nReunion INTEGER, nAct INTEGER, decision TEXT, act TEXT, efficacite REAL, tauxRealisation REAL, actSimplif INTEGER)");
    //---------------------------------Module Documentation-----------------------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.documentation}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, cdi TEXT, libelle TEXT, indice TEXT, typeDI TEXT, fichierLien TEXT, motifMAJ TEXT, fl TEXT, dateRevis TEXT, suffixe TEXT, favoris INTEGER, favorisEtat TEXT, mail INTEGER, dateCreat TEXT, dateRevue TEXT, dateprochRevue TEXT, superv TEXT, sitesuperv TEXT, important INTEGER, issuperviseur INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_document}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeType INTEGER, type TEXT)");

    //--------------------------------------Module Incident Environnement-----------------------------------------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.champ_obligatoire_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, incCat INTEGER, incTypecons INTEGER, incTypecause INTEGER, lieu INTEGER, desIncident INTEGER, typeIncident INTEGER, dateIncident INTEGER, actionImmediates INTEGER, descIncident INTEGER, descCauses INTEGER, gravite INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_environnement}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, n INTEGER, incident TEXT, dateDetect TEXT, lieu TEXT, type TEXT, source TEXT, act INTEGER, secteur TEXT, poste TEXT, site TEXT, processus TEXT, domaine TEXT, direction TEXT, service TEXT, typeCause TEXT, typeConseq TEXT, delaiTrait TEXT, traite INTEGER, cloture INTEGER, categorie TEXT, gravite TEXT, statut INTEGER, codeLieu TEXT, codeSecteur TEXT, codeType INTEGER, codeGravite INTEGER, codeSource INTEGER, codeCoutEsteme INTEGER, detectedEmployeMatricule TEXT, origineEmployeMatricule TEXT, rapport TEXT, codeCategory INTEGER, heure TEXT, codeSite INTEGER, codeProcessus INTEGER, codeDirection INTEGER, codeService INTEGER, codeActivity INTEGER, descriptionConsequence TEXT, descriptionCause TEXT, actionImmediate TEXT, quantity TEXT, numInterne TEXT, isps TEXT, listTypeCause BLOB, listTypeConsequence BLOB)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idTypeCause INTEGER, typeCause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_incident_env_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncidentCause INTEGER, idTypeCause INTEGER, typeCause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.category_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idCategorie INTEGER, categorie TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_consequence_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idTypeConseq INTEGER, typeConseq TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_consequence_incident_env_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncidentConseq INTEGER, idTypeConseq INTEGER, typeConseq TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idType INTEGER, typeIncident TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.lieu_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, lieu TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.source_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idSource INTEGER, source TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.cout_estime_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, idCout INTEGER, cout TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.gravite_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, codegravite INTEGER, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.secteur_incident_env}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeSecteur TEXT, secteur TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_inc_env_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, idFiche INTEGER, nAct INTEGER, act TEXT)");
    //-----------------------------------Module Incident Securite--------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.champ_obligatoire_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, incidentGrav INTEGER, incidentCat INTEGER, incidentTypeCons INTEGER, incidentTypeCause INTEGER, incidentPostet INTEGER, incidentSecteur INTEGER, incidentDescInc INTEGER, incidentDescCons INTEGER, incidentDescCause INTEGER, incidentAct INTEGER, incidentNbrj INTEGER, incidentDesig INTEGER, incidentClot INTEGER, risqueClot INTEGER, incidentSemaine INTEGER, incidentSiteLesion INTEGER, incidentCauseTypique INTEGER, incidentEventDeclencheur INTEGER, dateVisite INTEGER, comportementsObserve INTEGER, comportementRisquesObserves INTEGER, correctionsImmediates INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, ref INTEGER, online INTEGER, typeIncident TEXT, site TEXT, dateInc TEXT, contract TEXT, statut INTEGER, designation TEXT, gravite TEXT, categorie TEXT, typeConsequence TEXT, typeCause TEXT, secteur TEXT, dateCreation TEXT, detectedEmployeMatricule TEXT, codeType TEXT, codePoste TEXT, codeGravite TEXT, codeCategory TEXT, codeSecteur TEXT, codeEvenementDeclencheur TEXT, heure TEXT, codeCoutEsteme INTEGER, codeSite INTEGER, codeProcessus INTEGER, codeDirection INTEGER, codeService INTEGER, codeActivity INTEGER, descriptionIncident TEXT, descriptionConsequence TEXT, descriptionCause TEXT, actionImmediate TEXT, nombreJour INTEGER, numInterne TEXT, isps TEXT, week TEXT, listTypeCause BLOB, listTypeConsequence BLOB, listCauseTypique BLOB, listSiteLesion BLOB)");
    batch.execute(
        "CREATE TABLE ${DBTable.poste_travail}(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, poste TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idType INTEGER, typeIncident TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.category_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idCategorie INTEGER, categorie TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.cause_typique_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idTypeCause INTEGER, causeTypique TEXT, idCauseTypique INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.cause_typique_incident_securite_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncidentCauseTypique INTEGER, idCauseTypique INTEGER, causeTypique TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idTypeCause INTEGER, typeCause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_cause_incident_securite_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncidentCause INTEGER, idTypeCause INTEGER, typeCause TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_consequence_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idTypeConseq INTEGER, typeConseq TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_consequence_incident_securite_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncidentConseq INTEGER, idTypeConseq INTEGER, typeConseq TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.site_lesion_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeSiteLesion INTEGER, siteLesion TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.site_lesion_incident_securite_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, incident INTEGER, idIncCodeSiteLesion INTEGER, codeSiteLesion INTEGER, siteLesion TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.gravite_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codegravite INTEGER, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.secteur_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeSecteur TEXT, secteur TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.cout_estime_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idCout INTEGER, cout TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.evenement_declencheur_incident_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idEvent INTEGER, event TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_inc_sec_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, idFiche INTEGER, nAct INTEGER, act TEXT)");
    //---------------------------------------Module Visite Securite-----------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.visite_securite}(idVisiteSec INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, id INTEGER, site TEXT, dateVisite TEXT, unite TEXT, zone TEXT, checkList TEXT, idCheckList INTEGER, idUnite INTEGER, idZone INTEGER, codeSite INTEGER, situationObserve TEXT, comportementSurObserve TEXT, comportementRisqueObserve TEXT, correctionImmediate TEXT, autres TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.check_list}(id INTEGER PRIMARY KEY AUTOINCREMENT, idCheck INTEGER, code TEXT, checklist TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.unite_visite_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idUnite INTEGER, code TEXT, unite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.zone_visite_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idZone INTEGER, idUnite INTEGER, code TEXT, zone TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.site_visite_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, codesite INTEGER, site TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.equipe_visite_securite}(id INTEGER PRIMARY KEY AUTOINCREMENT, affectation INTEGER, mat TEXT, nompre TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.equipe_visite_securite_employe}(idEquipe INTEGER PRIMARY KEY AUTOINCREMENT, id INTEGER, affectation INTEGER, mat TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.equipe_visite_securite_offline}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, idFiche INTEGER, affectation INTEGER, mat TEXT, nompre TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.check_list_vs_rattacher} (online INTEGER, id INTEGER, idFiche INTEGER, idReg INTEGER, lib TEXT, eval INTEGER, commentaire TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.taux_checklist_vs} (id INTEGER, taux INTEGER)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_visite_securite_rattacher} (id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, idFiche INTEGER, nAct INTEGER, act TEXT)");
    //---------------------------------------Module Audit-----------------------------------------
    batch.execute(
        "CREATE TABLE ${DBTable.audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, idAudit INTEGER, refAudit TEXT, dateDebPrev TEXT, etat INTEGER, dateDeb TEXT, champ TEXT, site TEXT, interne TEXT, cloture TEXT, typeA TEXT, validation INTEGER, dateFinPrev TEXT, audit TEXT, objectif TEXT, rapportClot TEXT, codeTypeA INTEGER, codeSite INTEGER, idProcess INTEGER, idDomaine INTEGER, idDirection INTEGER, idService INTEGER, listCodeChamp BLOB)");
    batch.execute(
        "CREATE TABLE ${DBTable.gravite_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, codegravite INTEGER, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_constat_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeType INTEGER, type TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.champ_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeChamp INTEGER, champ TEXT, criticite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.champ_audit_constat}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, refAudit TEXT, codeChamp INTEGER, champ TEXT, criticite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.type_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, codeType INTEGER, type TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.constat_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, refAudit TEXT, idAudit INTEGER, nact INTEGER, idCrit INTEGER, ngravite INTEGER, codeTypeE INTEGER, gravite TEXT, typeE TEXT, mat TEXT, nomPre TEXT, prov INTEGER, idEcart INTEGER, pr INTEGER, ps INTEGER, descPb TEXT, act TEXT, typeAct INTEGER, sourceAct INTEGER, codeChamp INTEGER, champ TEXT, delaiReal TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.auditeur_interne}(id INTEGER PRIMARY KEY AUTOINCREMENT, online INTEGER, refAudit TEXT, mat TEXT, nompre TEXT, affectation TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.auditeur_interne_a_rattacher}(id INTEGER PRIMARY KEY AUTOINCREMENT, refAudit TEXT, mat TEXT, nompre TEXT)");

    //------------------------------------Agenda-----------------------------------------------------
    //action
    batch.execute(
        "CREATE TABLE ${DBTable.action_realisation}(id INTEGER PRIMARY KEY AUTOINCREMENT, nAct INTEGER, nSousAct INTEGER, act TEXT, sousAct TEXT, nomPrenom TEXT, respReal TEXT, delaiReal TEXT, delaiSuivi TEXT, dateReal TEXT, dateSuivi TEXT, pourcentReal INTEGER, depense INTEGER, commentaire TEXT, dateSaisieReal TEXT, cloture INTEGER, priorite TEXT, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_suivi}(id INTEGER PRIMARY KEY AUTOINCREMENT, nAct INTEGER, nSousAct TEXT, act TEXT, sousAct TEXT, nomPrenom TEXT, rapportEff TEXT, delaiSuivi TEXT, dateReal TEXT, dateSuivi TEXT, causeModif TEXT, pourcentReal INTEGER, depense INTEGER, pourcentSuivie INTEGER, commentaire TEXT, dateSaisieSuiv TEXT, priorite TEXT, gravite TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.action_suite_audit}(id INTEGER PRIMARY KEY AUTOINCREMENT, nAct INTEGER, act TEXT, datsuivPrv TEXT, ind INTEGER, isd INTEGER)");
    //pnc
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_valider}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, codepdt TEXT, nlot TEXT, ind INTEGER, traitee INTEGER, dateT TEXT, dateST TEXT, ninterne TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_investigation_effectuer}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, nlot TEXT, codepdt TEXT, ind INTEGER, nomClt TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_investigation_approuver}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, nlot TEXT, codepdt TEXT, ind INTEGER, nomClt TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_decision}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, nlot TEXT, codepdt TEXT, ind INTEGER, nc TEXT, nomClt TEXT, commentaire TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_traiter}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, nlot TEXT, codepdt TEXT, ind INTEGER, traitee INTEGER, dateT TEXT, dateST TEXT, nc TEXT, nomClt TEXT, traitement TEXT, typeT TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_corriger}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, motifRefus TEXT, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, codepdt TEXT, nlot TEXT, ind INTEGER, traitee INTEGER, dateT TEXT, dateST TEXT, ninterne TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_suivre}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, traitee INTEGER, delaiTrait TEXT, nlot TEXT, codepdt TEXT, ind INTEGER, nc TEXT, nomClt TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_approbation_finale}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, nlot TEXT, codepdt TEXT, ind INTEGER, nomClt TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.pnc_decision_validation}(id INTEGER PRIMARY KEY AUTOINCREMENT, nnc INTEGER, dateDetect TEXT, produit TEXT, typeNC TEXT, qteDetect INTEGER, codePdt TEXT, nc TEXT, nomClt TEXT)");
    //reunion
    batch.execute(
        "CREATE TABLE ${DBTable.reunion_informer}(id INTEGER PRIMARY KEY AUTOINCREMENT, nReunion INTEGER, typeReunion TEXT, datePrev TEXT, heureDeb TEXT, lieu TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.reunion_planifier}(id INTEGER PRIMARY KEY AUTOINCREMENT, nReunion INTEGER, typeReunion TEXT, datePrev TEXT, ordreJour TEXT, heureDeb TEXT, heureFin TEXT, lieu TEXT)");
    //incident environnement
    batch.execute(
        "CREATE TABLE ${DBTable.incident_env_decision_traitement}(id INTEGER PRIMARY KEY AUTOINCREMENT, nIncident INTEGER, incident TEXT, dateDetect TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_env_a_traiter}(id INTEGER PRIMARY KEY AUTOINCREMENT, nIncident INTEGER, incident TEXT, dateDetect TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_env_a_cloturer}(id INTEGER PRIMARY KEY AUTOINCREMENT, nIncident INTEGER, incident TEXT, dateDetect TEXT)");
    //incident securite
    batch.execute(
        "CREATE TABLE ${DBTable.incident_securite_decision_traitement}(id INTEGER PRIMARY KEY AUTOINCREMENT, ref INTEGER, designation TEXT, dateInc TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_securite_a_traiter}(id INTEGER PRIMARY KEY AUTOINCREMENT, ref INTEGER, designation TEXT, dateInc TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.incident_securite_a_cloturer}(id INTEGER PRIMARY KEY AUTOINCREMENT, ref INTEGER, designation TEXT, dateInc TEXT)");
    //audit
    batch.execute(
        "CREATE TABLE ${DBTable.audit_audite}(id INTEGER PRIMARY KEY AUTOINCREMENT, idAudit INTEGER, refAudit TEXT, dateDebPrev TEXT, champ TEXT, interne TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.audit_auditeur}(id INTEGER PRIMARY KEY AUTOINCREMENT, idAudit INTEGER, refAudit TEXT, dateDebPrev TEXT, champ TEXT, interne TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.rapport_audit_valider}(id INTEGER PRIMARY KEY AUTOINCREMENT, idAudit INTEGER, refAudit TEXT, champ TEXT, interne TEXT, typeA TEXT)");

    batch.execute(
        "CREATE TABLE ${DBTable.task}(idTask INTEGER PRIMARY KEY AUTOINCREMENT, _id TEXT, fullName TEXT, email TEXT, job TEXT, createdAt TEXT)");
    batch.execute(
        "CREATE TABLE ${DBTable.task_sync}(id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, email TEXT, job TEXT)");
    await batch.commit();
  }

  _onUpgradingDatabase(
      Database database, int oldVersion, int newVersion) async {
    print("upgrade database and table");
    //await database.execute("ALTER TABLE site ADD COLUMN color TEXT");
  }

  deletingDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, DBTable.DB_Name);
    await deleteDatabase(path);
  }

  Future close() async {
    Database? mydb = await db;
    await mydb!.close();
  }

  //Task
  readTask(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTask(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  insertTaskStatic(String table) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, {
      "_id": "62372e9133f1f697707fb458",
      "fullName": "test",
      "email": "test@hotmail.com",
      "job": "Full Stack Developer",
      "createdAt": "2022-03-20T13:39:29.763Z"
    });
    print('data insert');
    return response;
  }

  deleteTask(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  // Delete all tasks
  Future<int> deleteAllTasks() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.task}');

    return res;
  }

  //Task Async
  readTaskSync(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTaskSync(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllTaskSync() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.task_sync}');

    return res;
  }

  //--------------------------------------------------Licence-----------------------------------------------
  readLicenceInfo(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    debugPrint('licence info : ${response.first}');
    return response.first;
  }

  getLicenceInfo() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT * FROM ${DBTable.licence_info}");
    debugPrint('licence info : ${response.first}');
    return response.first;
  }

  insertLicenceInfo(String table, data) async {
    //await deleteAllTasks();
    print('data licence : $data');
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableLicenceInfo() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.licence_info}');
    return res;
  }

  //begin licence
  getBeginLicence() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT * FROM ${DBTable.mobile_licence}");
    debugPrint('mobile licence : ${response.first}');
    return response.first;
  }

  insertBeginLicence(String table, data) async {
    //await deleteAllTasks();
    debugPrint('data begin licence : $data');
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableBeginLicence() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.mobile_licence}');
    return res;
  }

  //Licence device
  isLicenceEnd(licence_id) async {
    Database? mydb = await db;
    /* var response = await mydb!.rawQuery(
        ''' if (select LicenseEnd from ${DBTable.mobile_licence} where DeviceId = '$licence_id') >= DATE() '''
        ''' select 0  as retour  '''
        ''' else select 1  as retour  '''
    );
    var response = await mydb!.rawQuery(
        ''' select case when 2022-11-02 >= DATE() then 0 else 1 end retour from ${DBTable.mobile_licence} where DeviceId = '$licence_id' '''
    ); */
    var response = await mydb!.rawQuery(
        ''' select case when JULIANDAY(LicenseEnd) - JULIANDAY(DATE()) >= 0 then 0 else 1 end retour from ${DBTable.mobile_licence} where DeviceId = '$licence_id' ''');
    debugPrint('is licence end : ${response.first}');
    return response.first;
  }

  //------------------------------------------------User login------------------------------------------------
  readUser(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertUser(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableUser() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.user}');
    return res;
  }

  //------------------------------------------------Domaine Affectation------------------------------------------------
  readDomaineAffectation(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readDomaineAffectationByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.domaine_affectation} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertDomaineAffectation(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableDomaineAffectation() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.domaine_affectation}');
    return res;
  }

  //------------------------------------------------Champ Cache------------------------------------------------
  readChampCache(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readChampCacheByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.champ_cache} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertChampCache(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampCache() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.champ_cache}');
    return res;
  }

  //------------------------------------------------Champ Obligatoire Action------------------------------------------------
  readChampObligatoireAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertChampObligatoireAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampObligatoireAction() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.champ_obligatoire_action}');
    return res;
  }

  //------------------------------------------------Site------------------------------------------------
  readSite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readSiteByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.site} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertSite(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllSite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.site}');
    return res;
  }

  //------------------------------------------------Processus------------------------------------------------
  readProcessus(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readProcessusByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.processus} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertProcessus(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllProcessus() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.processus}');
    return res;
  }

  //processus employe
  readProcessusByEmploye(mat) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.processus_employe} WHERE mat = '$mat'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertProcessusEmploye(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableProcessusEmploye() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.processus_employe}');
    return res;
  }

  //------------------------------------------------Product------------------------------------------------
  readProduct(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertProduct(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllProduct() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.product}');
    return res;
  }

  //------------------------------------------------Responsable cloture------------------------------------------------
  readResponsableCloture(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readResponsableClotureParams(codeSite, codeProcessus) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.resp_cloture} WHERE codeSite = '$codeSite' AND codeProcessus = '$codeProcessus'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertResponsableCloture(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllResponsableCloture() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.resp_cloture}');
    return res;
  }

  //------------------------------------------------Direction------------------------------------------------
  readDirection(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readDirectionByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.direction} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertDirection(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllDirection() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.direction}');
    return res;
  }

  //------------------------------------------------Employe------------------------------------------------
  readEmploye(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertEmploye(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllEmploye() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.employe}');
    return res;
  }

  //------------------------------------------------Activity------------------------------------------------
  readActivity(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readActivityByModule(module, fiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.activity} WHERE module = '$module' AND fiche = '$fiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertActivity(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllActivity() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.activity}');
    return res;
  }

  //------------------------------------------------Service------------------------------------------------
  readService(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readServiceByModuleAndDirection(module, fiche, codeDirection) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.service} WHERE module = '$module' AND fiche = '$fiche' AND codeDirection = '$codeDirection'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readServiceByCodeDirection(codeDirection) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.service} WHERE codeDirection = '$codeDirection'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertService(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllService() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.service}');
    return res;
  }

  //------------------------------------------------Priorite------------------------------------------------
  readPriorite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPriorite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllPriorite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.priorite}');
    return res;
  }

  //------------------------------------------------Gravite------------------------------------------------
  readGravite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertGravite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllGravite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.gravite}');
    return res;
  }

  //----------------------------------------------------Module Action --------------------------------------------------------------------
  //source Action
  readSourceAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSourceAction(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllSourceAction() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.source_action}');
    return res;
  }

  //type Action
  readTypeAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeAction(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllTypeAction() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.type_action}');
    return res;
  }

  //type cause Action
  readTypeCauseAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCauseActionOffline() async {
    Database? mydb = await db;
    var response = mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_cause_action} WHERE online = '0'");
    debugPrint('TypeCauseAction sync : $response');
    return response;
  }

  readTypeCauseActionById(nAct) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_cause_action} WHERE nAct = '$nAct'");
    debugPrint('type cause action : $response');
    return response;
  }

  insertTypeCauseAction(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseAction() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.type_cause_action}');
    return res;
  }

  getMaxNumTypeCauseAction() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idTypeCause), 0) FROM ${DBTable.type_cause_action}");
    debugPrint('response max id TypeCauseAction ${response.last.values.first}');
    return response.last.values.first;
  }

  //type cause Action a rattacher
  readTypeCauseActionARattacher(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCauseActionARattacherById(int? nAct) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT tcr.codetypecause, tcr.typecause FROM ${DBTable.type_cause_action_a_rattacher} tcr '''
        ''' LEFT OUTER JOIN ${DBTable.type_cause_action} tc ON tcr.codetypecause = tc.codetypecause AND nAct = '$nAct' '''
        ''' WHERE tc.codetypecause IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('type cause action a rattacher : $response');
    return response;
  }

  insertTypeCauseActionARattacher(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseActionARattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_cause_action_a_rattacher}');
    return res;
  }

  //Audit Action
  readAuditAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertAuditAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllAuditAction() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.audit_action}');
    return res;
  }

//Action
  readAction2(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readAction() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.action} ORDER BY nAct DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  searchAction(nAction, act, type) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action} WHERE nAct LIKE '%$nAction%' AND act LIKE '%$act%' AND typeAct LIKE '%$type%' ORDER BY nAct DESC");
    print(response);
    return response;
  }

  readNActionMax() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT MAX(nAct*online) FROM ${DBTable.action}");
    print('response nact max ${response.last.values.first}');
    return response.last.values.first;
  }

  getMaxNumAction() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT IFNULL( MAX(nAct), 0) FROM ${DBTable.action}");
    print('response nact max ${response.last.values.first}');
    return response.last.values.first;
  }

  /*
  Future<int> readNActionMax() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery("SELECT MAX(nAct*online) FROM ${DBTable.action}");
    print('response nact max jihene ${response.last.values.first}');
    return int.parse(response.last.values.first.toString());
  }
   */
  insertAction(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllAction() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.action}');
    return res;
  }

  updateAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!
        .update(table, data, where: 'nAct=?', whereArgs: [data['nAct']]);
    return response;
  }

  deleteAction(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  readActionById(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'nAct=?', whereArgs: [itemId]);
    return response;
  }

  getCountAction() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.action}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //Action Sync
  readActionSync() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.action_sync} ORDER BY id ASC");
    debugPrint('response action async : $response');
    return response;
  }

  readActionSync2(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readIdActionSyncMax() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT IFNULL( MAX(id), 0) FROM ${DBTable.action_sync}");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    //print('max action sync : ${response.last.values.first}');
    return response.last.values.first;
  }

  insertActionSync(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllActionSync() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.action_sync}');

    return res;
  }

  getCountActionSync() async {
    //database connection
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.action_sync}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //sous Action
  readSousAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readSousActionByNumAction(numAction) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.sous_action} WHERE nAct = '$numAction'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readSousActionByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.sous_action} WHERE online = '0' ORDER BY id ASC");
    //var response = await mydb!.rawQuery("SELECT * FROM ${DBTable.sous_action} WHERE online = '0' ORDER BY nSousAct DESC");
    debugPrint('sous action sync : $response');
    return response;
  }

  getCountSousActionOffline() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        "SELECT COUNT (*) from ${DBTable.sous_action} WHERE online = '0'");
    //var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.sous_action}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<int> deleteSousActionOffline() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete("DELETE FROM ${DBTable.sous_action} WHERE online = '0'");
    return res;
  }

  getMaxNumSousAction(numAction) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(nSousAct), 0) FROM ${DBTable.sous_action} WHERE nAct = '$numAction'");
    print('max sous action : ${response.last.values.first}');
    return response.last.values.first;
  }

  insertSousAction(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllSousAction() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.sous_action}');
    return res;
  }

  //-------------------------------Module PNC-------------------------------------------------------
  //------------------------------------------------Champ Obligatoire PNC------------------------------------------------
  readChampObligatoirePNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertChampObligatoirePNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampObligatoirePNC() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.champ_obligatoire_pnc}');
    return res;
  }

//------------------------------------------------Fournisseur------------------------------------------------
  readFournisseur(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertFournisseur(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableFournisseur() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.fournisseur}');
    return res;
  }

  //------------------------------------------------Client------------------------------------------------
  readClient(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertClient(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableClient() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.client}');
    return res;
  }

  //------------------------------------------------TypePNC------------------------------------------------
  readTypePNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypePNC(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypePNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.type_pnc}');
    return res;
  }

  //------------------------------------------------Gravite PNC------------------------------------------------
  readGravitePNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertGravitePNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableGravitePNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.gravite_pnc}');
    return res;
  }

  //------------------------------------------------Source PNC------------------------------------------------
  readSourcePNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSourcePNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSourcePNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.source_pnc}');
    return res;
  }

  //------------------------------------------------Atelier PNC------------------------------------------------
  readAtelierPNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertAtelierPNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAtelierPNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.atelier_pnc}');
    return res;
  }

  //------------------------------------------------products PNC------------------------------------------------
  readProductPNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readProductByNNC(int? nnc) async {
    Database? mydb = await db;
    var response = mydb!
        .rawQuery("SELECT * FROM ${DBTable.product_pnc} WHERE nnc = '$nnc'");
    return response;
  }

  readProductPNCByOnline() async {
    Database? mydb = await db;
    var response = mydb!
        .rawQuery("SELECT * FROM ${DBTable.product_pnc} WHERE online = '0'");
    debugPrint('product of pnc sync : $response');
    return response;
  }

  insertProductPNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  getMaxNumProductPNC() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idNCProduct), 0) FROM ${DBTable.product_pnc}");
    print('response idNCProduct max ${response.last.values.first}');
    return response.last.values.first;
  }

  Future<int> deleteTableProductPNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.product_pnc}');
    return res;
  }

  //------------------------------------------------type cause PNC------------------------------------------------
  readTypeCausePNC(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCauseByNNC(int? nnc) async {
    Database? mydb = await db;
    var response = mydb!
        .rawQuery("SELECT * FROM ${DBTable.type_cause_pnc} WHERE nnc = '$nnc'");
    return response;
  }

  readTypeCauseByOnline() async {
    Database? mydb = await db;
    var response = mydb!
        .rawQuery("SELECT * FROM ${DBTable.type_cause_pnc} WHERE online = '0'");
    debugPrint('type cause pnc : $response');
    return response;
  }

  insertTypeCausePNC(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCausePNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.type_cause_pnc}');
    return res;
  }

  getMaxNumTypeCausePNC() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idTypeCause), 0) FROM ${DBTable.type_cause_pnc}");
    print('response idTypeCause max ${response.last.values.first}');
    return response.last.values.first;
  }

  //type cause a rattacher
  readAllTypeCausePNCARattacher(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCausePNCARattacher(int? nnc) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT ${DBTable.type_cause_a_rattacher_pnc}.codetypecause, ${DBTable.type_cause_a_rattacher_pnc}.typecause FROM ${DBTable.type_cause_a_rattacher_pnc} '''
        ''' LEFT OUTER JOIN ${DBTable.type_cause_pnc} ON ${DBTable.type_cause_a_rattacher_pnc}.codetypecause = ${DBTable.type_cause_pnc}.codetypecause AND nnc = '$nnc' '''
        ''' WHERE ${DBTable.type_cause_pnc}.codetypecause IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertTypeCausePNCARattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCausePNCARattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_cause_a_rattacher_pnc}');
    return res;
  }

  //----------------------------------------PNC---------------------------------------------
  readPNC() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT * FROM ${DBTable.pnc} ORDER BY nnc DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readPNCByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.pnc} WHERE online = '0' ORDER BY nnc ASC");
    debugPrint('pnc sync : $response');
    return response;
  }

  readPNCOnline(table) async {
    Database? mydb = await db;
    var response = await mydb!.query(table, where: 'online=?', whereArgs: [0]);
    return response;
  }

  Future<int> deletePNCOffline() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete("DELETE FROM ${DBTable.pnc} WHERE online = '0'");
    return res;
  }

  getMaxNumPNC() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT IFNULL( MAX(nnc), 0) FROM ${DBTable.pnc}");
    print('response nact max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertPNC(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNC() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc}');
    return res;
  }

  readPNCByNNC(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'nnc=?', whereArgs: [itemId]);
    return response;
  }

  getCountPNC() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  ///--------------------------------------------Module Reunion-----------------------------------------
  //------------------------------------------------TypeReunion------------------------------------------------
  readTypeReunion(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeReunion(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeReunion() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.type_reunion}');
    return res;
  }

  //----------------------------------------Reunion------------------------------------------------
  readReunion() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.reunion} ORDER BY nReunion DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readReunionByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.reunion} WHERE online = '0' ORDER BY id ASC");
    debugPrint('reunion sync : $response');
    return response;
  }

  Future<int> deleteReunionOffline() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete("DELETE FROM ${DBTable.reunion} WHERE online = '0'");
    return res;
  }

  getMaxNumReunion() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT IFNULL( MAX(nReunion), 0) FROM ${DBTable.reunion}");
    print('response num reunion max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertReunion(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableReunion() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.reunion}');
    return res;
  }

  readReunionByNumero(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'nReunion=?', whereArgs: [itemId]);
    return response;
  }

  getCountReunion() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.reunion}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //participant of reunion
  readParticipantByReunion(int? nReunion) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.participant_reunion} WHERE nReunion = $nReunion");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readParticipantReunionByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.participant_reunion} WHERE online = '0'");
    debugPrint('participants reunion sync : $response');
    return response;
  }

  insertParticipantReunion(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableParticipantReunion() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.participant_reunion}');
    return res;
  }

  readEmployeParticipantReunion(int? nReunion) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT ${DBTable.employe}.mat, ${DBTable.employe}.nompre FROM ${DBTable.employe} '''
        ''' LEFT OUTER JOIN ${DBTable.participant_reunion} ON ${DBTable.employe}.mat = ${DBTable.participant_reunion}.mat AND nReunion=$nReunion '''
        ''' WHERE ${DBTable.participant_reunion}.mat IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  //decision (action) reunion
  readActionReunion(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readActionReunionOffline() async {
    Database? mydb = await db;
    var response = mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_reunion_rattacher} WHERE online = '0'");
    debugPrint('action reunion sync : $response');
    return response;
  }

  readActionReunionBynReunion(nReunion) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_reunion_rattacher} WHERE nReunion = '$nReunion'");
    debugPrint('action reunion : $response');
    return response;
  }

  insertActionReunion(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableActionReunion() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.action_reunion_rattacher}');
    return res;
  }

  readActionReunionARattacher(nReunion) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.nAct, TC.act FROM ${DBTable.action} TC '''
        ''' LEFT OUTER JOIN ${DBTable.action_reunion_rattacher} TCR ON TC.nAct = TCR.nAct AND nReunion=$nReunion '''
        ''' WHERE TCR.nAct IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response ActionReunionARattacher : $response');
    return response;
  }

  //------------------------------------------Module Documentation----------------------------------
  //----------------------------------------documentation------------------------------------------------
  readDocumentation() async {
    Database? mydb = await db;
    var response =
        await mydb!.rawQuery("SELECT * FROM ${DBTable.documentation}");
    print(response);
    return response;
  }

  searchDocumentation(code, libelle, type) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.documentation} WHERE cdi LIKE '%$code%' AND libelle LIKE '%$libelle%' AND typeDI LIKE '%$type%' ");
    print(response);
    return response;
  }

  readDocumentationByOnline() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.documentation} WHERE online = '0'");
    print(response);
    return response;
  }

  insertDocumentation(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableDocumentation() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.documentation}');
    return res;
  }

  readDocumentationByCode(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'cdi=?', whereArgs: [itemId]);
    return response;
  }

  getCountDocumentation() async {
    //database connection
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.documentation}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //------------------------------------------------type document------------------------------------------------
  readTypeDocument(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeDocument(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeDocument() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.type_document}');
    return res;
  }

  //------------------------------------------Module Incident Environnement----------------------------------
  //----------------------------------------Incident Environnement------------------------------------------------
  readIncidentEnvironnement() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.incident_environnement} ORDER BY n DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  searchIncidentEnvironnement(numero, type, designation) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.incident_environnement} WHERE n LIKE '%$numero%' AND type LIKE '%$type%' AND incident LIKE '%$designation%' ORDER BY n DESC");
    print(response);
    return response;
  }

  readIncidentEnvironnementByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.incident_environnement} WHERE online = '0' ORDER BY id ASC");
    debugPrint('incident environnement sync : $response');
    return response;
  }

  Future<int> deleteIncidentEnvironnementOffline() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        "DELETE FROM ${DBTable.incident_environnement} WHERE online = '0'");
    return res;
  }

  getMaxNumIncidentEnvironnement() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(n), 0) FROM ${DBTable.incident_environnement}");
    print('response num incident max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertIncidentEnvironnement(String table, data) async {
    //await deleteAllTasks();
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentEnvironnement() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.incident_environnement}');
    return res;
  }

  readIncidentEnvironnementByNumero(table, itemId) async {
    Database? mydb = await db;
    var response = await mydb!.query(table, where: 'n=?', whereArgs: [itemId]);
    return response;
  }

  getCountIncidentEnvironnement() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.incident_environnement}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //------------------------------------------------Champ Obligatoire Incident Env------------------------------------------------
  readChampObligatoireIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertChampObligatoireIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampObligatoireIncidentEnv() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.champ_obligatoire_incident_env}');
    return res;
  }

  //------------------------------------------------Type Cause------------------------------------------------
  readTypeCauseIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCauseIncidentEnvARattacher(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.idTypeCause, TC.typeCause FROM ${DBTable.type_cause_incident_env} TC '''
        ''' LEFT OUTER JOIN ${DBTable.type_cause_incident_env_rattacher} TCR ON TC.idTypeCause = TCR.idTypeCause AND incident=$incident '''
        ''' WHERE TCR.idTypeCause IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertTypeCauseIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.type_cause_incident_env}');
    return res;
  }

  //type cause inc env rattacher
  readTypeCauseIncidentEnvRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_cause_incident_env_rattacher} WHERE online = '0'");
    debugPrint('type cause inc env sync : $response');
    return response;
  }

  readTypeCauseRattacherEnvByIncident(table, incident) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  insertTypeCauseRattacherIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseIncidentEnvRattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_cause_incident_env_rattacher}');
    return res;
  }

  getMaxNumTypeCauseIncidentEnvironnementRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncidentCause), 0) FROM ${DBTable.type_cause_incident_env_rattacher}");
    debugPrint('response idIncidentCause max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------Category------------------------------------------------
  readCategoryIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCategoryIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCategoryIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.category_incident_env}');
    return res;
  }

  //------------------------------------------------Type Consequence------------------------------------------------
  readTypeConsequenceIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeConsequenceIncidentEnvARattacher(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.idTypeConseq, TC.typeConseq FROM ${DBTable.type_consequence_incident_env} TC '''
        ''' LEFT OUTER JOIN ${DBTable.type_consequence_incident_env_rattacher} TCR ON TC.idTypeConseq = TCR.idTypeConseq AND incident=$incident '''
        ''' WHERE TCR.idTypeConseq IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertTypeConsequenceIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeConsequenceIncidentEnv() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_consequence_incident_env}');
    return res;
  }

  //type Consequence inc env rattacher
  readTypeConsequenceIncidentEnvRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_consequence_incident_env_rattacher} WHERE online = '0'");
    debugPrint('type consequence inc env sync : $response');
    return response;
  }

  readTypeConsequenceRattacherEnvByIncident(table, incident) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  insertTypeConsequenceRattacherIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeConsequenceIncidentEnvRattacher() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.type_consequence_incident_env_rattacher}');
    return res;
  }

  getMaxNumTypeConsequenceIncidentEnvironnementRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncidentConseq), 0) FROM ${DBTable.type_consequence_incident_env_rattacher}");
    debugPrint('response idIncidentConseq max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------Type inc------------------------------------------------
  readTypeIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.type_incident_env}');
    return res;
  }

  //------------------------------------------------lieu inc------------------------------------------------
  readLieuIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertLieuIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableLieuIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.lieu_incident_env}');
    return res;
  }

  //------------------------------------------------source incident------------------------------------------------
  readSourceIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSourceIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSourceIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.source_incident_env}');
    return res;
  }

  //------------------------------------------------cout estime incident env------------------------------------------------
  readCoutEstimeIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCoutEstimeIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCoutEstimeIncidentEnv() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.cout_estime_incident_env}');
    return res;
  }

  //------------------------------------------------gravite inc env------------------------------------------------
  readGraviteIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertGraviteIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableGraviteIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.gravite_incident_env}');
    return res;
  }

  //------------------------------------------------secteur inc------------------------------------------------
  readSecteurIncidentEnv(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSecteurIncidentEnv(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSecteurIncidentEnv() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.secteur_incident_env}');
    return res;
  }

  //action rattacher inc env
  readActionIncEnvRattacherByidFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_inc_env_rattacher} WHERE idFiche = '$idFiche'");
    debugPrint('response : $response');
    return response;
  }

  readActionIncEnvRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_inc_env_rattacher} WHERE online = '0'");
    debugPrint('action vs offline : $response');
    return response;
  }

  insertActionIncEnvRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableActionIncEnvRattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.action_inc_env_rattacher}');
    return res;
  }

  readActionIncEnvARattacher(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.nAct, TC.act FROM ${DBTable.action} TC '''
        ''' LEFT OUTER JOIN ${DBTable.action_inc_env_rattacher} TCR ON TC.nAct = TCR.nAct AND idFiche=$idFiche '''
        ''' WHERE TCR.nAct IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response ActionIncEnvARattacher : $response');
    return response;
  }

  //------------------------------------------Module Incident Securite----------------------------------
  //----------------------------------------Incident Securite------------------------------------------------
  readIncidentSecurite() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.incident_securite} ORDER BY ref DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  searchIncidentSecurite(numero, designation, type) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.incident_securite} WHERE ref LIKE '%$numero%' AND designation LIKE '%$designation%' AND typeIncident LIKE '%$type%' ORDER BY ref DESC");
    print(response);
    return response;
  }

  readIncidentSecuriteByOnline() async {
    Database? mydb = await db;
    //var response = await mydb!.rawQuery("SELECT * FROM ${DBTable.incident_securite} WHERE online = '0' ORDER BY id ASC");
    var response = await mydb!.rawQuery(
        ''' SELECT ref, online, dateInc, heure, codeType, codePoste, codeGravite, codeCategory, '''
        ''' descriptionIncident, descriptionCause, designation, descriptionConsequence, nombreJour, actionImmediate, codeSite, '''
        ''' codeSecteur, codeProcessus, codeActivity, codeDirection, codeService, detectedEmployeMatricule, numInterne, isps, '''
        ''' codeCoutEsteme, dateCreation, week, codeEvenementDeclencheur, listTypeCause, listTypeConsequence, listCauseTypique, listSiteLesion '''
        '''FROM ${DBTable.incident_securite} WHERE online = '0' ORDER BY id ASC ''');

    debugPrint('incident securite sync: $response');
    return response;
  }

  getMaxNumIncidentSecurite() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(ref), 0) FROM ${DBTable.incident_securite}");
    print('response num incident max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.incident_securite}');
    return res;
  }

  readIncidentSecuriteByNumero(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'ref=?', whereArgs: [itemId]);
    return response;
  }

  getCountIncidentSecurite() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.incident_securite}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //------------------------------------------------Champ Obligatoire Incident securite------------------------------------------------
  readChampObligatoireIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertChampObligatoireIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampObligatoireIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.champ_obligatoire_incident_securite}');
    return res;
  }

  //------------------------------------------------poste travail------------------------------------------------
  readPosteTravail(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPosteTravail(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePosteTravail() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.poste_travail}');
    return res;
  }

  //------------------------------------------------type------------------------------------------------
  readTypeIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeIncidentSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.type_incident_securite}');
    return res;
  }

  //------------------------------------------------category------------------------------------------------
  readCategoryIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCategoryIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCategoryIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.category_incident_securite}');
    return res;
  }

  //------------------------------------------------type cause incident securite------------------------------------------------
  readTypeCauseIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeCauseIncSecARattacher(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.idTypeCause, TC.typeCause FROM ${DBTable.type_cause_incident_securite} TC '''
        ''' LEFT OUTER JOIN ${DBTable.type_cause_incident_securite_rattacher} TCR ON TC.idTypeCause = TCR.idTypeCause AND incident=$incident '''
        ''' WHERE TCR.idTypeCause IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertTypeCauseIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_cause_incident_securite}');
    return res;
  }

  //type cause inc env rattacher
  readTypeCauseIncidentSecRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_cause_incident_securite_rattacher} WHERE online = '0'");
    debugPrint('type cause inc Sec sync : $response');
    return response;
  }

  readTypeCauseIncSecRattacher(table, incident) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  insertTypeCauseIncSecRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeCauseIncSecRattacher() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.type_cause_incident_securite_rattacher}');
    return res;
  }

  getMaxNumTypeCauseIncSecRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncidentCause), 0) FROM ${DBTable.type_cause_incident_securite_rattacher}");
    debugPrint('response idIncidentCause max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------type consequence incident securite------------------------------------------------
  readTypeConsequenceIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readTypeConsequenceIncSecARattacher(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.idTypeConseq, TC.typeConseq FROM ${DBTable.type_consequence_incident_securite} TC '''
        ''' LEFT OUTER JOIN ${DBTable.type_consequence_incident_securite_rattacher} TCR ON TC.idTypeConseq = TCR.idTypeConseq AND incident=$incident '''
        ''' WHERE TCR.idTypeConseq IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertTypeConsequenceIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeConsequenceIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.type_consequence_incident_securite}');
    return res;
  }

  //type Consequence inc sec rattacher
  readTypeConsequenceIncSecRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.type_consequence_incident_securite_rattacher} WHERE online = '0'");
    debugPrint('type consequence inc sec sync : $response');
    return response;
  }

  readTypeConsequenceIncSecRattacher(table, incident) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  insertTypeConsequenceIncSecRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeConsequenceIncSecRattacher() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.type_consequence_incident_securite_rattacher}');
    return res;
  }

  getMaxNumTypeConsequenceIncSecRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncidentConseq), 0) FROM ${DBTable.type_consequence_incident_securite_rattacher}");
    debugPrint('response idIncidentConseq max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------cause typique------------------------------------------------
  readCauseTypiqueIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readCauseTypiqueIncSecARattacherByIncident(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.idCauseTypique, TC.causeTypique FROM ${DBTable.cause_typique_incident_securite} TC '''
        ''' LEFT OUTER JOIN ${DBTable.cause_typique_incident_securite_rattacher} TCR ON TC.idCauseTypique = TCR.idCauseTypique AND incident=$incident '''
        ''' WHERE TCR.idCauseTypique IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertCauseTypiqueIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCauseTypiqueIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.cause_typique_incident_securite}');
    return res;
  }

  //cause typique  inc env rattacher
  readCauseTypiqueIncSecRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.cause_typique_incident_securite_rattacher} WHERE online = '0'");
    debugPrint(' cause typique inc Sec sync : $response');
    return response;
  }

  readCauseTypiqueIncSecRattacher(table, incident) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  insertCauseTypiqueIncSecRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCauseTypiqueIncSecRattacher() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.cause_typique_incident_securite_rattacher}');
    return res;
  }

  getMaxNumCauseTypiqueIncSecRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncidentCauseTypique), 0) FROM ${DBTable.cause_typique_incident_securite_rattacher}");
    debugPrint('response idIncidentCause max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------site lesion incident securite------------------------------------------------
  readSiteLesionIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readSiteLesionIncSecARattacherByIncident(incident) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.codeSiteLesion, TC.siteLesion FROM ${DBTable.site_lesion_incident_securite} TC '''
        ''' LEFT OUTER JOIN ${DBTable.site_lesion_incident_securite_rattacher} TCR ON TC.codeSiteLesion = TCR.codeSiteLesion AND incident=$incident '''
        ''' WHERE TCR.codeSiteLesion IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  insertSiteLesionIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSiteLesionIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.site_lesion_incident_securite}');
    return res;
  }

  //site lesion rattacher
  readSiteLesionIncSecRattacher(table, incident) async {
    Database? mydb = await db;
    final response =
        await mydb!.query(table, where: 'incident=?', whereArgs: [incident]);
    return response;
  }

  readSiteLesionIncSecRattacherByonline() async {
    Database? mydb = await db;
    final response = await mydb!.rawQuery(
        'SELECT * FROM ${DBTable.site_lesion_incident_securite_rattacher} WHERE online = 0 ');
    debugPrint('sync site lesion inc sec : $response');
    return response;
  }

  insertSiteLesionIncSecRattacher(table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSiteLesionIncSecRattacher() async {
    Database? mydb = await db;
    final response = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.site_lesion_incident_securite_rattacher}');
    return response;
  }

  getMaxNumSiteLesionIncSecRattacher() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idIncCodeSiteLesion), 0) FROM ${DBTable.site_lesion_incident_securite_rattacher}");
    debugPrint(
        'response idIncCodeSiteLesion max : ${response.last.values.first}');
    return response.last.values.first;
  }

  //------------------------------------------------gravite inc securite------------------------------------------------
  readGraviteIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertGraviteIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableGraviteIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.gravite_incident_securite}');
    return res;
  }

  //------------------------------------------------secteur incident securite------------------------------------------------
  readSecteurIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSecteurIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSecteurIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.secteur_incident_securite}');
    return res;
  }

  //------------------------------------------------cout estime incident securite------------------------------------------------
  readCoutEstimeIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCoutEstimeIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCoutEstimeIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.cout_estime_incident_securite}');
    return res;
  }

  //------------------------------------------------evenement declencheur inc securite------------------------------------------------
  readEvenementDeclencheurIncidentSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertEvenementDeclencheurIncidentSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableEvenementDeclencheurIncidentSecurite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.evenement_declencheur_incident_securite}');
    return res;
  }

  //action rattacher inc sec
  readActionIncSecRattacherByidFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_inc_sec_rattacher} WHERE idFiche = '$idFiche'");
    debugPrint('response : $response');
    return response;
  }

  readActionIncSecRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_inc_sec_rattacher} WHERE online = '0'");
    debugPrint('action inc sec offline : $response');
    return response;
  }

  insertActionIncSecRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableActionIncSecRattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.action_inc_sec_rattacher}');
    return res;
  }

  readActionIncSecARattacher(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.nAct, TC.act FROM ${DBTable.action} TC '''
        ''' LEFT OUTER JOIN ${DBTable.action_inc_sec_rattacher} TCR ON TC.nAct = TCR.nAct AND idFiche=$idFiche '''
        ''' WHERE TCR.nAct IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response ActionIncSecARattacher : $response');
    return response;
  }

  //-------------------------------------------------Module Visite Securite--------------------------------
  //----------------------------------------Visite Securite------------------------------------------------
  readVisiteSecurite() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.visite_securite} ORDER BY id DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  searchVisiteSecurite(numero, unite, zone) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.visite_securite} WHERE id LIKE '%$numero%' AND unite LIKE '%$unite%' AND zone LIKE '%$zone%' ORDER BY id DESC");
    print(response);
    return response;
  }

  readVisiteSecuriteByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.visite_securite} WHERE online = '0' ORDER BY id ASC");
    debugPrint('visite securite sync : $response');
    return response;
  }

  getMaxNumVisiteSecurite() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT IFNULL( MAX(id), 0) FROM ${DBTable.visite_securite}");
    print('response num visite sec max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertVisiteSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableVisiteSecurite() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.visite_securite}');
    return res;
  }

  readVisiteSecuriteById(table, itemId) async {
    Database? mydb = await db;
    var response = await mydb!.query(table, where: 'id=?', whereArgs: [itemId]);
    return response;
  }

  getCountVisiteSecurite() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.visite_securite}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //------------------------------------------------CheckList------------------------------------------------
  readCheckList(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCheckList(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCheckList() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.check_list}');
    return res;
  }

  //------------------------------------------------Unite------------------------------------------------
  readUniteVisiteSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertUniteVisiteSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableUniteVisiteSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.unite_visite_securite}');
    return res;
  }

//------------------------------------------------Zone------------------------------------------------
  readZoneVisiteSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readZoneByIdUnite(idUnite) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.zone_visite_securite} WHERE idUnite = '$idUnite'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  insertZoneVisiteSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableZoneVisiteSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.zone_visite_securite}');
    return res;
  }

  //------------------------------------------------Site Visite Securite------------------------------------------------
  readSiteVisiteSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSiteVisiteSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableSiteVisiteSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.site_visite_securite}');
    return res;
  }

  //------------------------------------------------Equipe------------------------------------------------
  readEmployeEquipeVisiteSecurite() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT ${DBTable.employe}.mat, ${DBTable.employe}.nompre FROM ${DBTable.employe} '''
        ''' LEFT OUTER JOIN ${DBTable.equipe_visite_securite} ON ${DBTable.employe}.mat = ${DBTable.equipe_visite_securite}.mat '''
        ''' WHERE ${DBTable.equipe_visite_securite}.mat IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response : $response');
    return response;
  }

  readEquipeVisiteSecurite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertEquipeVisiteSecurite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableEquipeVisiteSecurite() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.equipe_visite_securite}');
    return res;
  }

  Future<int> deleteEmployeOfEquipeVisiteSecurite(id) async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        "DELETE FROM ${DBTable.equipe_visite_securite} WHERE id = $id");
    return res;
  }

  //equipe in dblocal to synchronize
  readEquipeVisiteSecuriteEmploye(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readEquipeVisiteSecuriteEmployeById(idVisite) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT mat, affectation FROM ${DBTable.equipe_visite_securite_employe} WHERE id = '$idVisite'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('equipe visite securite sync : $response');
    return response;
  }

  insertEquipeVisiteSecuriteEmploye(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableEquipeVisiteSecuriteEmploye() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.equipe_visite_securite_employe}');
    return res;
  }

  //------------------------------------------------Equipe to save in offline------------------------------------------------
  readEmployeEquipeVisiteSecuriteOffline(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT ${DBTable.employe}.mat, ${DBTable.employe}.nompre FROM ${DBTable.employe} '''
        ''' LEFT OUTER JOIN ${DBTable.equipe_visite_securite_offline} ON ${DBTable.employe}.mat = ${DBTable.equipe_visite_securite_offline}.mat AND idFiche = '$idFiche' '''
        ''' WHERE ${DBTable.equipe_visite_securite_offline}.mat IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readEquipeVisiteSecuriteOffline(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readEquipeVisiteSecuriteOfflineByIdFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.equipe_visite_securite_offline} WHERE idFiche = '$idFiche'");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  readEquipeVisiteSecuriteOfflineByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.equipe_visite_securite_offline} WHERE online = '0'");
    print(response);
    return response;
  }

  insertEquipeVisiteSecuriteOffline(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableEquipeVisiteSecuriteOffline() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.equipe_visite_securite_offline}');
    return res;
  }

  //------------------------------------------------CheckList Rattacher VS------------------------------------------------
  readCheckListRattacher(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  readCheckListRattacherByidFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.check_list_vs_rattacher} WHERE idFiche = '$idFiche'");
    debugPrint('response : $response');
    return response;
  }

  readCheckListRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.check_list_vs_rattacher} WHERE online = '0'");
    debugPrint('checklist offline : $response');
    return response;
  }

  insertCheckListRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableCheckListRattacher() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.check_list_vs_rattacher}');
    return res;
  }

  updateCheckListRattacher(String table, data) async {
    Database? mydb = await db;
    int response =
        await mydb!.update(table, data, where: 'id=?', whereArgs: [data['id']]);
    return response;
  }

  //taux checklist vs
  readTauxCheckListVSByidFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.taux_checklist_vs} WHERE id = '$idFiche'");
    debugPrint('taux checklist vs : ${response.first}');
    return response.first;
  }

  insertTauxCheckListVS(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTauxCheckListVS() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.taux_checklist_vs}');
    return res;
  }

  //action vs rattacher
  readActionVSRattacherByidFiche(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_visite_securite_rattacher} WHERE idFiche = '$idFiche'");
    debugPrint('response : $response');
    return response;
  }

  readActionVSRattacherByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.action_visite_securite_rattacher} WHERE online = '0'");
    debugPrint('action vs offline : $response');
    return response;
  }

  insertActionVSRattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableActionVSRattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.action_visite_securite_rattacher}');
    return res;
  }

  readActionVSARattacher(idFiche) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT TC.nAct, TC.act FROM ${DBTable.action} TC '''
        ''' LEFT OUTER JOIN ${DBTable.action_visite_securite_rattacher} TCR ON TC.nAct = TCR.nAct AND idFiche=$idFiche '''
        ''' WHERE TCR.nAct IS NULL ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    debugPrint('response ActionVSARattacher : $response');
    return response;
  }

  //-------------------------------------------------Module Audit--------------------------------
  //----------------------------------------Audit------------------------------------------------
  readAudit() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.audit} ORDER BY idAudit DESC");
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print(response);
    return response;
  }

  searchAudit(numero, etat, type) async {
    Database? mydb = await db;
    //print("SELECT * FROM ${DBTable.audit} WHERE idAudit LIKE '%$numero%' AND etat LIKE '%$etat%' AND typeA LIKE '%$type%' ORDER BY idAudit DESC");
    var response;
    if (etat == 0) {
      response = await mydb!.rawQuery(
          "SELECT * FROM ${DBTable.audit} WHERE idAudit LIKE '%$numero%' AND typeA LIKE '%$type%' ORDER BY idAudit DESC");
    } else {
      response = await mydb!.rawQuery(
          "SELECT * FROM ${DBTable.audit} WHERE idAudit LIKE '%$numero%' AND etat LIKE '%$etat%' AND typeA LIKE '%$type%' ORDER BY idAudit DESC");
    }
    print(response);
    return response;
  }

  readAuditByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.audit} WHERE online = '0' ORDER BY id ASC");
    debugPrint('response audit by online : $response');
    return response;
  }

  readAuditByOnline2() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        ''' SELECT idAudit, refAudit, dateDebPrev, interne, cloture, '''
        ''' dateFinPrev, audit, objectif, codeTypeA, codeSite, idProcess, idDomaine, idDirection, idService, listCodeChamp '''
        ''' FROM ${DBTable.audit} '''
        ''' WHERE online = '0' ORDER BY id ASC, idAudit ASC ''');
    debugPrint('response audit by online : $response');
    return response;
  }

  getMaxNumAudit() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT IFNULL( MAX(idAudit), 0) FROM ${DBTable.audit}");
    print('response num audit max ${response.last.values.first}');
    return response.last.values.first;
  }

  insertAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAudit() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.audit}');
    return res;
  }

  readAuditById(table, itemId) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'idAudit=?', whereArgs: [itemId]);
    return response;
  }

  getCountAudit() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.audit}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //----------Constat---------------
  readConstatAuditByRefAudit(table, refAudit) async {
    Database? mydb = await db;
    var response =
        await mydb!.query(table, where: 'refAudit=?', whereArgs: [refAudit]);
    return response;
  }

  readConstatAuditByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.constat_audit} WHERE online = '0' ORDER BY idAudit ASC");
    if (kDebugMode) print('ConstatAudit DB local : $response');
    return response;
  }

  getMaxNumConstatAudit() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT IFNULL( MAX(idEcart), 0) FROM ${DBTable.constat_audit}");
    print('response idEcart max ${response.last.values.first}');
    //var maxIdResult = await mydb!.rawQuery("SELECT IFNULL( MAX(refAudit)+1, 0) as last_inserted_refAudit FROM ${DBTable.constat_audit}");
    //var id = maxIdResult.first["last_inserted_refAudit"];
    return response.last.values.first;
  }

  insertConstatAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableConstatAudit() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.constat_audit}');
    return res;
  }

  //------------------------------------------------gravite audit------------------------------------------------
  readGraviteAudit(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertGraviteAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableGraviteAudit() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.gravite_audit}');
    return res;
  }

  //------------------------------------------------type constat audit------------------------------------------------
  readTypeConstatAudit(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeConstatAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableTypeConstatAudit() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.type_constat_audit}');
    return res;
  }

  //------------------------------------------------champ audit------------------------------------------------
  readChampAudit(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertChampAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampAudit() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.champ_audit}');
    return res;
  }

  //------------------------------------------------champ audit of constat------------------------------------------------
  readChampAuditConstatByRefAudit(String table, refAudit) async {
    Database? mydb = await db;
    List<Map> response =
        await mydb!.query(table, where: 'refAudit=?', whereArgs: [refAudit]);
    return response;
  }

  readChampAuditOfConstat(refAudit) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.champ_audit_constat} WHERE refAudit = '$refAudit' ");
    print(response);
    return response;
  }

  insertChampAuditConstat(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableChampAuditConstat() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.champ_audit_constat}');
    return res;
  }

  //------------------------------------type audit---------------------------------------
  readTypeAudit(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeAudit(table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  deleteTableTypeAudit() async {
    Database? mydb = await db;
    final response = await mydb!.rawDelete('DELETE FROM ${DBTable.type_audit}');
    return response;
  }

  //auditeur interne
  readAuditeurInterne(refAudit) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.auditeur_interne} WHERE refAudit = '$refAudit' ");
    print(response);
    return response;
  }

  readAuditeurInterneByOnline() async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.auditeur_interne} WHERE online = '0' ");
    print(response);
    return response;
  }

  insertAuditeurInterne(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAuditeurInterne() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.auditeur_interne}');
    return res;
  }
  //auditeur interne a rattcher

  readAllAuditeurInterneARattacher() async {
    Database? mydb = await db;
    var response = await mydb!
        .rawQuery("SELECT * FROM ${DBTable.auditeur_interne_a_rattacher}");
    print(response);
    return response;
  }

  readAuditeurInterneARattacherByRefAudit(refAudit) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        "SELECT * FROM ${DBTable.auditeur_interne_a_rattacher} WHERE refAudit = '$refAudit' ");
    print('response auditeur interne of $refAudit : $response');
    return response;
  }

  readAuditeurInterneARattacher(refAudit) async {
    Database? mydb = await db;
    var response = await mydb!.rawQuery(
        '''SELECT DISTINCT AIR.mat, AIR.nompre FROM ${DBTable.auditeur_interne_a_rattacher} AIR '''
        ''' LEFT OUTER JOIN ${DBTable.auditeur_interne} AI ON AIR.mat = AI.mat  AND AI.refAudit= '$refAudit' '''
        ''' WHERE AI.mat IS NULL  ''');
    //var response = await mydb!.query(table, where: 'codeSite=?$codeSite');
    print('response auditeur interne of $refAudit : $response');
    return response;
  }

  insertAuditeurInterneARattacher(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAuditeurInterneARattacher() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.auditeur_interne_a_rattacher}');
    return res;
  }

  //-------------------------------------------Agenda------------------------------------------------------
  //action realisation
  readActionRealisation(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertActionRealisation(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllActionRealisation() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.action_realisation}');
    return res;
  }

  getCountActionRealisation() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.action_realisation}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //action suivi
  readActionSuivi(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertActionSuivi(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllActionSuivi() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.action_suivi}');
    return res;
  }

  getCountActionSuivi() async {
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.action_suivi}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //action suite a audit
  readActionSuiteAudit(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertActionSuiteAudit(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteAllActionSuiteAudit() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.action_suite_audit}');
    return res;
  }

  getCountActionSuiteAudit() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.action_suite_audit}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  ///PNC
  //pnc valider
  readPNCValider(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCValider(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCValider() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_valider}');
    return res;
  }

  getCountPNCValider() async {
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc_valider}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc a corriger
  readPNCACorriger(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCACorriger(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCACorriger() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_corriger}');
    return res;
  }

  getCountPNCACorriger() async {
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc_corriger}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc investigation effectuer
  readPNCInvestigationEffectuer(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCInvestigationEffectuer(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCInvestigationEffectuer() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.pnc_investigation_effectuer}');
    return res;
  }

  getCountPNCInvestigationEffectuer() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.pnc_investigation_effectuer}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc investigation approuver
  readPNCInvestigationApprouver(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCInvestigationApprouver(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCInvestigationApprouver() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.pnc_investigation_approuver}');
    return res;
  }

  getCountPNCInvestigationApprouver() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.pnc_investigation_approuver}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc decision
  readPNCDecision(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCDecision(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCDecision() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_decision}');
    return res;
  }

  getCountPNCDecision() async {
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc_decision}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc a traiter
  readPNCATraiter(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCATraiter(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCATraiter() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_traiter}');
    return res;
  }

  getCountPNCATraiter() async {
    Database? mydb = await db;
    var x =
        await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc_traiter}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc a suivre
  readPNCASuivre(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCASuivre(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCASuivre() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_suivre}');
    return res;
  }

  getCountPNCASuivre() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.pnc_suivre}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc approbation finale
  readPNCApprobationFinale(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCApprobationFinale(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCApprobationFinale() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_approbation_finale}');
    return res;
  }

  getCountPNCApprobationFinale() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.pnc_approbation_finale}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //pnc decision traitement a valider
  readPNCDecisionValidation(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertPNCDecisionValidation(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTablePNCDecisionValidation() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.pnc_decision_validation}');
    return res;
  }

  getCountPNCDecisionValidation() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.pnc_decision_validation}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //reunion
  //reunion informer
  readReunionInformer(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertReunionInformer(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableReunionInformer() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.reunion_informer}');
    return res;
  }

  getCountReunionInformer() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.reunion_informer}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //reunion planifier
  readReunionPlanifier(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertReunionPlanifier(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableReunionPlanifier() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.reunion_planifier}');
    return res;
  }

  getCountReunionPlanifier() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.reunion_planifier}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //Incident Environnement
  //Decision traitement
  readIncidentEnvDecisionTraitement(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentEnvDecisionTraitement(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentEnvDecisionTraitement() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.incident_env_decision_traitement}');
    return res;
  }

  getCountIncidentEnvDecisionTraitement() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.incident_env_decision_traitement}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //incident env a traiter
  readIncidentEnvATraiter(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentEnvATraiter(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentEnvATraiter() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.incident_env_a_traiter}');
    return res;
  }

  getCountIncidentEnvATraiter() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.incident_env_a_traiter}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //incident env a cloturer
  readIncidentEnvACloturer(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentEnvACloturer(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentEnvACloturer() async {
    Database? mydb = await db;
    final res =
        await mydb!.rawDelete('DELETE FROM ${DBTable.incident_env_a_cloturer}');
    return res;
  }

  getCountIncidentEnvACloturer() async {
    Database? mydb = await db;
    var x = await mydb!
        .rawQuery('SELECT COUNT (*) from ${DBTable.incident_env_a_cloturer}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //Incident Securite
  //Decision traitement
  readIncidentSecuriteDecisionTraitement(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentSecuriteDecisionTraitement(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentSecuriteDecisionTraitement() async {
    Database? mydb = await db;
    final res = await mydb!.rawDelete(
        'DELETE FROM ${DBTable.incident_securite_decision_traitement}');
    return res;
  }

  getCountIncidentSecuriteDecisionTraitement() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.incident_securite_decision_traitement}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //incident securite a traiter
  readIncidentSecuriteATraiter(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentSecuriteATraiter(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentSecuriteATraiter() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.incident_securite_a_traiter}');
    return res;
  }

  getCountIncidentSecuriteATraiter() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.incident_securite_a_traiter}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //incident Securite a cloturer
  readIncidentSecuriteACloturer(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertIncidentSecuriteACloturer(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableIncidentSecuriteACloturer() async {
    Database? mydb = await db;
    final res = await mydb!
        .rawDelete('DELETE FROM ${DBTable.incident_securite_a_cloturer}');
    return res;
  }

  getCountIncidentSecuriteACloturer() async {
    Database? mydb = await db;
    var x = await mydb!.rawQuery(
        'SELECT COUNT (*) from ${DBTable.incident_securite_a_cloturer}');
    int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //audit
  Future<List<dynamic>> readAuditAudite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertAuditAudite(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAuditAudite() async {
    Database? mydb = await db;
    final response =
        await mydb!.rawDelete('DELETE FROM ${DBTable.audit_audite}');
    return response;
  }

  Future<int?> getCountAuditAudite() async {
    Database? mydb = await db;
    var count =
        await mydb!.rawQuery('SELECT COUNT (*) FROM ${DBTable.audit_audite}');
    int? response = Sqflite.firstIntValue(count);
    return response;
  }

  Future<List<dynamic>> readAuditAuditeur(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertAuditAuditeur(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableAuditAuditeur() async {
    Database? mydb = await db;
    final response =
        await mydb!.rawDelete('DELETE FROM ${DBTable.audit_auditeur}');
    return response;
  }

  Future<int?> getCountAuditAuditeur() async {
    Database? mydb = await db;
    var count =
        await mydb!.rawQuery('SELECT COUNT (*) FROM ${DBTable.audit_auditeur}');
    int? response = Sqflite.firstIntValue(count);
    return response;
  }

  Future<List<dynamic>> readRapportAuditAValider(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertRapportAuditAValider(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteTableRapportAuditAValider() async {
    Database? mydb = await db;
    final response =
        await mydb!.rawDelete('DELETE FROM ${DBTable.rapport_audit_valider}');
    return response;
  }

  Future<int?> getCountRapportAuditAValider() async {
    Database? mydb = await db;
    var count = await mydb!
        .rawQuery('SELECT COUNT (*) FROM ${DBTable.rapport_audit_valider}');
    int? response = Sqflite.firstIntValue(count);
    return response;
  }
}
