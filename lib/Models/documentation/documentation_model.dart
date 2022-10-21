class DocumentationModel {
  int? online;
  String? cdi;
  String? libelle;
  String? indice;
  String? typeDI;
  String? fichierLien;
  String? motifMAJ;
  String? fl;
  String? dateRevis;
  String? suffixe;
  int? favoris;
  String? favorisEtat;
  int? mail;
  bool? mailBoolean;
  String? dateCreat;
  String? dateRevue;
  String? dateprochRevue;
  int? nbrVers;
  String? superv;
  String? sitesuperv;
  int? important;
  int? issuperviseur;
  String? documentPlus0;
  String? documentPlus1;

  DocumentationModel(
      {
        this.online,
        this.cdi,
        this.libelle,
        this.indice,
        this.typeDI,
        this.fichierLien,
        this.motifMAJ,
        this.fl,
        this.dateRevis,
        this.suffixe,
        this.favoris,
        this.favorisEtat,
        this.mail,
        this.mailBoolean,
        this.dateCreat,
        this.dateRevue,
        this.dateprochRevue,
        this.nbrVers,
        this.superv,
        this.sitesuperv,
        this.important,
        this.issuperviseur,
        this.documentPlus0,
        this.documentPlus1});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'online' : online,
      'cdi' : cdi,
      'libelle': libelle,
      'indice' : indice,
      'typeDI' : typeDI,
      'fichierLien' : fichierLien,
      'motifMAJ' : motifMAJ,
      'fl' : fl,
      'dateRevis' : dateRevis,
      'suffixe' : suffixe,
      'favoris' : favoris,
      'favorisEtat' : favorisEtat,
      'mail' : mail,
      'dateCreat' : dateCreat,
      'dateRevue' : dateRevue,
      'dateprochRevue' : dateprochRevue,
      'superv' : superv,
      'sitesuperv' : sitesuperv,
      'important' : important,
      'issuperviseur' : issuperviseur
    };
    return map;
  }
}