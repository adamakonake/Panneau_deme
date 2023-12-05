import 'package:panneau_deme/model/utilisateur.dart';

class Appareil{
  int? idAppareil;
  String? nom;
  int? puissance;
  int? heureConso;
  int? quantite;
  Utilisateur? utilisateur;

  Appareil({this.idAppareil,this.nom,this.puissance,this.heureConso,this.quantite,this.utilisateur});

  factory Appareil.fromJson(Map<String,dynamic> json){
    return Appareil(
      idAppareil: json['idAppareil'],
      nom: json['nom'],
      puissance: json['puissance'],
      heureConso: json['heureConso'],
      quantite: json['quantite'],
      utilisateur: Utilisateur.fromJsno(json['utilisateur'])
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'idAppareil' : idAppareil,
      'nom' : nom,
      'puissance' : puissance,
      'heureConso' : heureConso,
      'quantite' : quantite,
      'utilisateur' : utilisateur!.toMap()
    };
  }
}