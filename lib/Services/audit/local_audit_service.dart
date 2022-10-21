import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qualipro_flutter/Models/audit/champ_audit_model.dart';
import 'package:qualipro_flutter/Utils/Sqflite/db_helper.dart';

import '../../Models/audit/audit_model.dart';
import '../../Models/audit/auditeur_model.dart';
import '../../Models/audit/constat_audit_model.dart';
import '../../Models/audit/type_audit_model.dart';
import '../../Models/gravite_model.dart';
import '../../Utils/Sqflite/db_table.dart';
import '../../Utils/snack_bar.dart';

class LocalAuditService {

  DBHelper dbHelper = DBHelper();

  readAudit() async {
    return await dbHelper.readAudit();
  }
  searchAudit(numero, etat, type) async {
    return await dbHelper.searchAudit(numero, etat, type);
  }
   readAuditByOnline() async {
    try {
      return await dbHelper.readAuditByOnline();
    }
    catch (exception) {
      ShowSnackBar.snackBar("Error readAuditByOnline", exception.toString(), Colors.green);
      return Future.error('service audit : ${exception.toString()}');
    }
  }
  Future<List<AuditModel>> readListAuditByOnline() async {
    final response =  await dbHelper.readAuditByOnline();
    final List result = response;
    return result.map((
            (e) => AuditModel.fromDBLocal(e)
    )).toList();
  }
  getMaxNumAudit() async {
    return await dbHelper.getMaxNumAudit();
  }
  saveAudit(AuditModel model) async {
    return await dbHelper.insertAudit(DBTable.audit, model.dataMap());
  }
  saveAuditSync(AuditModel model) async {
    return await dbHelper.insertAudit(DBTable.audit, model.dataMapSync());
  }
  deleteTableAudit() async {
    await dbHelper.deleteTableAudit();
    print('delete Table Audit');
  }
  readAuditById(numero) async {
    return await dbHelper.readAuditById(DBTable.audit, numero);
  }
  getCountAudit() async {
    return await dbHelper.getCountAudit();
  }
  //constat
  readConstatAuditByRefAudit(refAudit) async {
    return await dbHelper.readConstatAuditByRefAudit(DBTable.constat_audit, refAudit);
  }
  readConstatAuditByOnline() async {
    return await dbHelper.readConstatAuditByOnline();
  }
  Future<List<ConstatAuditModel>> readListConstatAuditByOnline() async {
    final response =  await dbHelper.readConstatAuditByOnline();
    final List result = response;
    return result.map((
            (e) => ConstatAuditModel.fromDBLocal(e)
    )).toList();
  }
  getMaxNumConstatAudit() async {
    return await dbHelper.getMaxNumConstatAudit();
  }
  saveConstatAudit(ConstatAuditModel model) async {
    return await dbHelper.insertConstatAudit(DBTable.constat_audit, model.dataMap());
  }
  deleteTableConstatAudit() async {
    print('delete Table ConstatAudit');
   return await dbHelper.deleteTableConstatAudit();
  }
  //gravite
  readGraviteAudit() async {
    return await dbHelper.readGraviteAudit(DBTable.gravite_audit);
  }
  saveGraviteAudit(GraviteModel model) async {
    return await dbHelper.insertGraviteAudit(DBTable.gravite_audit, model.dataMap());
  }
  deleteTableGraviteAudit() async {
    await dbHelper.deleteTableGraviteAudit();
    print('delete table GraviteAudit');
  }
  //type constat
  readTypeConstatAudit() async {
    return await dbHelper.readTypeConstatAudit(DBTable.type_constat_audit);
  }
  saveTypeConstatAudit(TypeAuditModel model) async {
    return await dbHelper.insertTypeConstatAudit(DBTable.type_constat_audit, model.dataMap());
  }
  deleteTableTypeConstatAudit() async {
    await dbHelper.deleteTableTypeConstatAudit();
    print('delete table TypeConstatAudit');
  }
  //champ audit
  readChampAudit() async {
    return await dbHelper.readChampAudit(DBTable.champ_audit);
  }
  saveChampAudit(ChampAuditModel model) async {
    return await dbHelper.insertChampAudit(DBTable.champ_audit, model.dataMap());
  }
  deleteTableChampAudit() async {
    await dbHelper.deleteTableChampAudit();
    print('delete table ChampAudit');
  }
  //champ audit of constat
  readChampAuditConstatByRefAudit(refAudit) async {
    return await dbHelper.readChampAuditConstatByRefAudit(DBTable.champ_audit_constat, refAudit);
  }
  readChampAuditOfConstat(refAudit) async {
    return await dbHelper.readChampAuditOfConstat(refAudit);
  }
  saveChampAuditConstat(ChampAuditModel model) async {
    return await dbHelper.insertChampAuditConstat(DBTable.champ_audit_constat, model.dataMapConstat());
  }
  deleteTableChampAuditConstat() async {
    await dbHelper.deleteTableChampAuditConstat();
    print('delete table ChampAuditConstat');
  }
  //type audit
  readTypeAudit() async {
    return await dbHelper.readTypeAudit(DBTable.type_audit);
  }
  saveTypeAudit(TypeAuditModel model) async {
    return await dbHelper.insertTypeAudit(DBTable.type_audit, model.dataMap());
  }
  deleteTableTypeAudit() async {
    await dbHelper.deleteTableTypeAudit();
    print('delete table TypeAudit');
  }
  //auditeur interne
  readAuditeurInterne(refAudit) async {
    return await dbHelper.readAuditeurInterne(refAudit);
  }
  readAuditeurInterneByOnline() async {
    return await dbHelper.readAuditeurInterneByOnline();
  }
  Future<List<AuditeurModel>> readListAuditeurInterneByOnline() async {
    final response =  await dbHelper.readAuditeurInterneByOnline();
    final List result = response;
    return result.map((
            (e) => AuditeurModel.fromDBLocalAuditeurInterne(e)
    )).toList();
  }
  saveAuditeurInterne(AuditeurModel model) async {
    return await dbHelper.insertAuditeurInterne(DBTable.auditeur_interne, model.dataMapAuditeurInterne());
  }
  deleteTableAuditeurInterne() async {
    await dbHelper.deleteTableAuditeurInterne();
    print('delete table AuditeurInterne');
  }
  //auditeur interne a rattacher
  readAllAuditeurInterneARattacher() async {
    return await dbHelper.readAllAuditeurInterneARattacher();
  }
  readAuditeurInterneARattacher(refAudit) async {
    return await dbHelper.readAuditeurInterneARattacher(refAudit);
  }
  readAuditeurInterneARattacherByRefAudit(refAudit) async {
    return await dbHelper.readAuditeurInterneARattacherByRefAudit(refAudit);
  }
  saveAuditeurInterneARattacher(AuditeurModel model) async {
    return await dbHelper.insertAuditeurInterneARattacher(DBTable.auditeur_interne_a_rattacher, model.dataMapAuditeurInterneARattacher());
  }
  deleteTableAuditeurInterneARattacher() async {
    await dbHelper.deleteTableAuditeurInterneARattacher();
    print('delete table AuditeurInterneARattacher');
  }
  //agenda
  //audit audite
  readAuditAudite() async {
    return await dbHelper.readAuditAudite(DBTable.audit_audite);
  }
  saveAuditAudite(AuditModel model) async {
    return await dbHelper.insertAuditAudite(DBTable.audit_audite, model.dataMapAuditAudite());
  }
  deleteTableAuditAudite() async {
    if(kDebugMode) print('delete table AuditAudite');
    return await dbHelper.deleteTableAuditAudite();
  }
  getCountAuditAudite() async {
    return await dbHelper.getCountAuditAudite();
  }
  //audit auditeur
  readAuditAuditeur() async {
    return await dbHelper.readAuditAuditeur(DBTable.audit_auditeur);
  }
  saveAuditAuditeur(AuditModel model) async {
    return await dbHelper.insertAuditAuditeur(DBTable.audit_auditeur, model.dataMapAuditAuditeur());
  }
  deleteTableAuditAuditeur() async {
    if(kDebugMode) print('delete table AuditAuditeur');
    return await dbHelper.deleteTableAuditAuditeur();
  }
  getCountAuditAuditeur() async {
    return await dbHelper.getCountAuditAuditeur();
  }
  //rapport audit a valider
  readRapportAuditAValider() async {
    return await dbHelper.readRapportAuditAValider(DBTable.rapport_audit_valider);
  }
  saveRapportAuditAValider(AuditModel model) async {
    return await dbHelper.insertRapportAuditAValider(DBTable.rapport_audit_valider, model.dataMapRapportAudit());
  }
  deleteTableRapportAuditAValider() async {
    if(kDebugMode) print('drop table RapportAuditAValider');
    return await dbHelper.deleteTableRapportAuditAValider();
  }
  getCountRapportAuditAValider() async {
    return await dbHelper.getCountRapportAuditAValider();
  }
}