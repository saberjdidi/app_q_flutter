
class LicenceEndModel {
  int? retour;

  LicenceEndModel({
    this.retour,
  });

  LicenceEndModel.fromDBLocal(Map<String, dynamic> json) {
    retour = json['retour'];

  }
}