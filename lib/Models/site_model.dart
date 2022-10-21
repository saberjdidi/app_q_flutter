class SiteModel {
  int? codesite;
  String? site;
  String? module;
  String? fiche;

  SiteModel({
    this.codesite,
    this.site,
    this.module,
    this.fiche
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codesite' : codesite,
      'site' : site,
      'module' : module,
      'fiche' : fiche
    };
    return map;
  }

  Map<String, dynamic> dataMapVisiteSecurite(){
    var map = <String, dynamic>{
      'codesite' : codesite,
      'site' : site
    };
    return map;
  }

  bool isEqual(SiteModel? model) {
    return this.codesite == model?.codesite;
  }
}