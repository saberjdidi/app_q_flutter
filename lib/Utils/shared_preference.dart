import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static SharedPreferences _preferences = SharedPreferences.getInstance() as SharedPreferences;

  static const _keyUsername = 'username';
  static const _keyPets = 'pets';
  static const _keyBirthday = 'birthday';
  static const _KeyMatricule = 'matricule';
  static const _KeyNomPrenom = 'nomprenom';
  static const _KeyLangue = 'langue';
  static const _isOneProduct = 'oneProduct';
  static const _licenceKey = 'licenceKey';
  static const _webServiceKey = 'webServiceKey';
  static const _nbDaysKey = 'nbDaysKey';
  static const _deviceIdKey = 'deviceIdKey';
  static const _deviceNameKey = 'deviceNameKey';
  static const _isVisibleActionKey = 'isVisibleActionKey';
  static const _isVisibleAuditKey = 'isVisibleAuditKey';
  static const _isVisiblePNCKey = 'isVisiblePNCKey';
  static const _isVisibleDocumentationKey = 'isVisibleDocumentationKey';
  static const _isVisibleReunionKey = 'isVisibleReunionKey';
  static const _isVisibleIncSecKey = 'isVisibleIncSecKey';
  static const _isVisibleIncEnvKey = 'isVisibleIncEnvKey';
  static const _isVisibleVisiteSecKey = 'isVisibleVisiteSecKey';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setMatricule(String mat) async =>
      await _preferences.setString(_KeyMatricule, mat);

  static String? getMatricule() => _preferences.getString(_KeyMatricule);

  static Future setNomPrenom(String nompre) async =>
      await _preferences.setString(_KeyNomPrenom, nompre);

  static String? getNomPrenom() => _preferences.getString(_KeyNomPrenom);

  static Future setUsername(String username) async =>
      await _preferences.setString(_keyUsername, username);

  static String? getUsername() => _preferences.getString(_keyUsername);

  static Future setPets(List<String> pets) async =>
      await _preferences.setStringList(_keyPets, pets);

  static List<String>? getPets() => _preferences.getStringList(_keyPets);

  static Future setBirthday(DateTime dateOfBirth) async {
    final birthday = dateOfBirth.toIso8601String();

    return await _preferences.setString(_keyBirthday, birthday);
  }

  static DateTime? getBirthday() {
    final birthday = _preferences.getString(_keyBirthday);

    return birthday == null ? null : DateTime.tryParse(birthday);
  }

  static Future setLangue(String lang) async =>
      await _preferences.setString(_KeyLangue, lang);

  static String? getLangue() => _preferences.getString(_KeyLangue);

  static Future setIsOneProduct(int seulProduit) async =>
      await _preferences.setInt(_isOneProduct, seulProduit);
  static int? getIsOneProduct() => _preferences.getInt(_isOneProduct);


  static Future setLicenceKey(String licence) async =>
      await _preferences.setString(_licenceKey, licence);
  static String? getLicenceKey() => _preferences.getString(_licenceKey);

  static Future setWebServiceKey(String webService) async =>
      await _preferences.setString(_webServiceKey, webService);
  static String? getWebServiceKey() => _preferences.getString(_webServiceKey);

  static Future setNbDaysKey(String nbDay) async =>
     await _preferences.setString(_nbDaysKey, nbDay);
  static String? getNbDaysKey() => _preferences.getString(_nbDaysKey);

  static Future setDeviceIdKey(String deviceId) async =>
      await _preferences.setString(_deviceIdKey, deviceId);
  static String? getDeviceIdKey() => _preferences.getString(_deviceIdKey);

  static Future setDeviceNameKey(String deviceName) async =>
      await _preferences.setString(_deviceNameKey, deviceName);
  static String? getDeviceNameKey() => _preferences.getString(_deviceNameKey);

  static Future setIsVisibleAction(int action) async =>
      await _preferences.setInt(_isVisibleActionKey, action);
  static int? getIsVisibleAction() => _preferences.getInt(_isVisibleActionKey);

  static Future setIsVisibleAudit(int audit) async =>
      await _preferences.setInt(_isVisibleAuditKey, audit);
  static int? getIsVisibleAudit() => _preferences.getInt(_isVisibleAuditKey);

  static Future setIsVisiblePNC(int pnc) async =>
      await _preferences.setInt(_isVisiblePNCKey, pnc);
  static int? getIsVisiblePNC() => _preferences.getInt(_isVisiblePNCKey);

  static Future setIsVisibleDocumentation(int doc) async =>
      await _preferences.setInt(_isVisibleDocumentationKey, doc);
  static int? getIsVisibleDocumentation() => _preferences.getInt(_isVisibleDocumentationKey);

  static Future setIsVisibleReunion(int reunion) async =>
      await _preferences.setInt(_isVisibleReunionKey, reunion);
  static int? getIsVisibleReunion() => _preferences.getInt(_isVisibleReunionKey);

  static Future setIsVisibleIncidentSecurite(int incSec) async =>
      await _preferences.setInt(_isVisibleIncSecKey, incSec);
  static int? getIsVisibleIncidentSecurite() => _preferences.getInt(_isVisibleIncSecKey);

  static Future setIsVisibleIncidentEnvironnement(int incEnv) async =>
      await _preferences.setInt(_isVisibleIncEnvKey, incEnv);
  static int? getIsVisibleIncidentEnvironnement() => _preferences.getInt(_isVisibleIncEnvKey);

  static Future setIsVisibleVisiteSecurite(int visiteSec) async =>
      await _preferences.setInt(_isVisibleVisiteSecKey, visiteSec);
  static int? getIsVisibleVisiteSecurite() => _preferences.getInt(_isVisibleVisiteSecKey);

  static Future clearSharedPreference() async =>
      await _preferences.clear();

  static Future removeSharedPreferenceByKey(String data) async =>
      await _preferences.remove(data);
}