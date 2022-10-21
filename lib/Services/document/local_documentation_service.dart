import 'package:flutter/foundation.dart';
import 'package:qualipro_flutter/Models/documentation/documentation_model.dart';
import 'package:qualipro_flutter/Models/documentation/type_document_model.dart';
import 'package:qualipro_flutter/Models/reunion/reunion_model.dart';
import 'package:qualipro_flutter/Models/reunion/type_reunion_model.dart';
import '../../Utils/Sqflite/db_helper.dart';
import '../../Utils/Sqflite/db_table.dart';

class LocalDocumentationService {

  DBHelper dbHelper = DBHelper();

  //documentation
  readDocumentation() async {
    return await dbHelper.readDocumentation();
  }
  searchDocumentation(code, libelle, type) async {
    return await dbHelper.searchDocumentation(code, libelle, type);
  }
  readDocumentationByOnline() async {
    return await dbHelper.readDocumentationByOnline();
  }
  saveDocumentation(DocumentationModel model) async {
    return await dbHelper.insertDocumentation(DBTable.documentation, model.dataMap());
  }
  deleteTableDocumentation() async {
    await dbHelper.deleteTableDocumentation();
    if(kDebugMode){
      print('delete table Documentation');
    }
  }
  readDocumentationByCode(code) async {
    return await dbHelper.readDocumentationByCode(DBTable.documentation,code);
  }
  getCountDocumentation() async {
    return await dbHelper.getCountDocumentation();
  }
  //type document
  readTypeDocument() async {
    return await dbHelper.readTypeDocument(DBTable.type_document);
  }
  saveTypeDocument(TypeDocumentModel model) async {
    return await dbHelper.insertTypeDocument(DBTable.type_document, model.dataMap());
  }
  deleteTableTypeDocument() async {
     await dbHelper.deleteTableTypeDocument();
    if(kDebugMode){
      print('delete table TypeDocument');
    }
  }

}