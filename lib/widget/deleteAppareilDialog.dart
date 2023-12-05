import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../services/appareilService.dart';

class DeleteAppareilDialod extends StatefulWidget {
  const DeleteAppareilDialod({super.key , required this.idAppareil});

  final int idAppareil;

  @override
  State<DeleteAppareilDialod> createState() => _DeleteAppareilDialodState();
}

class _DeleteAppareilDialodState extends State<DeleteAppareilDialod> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          child: const Center(
            child: Text("Supprimer appareil", style: TextStyle(color: Colors.white)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Text(
                "Voulez-vous vraiment supprimer cet appareil",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30,left: 30,right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {_deleteAppareil();},
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0.0),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Center(child: Text("OUI",style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 0.0),
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(29, 29, 119, 1),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Center(child: Text("NON",style: TextStyle(color: Colors.white),)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  _deleteAppareil(){
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

    Provider.of<AppareilService>(context,listen: false).deleteAppareil(widget.idAppareil).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    }).catchError((onError){
      Navigator.pop(context);
      Navigator.pop(context);
      print(onError);
      if(onError.toString().replaceAll("Exception: ", "") == "impossible"){
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: const Text(
                      "Désolé vous ne pouvez pas supprimer cet appareil car il est déjà lié à un dimensionnement",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }else {
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
}
