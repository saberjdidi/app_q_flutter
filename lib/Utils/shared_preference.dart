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

  static Future clearSharedPreference() async =>
      await _preferences.clear();
}