import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    "en" : {
      'home':'Home',
      'language':'Language',
      'choose_langue':'Choose Language',
      'signout':'Sign Out',
      'new':'New',
      'search':'Search',
      'empty_list':'Empty List',
      'loading':'Loading...',
      'traited':'Processed',
      'product':'Product',
      'synchronize_data':'Synchronize Data to Local Database',
      'exit':'Exit the Application',
      'mode_online':'Mode Online',
      'mode_offline':'Mode Offline',
      'no_internet':'No Internet Connection',
    },
    "fr" : {
       'home':'Acceuil',
      'language':'Langue',
      'choose_langue':'Choisir Langue',
      'signout':'Se déconnecter',
      'new':'Nouveau',
      'search':'Chercher',
      'empty_list':'Liste Vide',
      'loading':'Chargement...',
      'traited':'Traitée',
      'product':'Produit',
      'synchronize_data':'Synchroniser les données avec la Base de Données Locale',
      'exit':'Quittez Application',
      'mode_online':'Mode en ligne',
      'mode_offline':'Mode hors ligne',
      'no_internet':'Pas de connexion Internet',
    }

  };

}