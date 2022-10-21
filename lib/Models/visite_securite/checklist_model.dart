class CheckListModel {
  int? idCheck;
  String? code;
  String? checklist;

  CheckListModel({this.idCheck, this.code, this.checklist});

  Map<String, dynamic> dataMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idCheck'] = this.idCheck;
    data['code'] = this.code;
    data['checklist'] = this.checklist;
    return data;
  }

  bool isEqual(CheckListModel? model) {
    return this.idCheck == model?.idCheck;
  }
}