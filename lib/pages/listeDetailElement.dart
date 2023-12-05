import 'package:flutter/material.dart';
import 'package:panneau_deme/widget/cardEquipement.dart';

import '../model/appareil.dart';
import '../model/equipement.dart';

class ListDetailElement extends StatefulWidget {
  const ListDetailElement({super.key, required this.titre, required this.isAppareil ,this.listAppareil, this.listEquipement});

  final String titre;
  final bool isAppareil;
  final List<Appareil>? listAppareil;
  final List<Equipement>? listEquipement;

  @override
  State<ListDetailElement> createState() => _ListDetailElementState();
}

class _ListDetailElementState extends State<ListDetailElement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            Container(
              height: 70,
              //padding: const EdgeInsets.only(left: 5.0,right: 5.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/auth_background.jpg"),
                    fit: BoxFit.cover
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: (){Navigator.pop(context);},
                        icon: const Icon(Icons.chevron_left,color: Colors.white,size: 35)
                    ),
                    Text(
                      widget.titre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                          overflow: TextOverflow.visible
                      ),
                    ),
                    const SizedBox(width: 40,)
                  ],
                )
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 19),
              margin: const EdgeInsets.only(top: 51),
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19)
                  ),
                  color: Colors.white
              ),
              child: widget.isAppareil ? ListView.builder(
                itemCount: widget.listAppareil!.length,
                itemBuilder: (context, index) {
                  return _buildCardAppareil(widget.listAppareil![index], index);
                },
              ) : ListView.builder(
                itemCount: widget.listEquipement!.length,
                itemBuilder: (context, index) {
                  return CardEquipement(equipement: widget.listEquipement![index], index: index);
                },
              )
            ),
          ],
        ),
      ),
    );
  }

  _buildCardAppareil(Appareil appareil,int index){
    return Container(
      margin: index == 0 ? const EdgeInsets.only(left: 15, right: 15,bottom: 15,top: 10) : const EdgeInsets.only(left: 15, right: 15,bottom: 15),
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
              stops: [0.05,0.05],
              colors: [
                Color.fromRGBO(29, 29, 119, 1),
                Color.fromRGBO(255, 255, 255, 1),
              ]
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Nom : ${appareil.nom}",style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text("Puissance : ${appareil.puissance} watt",style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text("Heure conso : ${appareil.heureConso} heure/jour",style: const TextStyle(color: Colors.black,fontSize: 16)),
          Text("Quantité : ${appareil.quantite}",style: const TextStyle(color: Colors.black,fontSize: 16)),
        ],
      ),
    );
  }

}
