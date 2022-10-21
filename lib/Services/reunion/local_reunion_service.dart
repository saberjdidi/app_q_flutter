
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Models/reunion/type_reunion_model.dart';
import '../../Models/reunion/participant_reunion_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalReunionService {

  DBHelper dbHelper = DBHelper();

  //Type Reunion
  readTypeReunion() async {
    return await dbHelper.readTypeReunion(DBTable.type_reunion);
  }
  saveTypeReunion(TypeReunionModel model) async {
    return await dbHelper.insertTypeReunion(DBTable.type_reunion, model.dataMap());
  }
  deleteTableTypeReunion() async {
    await dbHelper.deleteTableTypeReunion();
    print('delete table TypeReunion');
  }
  //reunion
  readReunion() async {
    return await dbHelper.readReunion();
  }
  readReunionByOnline() async {
    return await dbHelper.readReunionByOnline();
  }
  Future<List<ReunionModel>> readListReunionByOnline() async {
    final response =  await dbHelper.readReunionByOnline();
    final List result = response;
    return result.map((
            (e) => ReunionModel.fromDBLocal(e)
    )).toList();
  }
  getMaxNumReunion() async {
    return await dbHelper.getMaxNumReunion();
  }
  saveReunion(ReunionModel model) async {
    return await dbHelper.insertReunion(DBTable.reunion, model.dataMap());
  }
  saveReunionSync(ReunionModel model) async {
    return await dbHelper.insertReunion(DBTable.reunion, model.dataMapSync());
  }
  deleteTableReunion() async {
    await dbHelper.deleteTableReunion();
    print('delete Table Reunion');
  }
  deleteReunionOffline() async {
    await dbHelper.deleteReunionOffline();
    print('delete Table Reunion where online=0');
  }
  getReunionByNumero(nnc) async {
    return await dbHelper.readReunionByNumero(DBTable.reunion,nnc);
  }
  getCountReunion() async {
    return await dbHelper.getCountReunion();
  }
  //participant
  readParticipantByReunion(int? nReunion) async {
    return await dbHelper.readParticipantByReunion(nReunion);
  }
  readParticipantReunionByOnline() async {
    return await dbHelper.readParticipantReunionByOnline();
  }
  Future<List<ParticipantReunionModel>> readListParticipantReunionByOnline() async {
    final response =  await dbHelper.readParticipantReunionByOnline();
    final List result = response;
    return result.map((
            (e) => ParticipantReunionModel.fromDBLocal(e)
    )).toList();
  }
  saveParticipantReunion(ParticipantReunionModel model) async {
    return await dbHelper.insertParticipantReunion(DBTable.participant_reunion, model.dataMap());
  }
  deleteTableParticipantReunion() async {
    await dbHelper.deleteTableParticipantReunion();
    print('delete Table ParticipantReunion');
  }
  readEmployeParticipantReunion(int? nReunion) async {
    return await dbHelper.readEmployeParticipantReunion(nReunion);
  }
  //Agenda
  //reunion informer
  readReunionInformer() async {
    return await dbHelper.readReunionInformer(DBTable.reunion_informer);
  }
  saveReunionInformer(ReunionModel model) async {
    return await dbHelper.insertReunionInformer(DBTable.reunion_informer, model.dataMapReunionInformer());
  }
  deleteTableReunionInformer() async {
    await dbHelper.deleteTableReunionInformer();
    print('delete Table ReunionInformer ');
  }
  getCountReunionInformer() async {
    return await dbHelper.getCountReunionInformer();
  }
  //reunion planifier
  readReunionPlanifier() async {
    return await dbHelper.readReunionPlanifier(DBTable.reunion_planifier);
  }
  saveReunionPlanifier(ReunionModel model) async {
    return await dbHelper.insertReunionPlanifier(DBTable.reunion_planifier, model.dataMapReunionPlanifier());
  }
  deleteTableReunionPlanifier() async {
    await dbHelper.deleteTableReunionPlanifier();
    print('delete Table ReunionPlanifier ');
  }
  getCountReunionPlanifier() async {
    return await dbHelper.getCountReunionPlanifier();
  }


}