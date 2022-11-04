
class BeginLicenceModel {
  String? LicenseStart;
  String? LicenseEnd;
  String? DeviceId;
  String? LicenseKey;

  BeginLicenceModel({
    this.LicenseStart,
    this.LicenseEnd,
    this.DeviceId,
    this.LicenseKey,
  });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'LicenseStart' : LicenseStart,
      'LicenseEnd' : LicenseEnd,
      'DeviceId' : DeviceId,
      'LicenseKey' : LicenseKey,
    };
    return map;
  }

  BeginLicenceModel.fromDBLocal(Map<String, dynamic> json) {
    LicenseStart = json['LicenseStart'];
    LicenseEnd = json['LicenseEnd'];
    DeviceId = json['DeviceId'];
    LicenseKey = json['LicenseKey'];
  }
}