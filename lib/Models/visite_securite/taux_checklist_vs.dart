class TauxCheckListVS {
  int? id;
  int? taux;

  TauxCheckListVS({this.id, this.taux});

  TauxCheckListVS.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taux = json['taux'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['taux'] = this.taux;
    return data;
  }

  Map<String, dynamic> dataMap() {
    var map = <String, dynamic>{'id': id, 'taux': taux};
    return map;
  }
}
