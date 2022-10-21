class EvenementDeclencheurModel {
  int? idEvent;
  String? event;

  EvenementDeclencheurModel({this.idEvent, this.event});

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'idEvent' : idEvent,
      'event' : event
    };
    return map;
  }

  bool isEqual(EvenementDeclencheurModel? model) {
    return this.idEvent == model?.idEvent;
  }
}