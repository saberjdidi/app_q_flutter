class ClientModel {
  String? codeclt;
  String? nomClient;

  ClientModel(
      {this.codeclt,
        this.nomClient
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'codeclt' : codeclt,
      'nomClient' : nomClient
    };
    return map;
  }

  bool isEqual(ClientModel? model) {
    return this.codeclt == model?.codeclt;
  }
}