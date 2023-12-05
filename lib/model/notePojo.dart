class NotePojo {

  int? idNotePojo;
  double? valeur;
  int? idUser;
  int? idElec;
  int? idDim;

  NotePojo({this.idNotePojo, this.valeur, this.idUser, this.idElec, this.idDim});

  factory NotePojo.fromJson(Map<String, dynamic> json){
    return NotePojo(
      idNotePojo: json["idNotePojo"],
      valeur: json["valeur"],
      idUser: json["idUser"],
      idElec: json["idElec"],
      idDim: json["idDim"]
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "idNotePojo" : idNotePojo,
      "valeur" : valeur,
      "idUser" : idUser,
      "idElec" : idElec,
      "idDim" : idDim
    };
  }

}