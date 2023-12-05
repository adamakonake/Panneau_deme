import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/services/appareilService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

import '../model/appareil.dart';

class AddAppareilDialog extends StatefulWidget {
  const AddAppareilDialog({super.key, this.appareil,required this.ajout});
  
  final Appareil? appareil;
  final bool ajout;

  @override
  State<AddAppareilDialog> createState() => _AddAppareilDialogState();
}

class _AddAppareilDialogState extends State<AddAppareilDialog> {

  final _formKey = GlobalKey<FormState>();
  final _nomInputController = TextEditingController();
  final _puissanceInputController = TextEditingController();
  final _heureConsoInputController = TextEditingController();
  final _quantiteInputController = TextEditingController();

  bool _nomError = false;


  @override
  void initState() {
    super.initState();
    if(widget.appareil != null){
      _nomInputController.text = widget.appareil!.nom!;
      _puissanceInputController.text = widget.appareil!.puissance!.toString();
      _heureConsoInputController.text = widget.appareil!.heureConso!.toString();
      _quantiteInputController.text = widget.appareil!.quantite!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 0.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              color: Color.fromRGBO(29, 29, 119, 1)
            ),
            child: Text(widget.ajout ? "Ajout appareil" : "Modifier appareil",textAlign: TextAlign.center,style: const TextStyle(color: Colors.white),),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextFormField(
                      controller: _nomInputController,
                      maxLength: 100,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "remplisser le champs";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Nom",
                          contentPadding: const EdgeInsets.only(left: 7.0),
                          errorText: _nomError ? "Nom exist" : null
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextFormField(
                      controller: _puissanceInputController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "remplissez le champs";
                        }
                        if(int.parse(value) <= 0){
                          return "Entrez une valeur superieur à 0";
                        }
                        if(int.parse(value) > 2000){
                          return "Entrez une valeur inférieure ou égale à 2000";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Puissance en watt",
                        contentPadding: EdgeInsets.only(bottom: 5.0,left: 7.0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextFormField(
                      controller: _heureConsoInputController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "remplissez le champs";
                        }
                        if(int.parse(value) <= 0){
                          return "Entrez une valeur superieur à 0";
                        }
                        if(int.parse(value) > 24){
                          return "Entrez une valeur inférieure ou égale à 24";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Heure Conso en h/j",
                        contentPadding: EdgeInsets.only(bottom: 5.0,left: 7.0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextFormField(
                      controller: _quantiteInputController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "remplissez le champs";
                        }
                        if(int.parse(value) <= 0){
                          return "Entrez une valeur superieur à 0";
                        }
                        if(int.parse(value) > 220){
                          return "Entrez une valeur inférieure ou égale à 220";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Quantité",
                        contentPadding: EdgeInsets.only(bottom: 5.0,left: 7.0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0,left: 30,right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.ajout ? GestureDetector(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              Appareil appareil = Appareil(
                                nom: _nomInputController.text,
                                puissance: int.parse(_puissanceInputController.text),
                                heureConso: int.parse(_heureConsoInputController.text),
                                quantite: int.parse(_quantiteInputController.text),
                                utilisateur: Provider.of<UserService>(context,listen: false).currentUser
                              );
                              _addAppareil(appareil);
                            }
                          },
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(29, 29, 119, 1),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text("Ajouter",style: TextStyle(color: Colors.white),)),
                          ),
                        ) : GestureDetector(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              Appareil appareil = Appareil(
                                  nom: _nomInputController.text,
                                  puissance: int.parse(_puissanceInputController.text),
                                  heureConso: int.parse(_heureConsoInputController.text),
                                  quantite: int.parse(_quantiteInputController.text),
                                  utilisateur: Provider.of<UserService>(context,listen: false).currentUser
                              );
                              appareil.idAppareil = widget.appareil!.idAppareil;
                              _updateAppareil(appareil);
                            }
                          },
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(29, 29, 119, 1),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text("Modifier",style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Center(child: Text("Annuler",style: TextStyle(color: Colors.white),)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _addAppareil(Appareil appareil){

    showDialog(
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: const Dialog.fullscreen(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.25),
            child: Center(
              child: SpinKitFadingCircle(
                color: Color.fromRGBO(253, 184, 19, 1),
              ),
            ),
          ),
        )
    );

    Provider.of<AppareilService>(context,listen: false).addAppareil(appareil).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((onError){
      Navigator.pop(context);
      print(onError);
      if(onError.toString().replaceAll("Exception: ", "") == "exist"){
        setState(() {
          _nomError = true;
        });
      }else{
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Erreur serveur veuillez verifier votre connexion internet où réessayer plus tard",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }

  _updateAppareil(Appareil appareil){

    showDialog(
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: const Dialog.fullscreen(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.25),
            child: Center(
              child: SpinKitFadingCircle(
                color: Color.fromRGBO(253, 184, 19, 1),
              ),
            ),
          ),
        )
    );

    Provider.of<AppareilService>(context,listen: false).updateAppareil(appareil).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((onError){
      Navigator.pop(context);
      print(onError);
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(15.0),
                  child: const Text(
                    "Erreur serveur veuillez verifier votre connexion internet où réessayer plus tard",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
