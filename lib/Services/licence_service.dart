import 'package:flutter/foundation.dart';

import '../Models/begin_licence_model.dart';
import '../Models/licence_end_model.dart';
import '../Models/licence_model.dart';
import '../Utils/Sqflite/db_helper.dart';
import '../Utils/Sqflite/db_table.dart';

class LicenceService {
  DBHelper dbHelper = DBHelper();
  //licence
  readLicenceInfo() async {
    return await dbHelper.readLicenceInfo(DBTable.licence_info);
  }

  Future<LicenceModel> getLicenceInfo() async {
    final response = await dbHelper.getLicenceInfo();
    return LicenceModel.fromDBLocal(response);
  }

  saveLicenceInfo(LicenceModel model) async {
    return await dbHelper.insertLicenceInfo(
        DBTable.licence_info, model.dataMap());
  }

  deleteTableLicenceInfo() async {
    debugPrint('delete table LicenceInfo');
    return await dbHelper.deleteTableLicenceInfo();
  }

  //begin & end licence
  Future<BeginLicenceModel> getBeginLicence() async {
    final response = await dbHelper.getBeginLicence();
    return BeginLicenceModel.fromDBLocal(response);
  }

  saveBeginLicence(BeginLicenceModel model) async {
    return await dbHelper.insertBeginLicence(
        DBTable.mobile_licence, model.dataMap());
  }

  deleteTableBeginLicence() async {
    debugPrint('delete table BeginLicence');
    return await dbHelper.deleteTableBeginLicence();
  }

  Future<LicenceEndModel> getIsLicenceEnd(licence_id) async {
    final response = await dbHelper.isLicenceEnd(licence_id);
    return LicenceEndModel.fromDBLocal(response);
  }

  isLicenceEnd(licence_id) async {
    return await dbHelper.isLicenceEnd(licence_id);
  }
}
