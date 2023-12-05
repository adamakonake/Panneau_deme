class TypeEquipement {
  int? idTypeEquipement;
  String? titre;

  TypeEquipement({this.idTypeEquipement,this.titre});

  factory TypeEquipement.fromJson(Map<String, dynamic> json){
    return TypeEquipement(
      idTypeEquipement: json['idTypeEquipement'],
      titre: json['titre']
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'idTypeEquipement' : idTypeEquipement,
      'titre' : titre
    };
  }

}