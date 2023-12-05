import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/model/appareil.dart';
import 'package:panneau_deme/model/dimensionnement.dart';
import 'package:panneau_deme/model/electricien.dart';
import 'package:panneau_deme/model/equipement.dart';
import 'package:panneau_deme/model/notePojo.dart';
import 'package:panneau_deme/pages/listeDetailElement.dart';
import 'package:panneau_deme/widget/cardElectricienDimensionnement.dart';
import 'package:provider/provider.dart';

import '../services/dimensionnementService.dart';

class DimensionnementDetailPage extends StatefulWidget {
  const DimensionnementDetailPage({super.key, required this.dimensionnement});

  final Dimensionnement dimensionnement;

  @override
  State<DimensionnementDetailPage> createState() => _DimensionnementDetailPageState();
}

class _DimensionnementDetailPageState extends State<DimensionnementDetailPage> {
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
                    const Text(
                      "Détail",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white
                      ),
                    ),
                    const SizedBox(width: 40,)
                    /*IconButton(
                        onPressed: (){},
                        icon: const Icon(Icons.delete_forever,color: Colors.white,size: 35)
                    )*/
                  ],
                ),
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
              child: Consumer<DimensionnementService>(
                builder: (context, dimensionnementService, child) {
                  return FutureBuilder(
                    future: dimensionnementService.getDimensionnementById(widget.dimensionnement.idDimensionnement!),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if(snapshot.hasError){
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }

                      if(!snapshot.hasData){
                        return const Center(
                          child: Text("Aucun dimensionnement trouvé"),
                        );
                      }

                      Map<String,dynamic> panneauInfo = snapshot.data!["panneauInfo"];
                      Map<String,dynamic> onduleurInfo = snapshot.data!["onduleurInfo"];
                      Map<String,dynamic> batterieInfo = snapshot.data!["batterieInfo"];
                      Map<String,dynamic> regulateurInfo = snapshot.data!["regulateurInfo"];
                      NotePojo notePojo = NotePojo.fromJson(snapshot.data!["notePojo"]);
                      
                      Equipement panneau = Equipement.fromJson(panneauInfo["panneau"]);
                      Equipement batterie = Equipement.fromJson(batterieInfo["batterie"]);
                      Equipement onduleur = Equipement.fromJson(onduleurInfo["onduleur"]);
                      Equipement regulateur = Equipement.fromJson(regulateurInfo["regulateur"]);

                      List<dynamic> bodyAppareils = snapshot.data!["listAppareil"];
                      List<Appareil> appareilList = bodyAppareils.map((e) => Appareil.fromJson(e)).toList();

                      List<dynamic> bodyPanneau = snapshot.data!["listPanneau"];
                      List<Equipement> listPanneau = bodyPanneau.map((e) => Equipement.fromJson(e)).toList();

                      List<dynamic> bodyBatterie = snapshot.data!["listBatterie"];
                      List<Equipement> listBatterie = bodyBatterie.map((e) => Equipement.fromJson(e)).toList();

                      List<dynamic> bodyRegulateur = snapshot.data!["listRegulateur"];
                      List<Equipement> listRegulateur = bodyRegulateur.map((e) => Equipement.fromJson(e)).toList();

                      List<dynamic> bodyOnduleur = snapshot.data!["listOnduleurs"];
                      List<Equipement> listOnduleurs = bodyOnduleur.map((e) => Equipement.fromJson(e)).toList();

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5,bottom: 5),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromRGBO(29, 29, 119, 1),
                                    width: 1
                                  ),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                child: Text(
                                  widget.dimensionnement.description!,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Date : ",
                                    style: TextStyle(
                                        fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.dimensionnement.date!,
                                    style: const TextStyle(
                                        fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: Text(
                                  "Résultats",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5,bottom: 5),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromRGBO(29, 29, 119, 1),
                                        width: 1
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          "Puissance crête panneau : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.dimensionnement.puissanceCrete!} wh",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Capacité total des battéries : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.dimensionnement.capaciteBatterie!} Ah",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Puissance régulateur : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.dimensionnement.puissanceRegulateur!} watt",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Puissance onduleur : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.dimensionnement.puissanceOnduleur!} watt",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Tension de travail : ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "${widget.dimensionnement.tensionTravail!} volts",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5,bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Vos appareils renseignés",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ListDetailElement(titre: "Appareils renseignés",isAppareil: true,listAppareil: appareilList,),));},
                                      icon: const Icon(Icons.chevron_right, color: Colors.black, size: 30,)
                                    )
                                  ],
                                )
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  "Equipements proposés",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              _buildEquipementProposeCard(panneau, "dim_icon.png", panneauInfo["number"],"Panneau",listPanneau),
                              _buildEquipementProposeCard(batterie, "batterie_icon.png", batterieInfo["number"],"Batterie",listBatterie),
                              _buildEquipementProposeCard(regulateur, "regulateur_icon.png", regulateurInfo["number"], "Régulateur",listRegulateur),
                              _buildEquipementProposeCard(onduleur, "onduleur_icon.png", onduleurInfo["number"], "Onduleur",listOnduleurs),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Text(
                                  "Electricien proposés",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              CardElectricienDimensionnement(electricien:widget.dimensionnement.electricien!,notePojo: notePojo)
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildEquipementProposeCard(Equipement equipement,String imgPath,int quantite,String titre,List<Equipement> list){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              width: 1,
              color: const Color.fromRGBO(29, 29, 119, 1)
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              CircleAvatar(
                backgroundColor: const Color.fromRGBO(29, 29, 119, 1),
                child: Image.asset("assets/images/$imgPath",scale: 5,),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                const Text("Puissance : "),
                Text("${equipement.puissance} watt",style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Row(
            children: [
              const Text("Tension : "),
              Text("${equipement.tension} volts",style : const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            children: [
              const Text("Intensité : "),
              Text("${equipement.intensite} Ampère", style : const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            children: [
              const Text("Quantité : "),
              Text("$quantite", style : const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ListDetailElement(titre: titre, isAppareil: false, listEquipement: list,),));},
                child: const Icon(Icons.remove_red_eye,color: Color.fromRGBO(29, 29, 119, 1),),
              )
            ],
          )
        ],
      ),
    );
  }



}
