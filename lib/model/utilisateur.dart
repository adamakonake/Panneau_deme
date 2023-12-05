class Utilisateur {
  int? idUtilisateur;
  String? nom;
  String? prenom;
  String? email;
  String? motDePasse;

  Utilisateur({this.idUtilisateur,this.nom,this.prenom,this.email,this.motDePasse});

  factory Utilisateur.fromJsno(Map<String,dynamic> json){
    return Utilisateur(
      idUtilisateur: json['idUtilisateur'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      motDePasse: json['motDePasse']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'idUtilisateur' : idUtilisateur,
      'nom' : nom,
      'prenom' : prenom,
      'email' : email,
      'motDePasse' : motDePasse
    };
  }
}