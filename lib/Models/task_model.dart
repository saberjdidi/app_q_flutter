class TaskModel {
  String? id;
  String? fullName;
  String? email;
  String? job;
  String? createdAt;

  TaskModel(
      {this.id,
        this.fullName,
        this.email,
        this.job,
        this.createdAt});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    job = json['job'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['job'] = this.job;
    data['createdAt'] = this.createdAt;
    return data;
  }
  Map<String, dynamic> taskMap(){
    var map = <String, dynamic>{
      '_id' : id,
      'fullName' : fullName,
      'email' : email,
      'job' : job,
      'createdAt' : createdAt
    };
    return map;
  }
  Map<String, dynamic> taskMapSync(){
    var map = <String, dynamic>{
      'fullName' : fullName,
      'email' : email,
      'job' : job
    };
    return map;
  }
}