class Electricien {
  int? idElectricien;
  String? nom;
  String? prenom;
  int? experience;
  String? email;
  String? telephone;
  double? note;
  String? photo;
  bool? active;

  Electricien({this.idElectricien,this.nom,this.prenom,this.experience,this.email,this.telephone,this.note,this.photo,this.active});

  factory Electricien.fromJson(Map<String, dynamic> json){
    return Electricien(
      idElectricien: json['idElectricien'],
      nom: json['nom'],
      prenom: json['prenom'],
      experience: json['experience'],
      email: json['email'],
      telephone: json['telephone'],
      note: json['note'],
      photo: json['photo'],
      active: json['active']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'idElectricien' : idElectricien,
      'nom' : nom,
      'prenom' : prenom,
      'experience' : experience,
      'email' : email,
      'telephone' : telephone,
      'note' : note,
      'photo' : photo,
      'active' : active
    };
  }
}