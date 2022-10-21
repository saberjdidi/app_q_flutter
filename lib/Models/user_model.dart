class UserModel {
  String? mat;
  String? nompre;
  int? supeer;
  int? change;
  int? bloque;
  String? login;
  String? password;

  UserModel({this.mat, this.nompre, this.supeer, this.change, this.bloque, this.login});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'mat' : mat,
      'nompre' : nompre,
      'supeer' : supeer,
      'change' : change,
      'bloque' : bloque,
      'login' : login,
      'password' : password
    };
    return map;
  }

/*UserModel.fromJson(Map<String, dynamic> json) {
mat = json['mat'];
nompre = json['nompre'];
supeer = json['super'];
change = json['change'];
bloque = json['bloque'];
login = json['login'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['mat'] = this.mat;
  data['nompre'] = this.nompre;
  data['super'] = this.supeer;
  data['change'] = this.change;
  data['bloque'] = this.bloque;
  data['login'] = this.login;
  return data;
} */
}