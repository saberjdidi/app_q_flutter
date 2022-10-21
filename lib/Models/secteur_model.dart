class SecteurModel {
  String? codeSecteur;
  String? secteur;

  SecteurModel({this.codeSecteur, this.secteur});

  Map<String, dynamic> dataMapIncidentEnv(){
    var map = <String, dynamic>{
      'codeSecteur' : codeSecteur,
      'secteur' : secteur
    };
    return map;
  }

  bool isEqual(SecteurModel? model) {
    return this.codeSecteur == model?.codeSecteur;
  }
}