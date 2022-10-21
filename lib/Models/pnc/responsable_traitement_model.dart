class ResponsableTraitementModel {
  int? id_resptrait;
  int? id_nc;
  String? resptrait;
  String? nompre;
  String? premier_resp;
  String? traite_str;
  String? date_trait;
  String? rapport_trait;
  int? premier_resp_int;

  ResponsableTraitementModel({
    this.id_resptrait,
    this.id_nc,
    this.resptrait,
    this.nompre,
    this.premier_resp,
    this.traite_str,
    this.date_trait,
    this.rapport_trait,
    this.premier_resp_int
  });

  bool isEqual(ResponsableTraitementModel? model) {
    return this.id_resptrait == model?.id_resptrait;
  }
}