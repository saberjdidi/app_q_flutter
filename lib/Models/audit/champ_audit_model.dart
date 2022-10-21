class ChampAuditModel {
  int? online;
  int? codeChamp;
  String? champ;
  String? criticite;
  String? refAudit;

  ChampAuditModel({this.online, this.codeChamp, this.champ, this.criticite, this.refAudit});

  ChampAuditModel.fromJson(Map<String, dynamic> json) {
    codeChamp = json['codeChamp'];
    champ = json['champ'];
    criticite = json['criticite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codeChamp'] = this.codeChamp;
    data['champ'] = this.champ;
    data['criticite'] = this.criticite;
    return data;
  }

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeChamp' : codeChamp,
      'champ' : champ,
      'criticite' : criticite
    };
    return map;
  }
  Map<String, dynamic> dataMapConstat(){
    var map = <String, dynamic>{
      'online' : online,
      'refAudit' : refAudit,
      'codeChamp' : codeChamp,
      'champ' : champ,
      'criticite' : criticite,
    };
    return map;
  }

  bool isEqual(ChampAuditModel? model) {
    return this.codeChamp == model?.codeChamp;
  }
}