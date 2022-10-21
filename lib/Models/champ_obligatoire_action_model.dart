class ChampObligatoireActionModel {
  int? commentaire_Realisation_Action;
  int? rapport_Suivi_Action;
  int? delai_Suivi_Action;
  int? priorite;
  int? gravite;
  int? commentaire;

  ChampObligatoireActionModel(
      {this.commentaire_Realisation_Action,
        this.rapport_Suivi_Action,
        this.delai_Suivi_Action,
        this.priorite,
        this.gravite,
        this.commentaire
      });

  Map<String, dynamic> dataMap(){
    var map = <String, dynamic>{
      'commentaire_Realisation_Action' : commentaire_Realisation_Action,
      'rapport_Suivi_Action' : rapport_Suivi_Action,
      'delai_Suivi_Action' : delai_Suivi_Action,
      'priorite' : priorite,
      'gravite' : gravite,
      'commentaire' : commentaire
    };
    return map;
  }
}