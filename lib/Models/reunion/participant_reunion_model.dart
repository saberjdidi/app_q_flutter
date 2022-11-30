class ParticipantReunionModel {
  int? online;
  String? mat;
  String? nompre;
  int? aparticipe;
  int? confirm;
  String? comment;
  int? nReunion;
  String? intExt;
  int? id;
  int? hasconfirmed;
  String? message;
  int? vis;
  int? enab;
  String? aconfirme;
  String? mail;

  ParticipantReunionModel(
      {this.online,
      this.mat,
      this.nompre,
      this.aparticipe,
      this.intExt,
      this.id,
      this.confirm,
      this.comment,
      this.hasconfirmed,
      this.message,
      this.vis,
      this.enab,
      this.aconfirme,
      this.mail,
      this.nReunion});

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{
      'online': online,
      'mat': mat,
      'nompre': nompre,
      'aparticipe': aparticipe,
      'confirm': confirm,
      'comment': comment,
      'nReunion': nReunion,
    };
    return map;
  }

  ParticipantReunionModel.fromDBLocal(Map<String, dynamic> json) {
    online = json['online'];
    mat = json['mat'];
    nompre = json['nompre'];
    aparticipe = json['aparticipe'];
    confirm = json['confirm'];
    comment = json['comment'];
    nReunion = json['nReunion'];
  }

  bool isEqual(ParticipantReunionModel? model) {
    return this.mat == model?.mat;
  }
}
