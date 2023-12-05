import 'package:panneau_deme/model/electricien.dart';
import 'package:panneau_deme/model/utilisateur.dart';

class Dimensionnement {

  int? idDimensionnement;
  String? description;
  int? puissanceCrete;
  int? capaciteBatterie;
  int? puissanceRegulateur;
  int? puissanceOnduleur;
  int? tensionTravail;
  String? date;
  Electricien? electricien;
  Utilisateur? utilisateur;

  Dimensionnement({
    this.idDimensionnement,
    this.description,
    this.puissanceCrete,
    this.capaciteBatterie,
    this.puissanceRegulateur,
    this.puissanceOnduleur,
    this.tensionTravail,
    this.date,
    this.electricien,
    this.utilisateur,
  });

  factory Dimensionnement.fromJson(Map<String, dynamic> json){
    return Dimensionnement(
      idDimensionnement: json["idDimensionnement"],
      description: json["description"],
      puissanceCrete: json["puissanceCrete"],
      capaciteBatterie: json["capaciteBatterie"],
      puissanceRegulateur: json["puissanceRegulateur"],
      puissanceOnduleur: json["puissanceOnduleur"],
      tensionTravail: json["tensionTravail"],
      date: json["date"],
      electricien: Electricien.fromJson(json["electricien"]),
      utilisateur: json["utilisateur"] != null ? Utilisateur.fromJsno(json["utilisateur"]) : null
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "idDimensionnement" : idDimensionnement,
      "description" : description,
      "puissanceCrete" : puissanceCrete,
      "capaciteBatterie" : capaciteBatterie,
      "puissanceRegulateur" : puissanceRegulateur,
      "puissanceOnduleur" : puissanceOnduleur,
      "tensionTravail" : tensionTravail,
      "date" : date,
      "electricien" : electricien!.toMap(),
      "utilisateur" : utilisateur!.toMap()
    };
  }

}