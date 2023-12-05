import 'package:flutter/material.dart';
import 'package:panneau_deme/model/equipement.dart';

class CardEquipement extends StatelessWidget {
  const CardEquipement({super.key, required this.equipement, required this.index});

  final Equipement equipement;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 0 ? const EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 10) : const EdgeInsets.only(left: 15,right: 15,bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0.0, 0.0),
                blurRadius: 7
            )
          ],
          gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.04,0.04],
              colors: [
                Color.fromRGBO(29, 29, 119, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ]
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Marque : ${equipement.marque}",style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text(equipement.puissance! > 0 ? "Puissance : ${equipement.puissance} watt" : "Puissance : -- watt",
              style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text(equipement.tension! > 0 ? "Tension : ${equipement.tension} Volts" : "Tension : -- Volts",
              style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text(equipement.intensite! > 0 ? "Intensité : ${equipement.intensite} Ampère" : "Intensité : -- Ampère",
              style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text("Type : ${equipement.typeEquipement!.titre}",style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text("Prix : ${equipement.prix} FCFA",style: const TextStyle(color: Colors.black,fontSize: 16)),
        ],
      ),
    );
  }
}
