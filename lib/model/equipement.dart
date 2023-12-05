import 'package:panneau_deme/model/typeEquiment.dart';

class Equipement {
  int? idEquipement;
  String? marque;
  int? puissance;
  int? tension;
  int? intensite;
  int? prix;
  TypeEquipement? typeEquipement;

  Equipement({this.idEquipement, this.marque, this.puissance, this.tension, this.intensite, this.prix, this.typeEquipement});

  factory Equipement.fromJson(Map<String, dynamic> json){
    return Equipement(
      idEquipement: json['idEquipement'],
      marque: json['marque'],
      puissance: json['puissance'],
      tension: json['tension'],
      intensite: json['intensite'],
      prix: json['prix'],
      typeEquipement: TypeEquipement.fromJson(json['typeEquipement'])
    );
  }

  Map<String,dynamic> toMap() {
    return {
      'idEquipement' : idEquipement,
      'marque' : marque,
      'puissance' : puissance,
      'tension' : tension,
      'intensite' : intensite,
      'prix' : prix,
      'typeEquipement' : typeEquipement!.toMap()
    };
  }
}