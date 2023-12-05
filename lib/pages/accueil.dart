import 'package:flutter/material.dart';
import 'package:panneau_deme/pages/appareilPage.dart';
import 'package:panneau_deme/pages/authentification/authPage.dart';
import 'package:panneau_deme/pages/dimensionnementPage.dart';
import 'package:panneau_deme/pages/electricienPage.dart';
import 'package:panneau_deme/pages/equipementPage.dart';
import 'package:panneau_deme/pages/historiquePage.dart';
import 'package:panneau_deme/pages/profilPage.dart';
import 'package:panneau_deme/services/meteoService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 270,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/auth_background.jpg"),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(50.0)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Consumer<UserService>(
                      builder: (context, userService, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60,bottom: 5),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfilPage()));
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color.fromRGBO(253, 184, 19, 1),
                                  child: Text(
                                    "${userService.currentUser.prenom!.substring(0,1)} ${userService.currentUser.nom!.substring(0,1)}",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${userService.currentUser.prenom!.substring(0,1).toUpperCase()}${userService.currentUser.prenom!.substring(1).toLowerCase()} "
                              "${userService.currentUser.nom!.substring(0,1).toUpperCase()}${userService.currentUser.nom!.substring(1).toLowerCase()}",
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top:0),
                              child: Consumer<MeteoService>(
                                builder: (context, meteoService, child) {
                                  return FutureBuilder(
                                    future: meteoService.getTemperature(),
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting){
                                        return const CircularProgressIndicator();
                                      }

                                      if(snapshot.hasError){
                                        debugPrint(snapshot.error.toString());
                                        /*ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(snapshot.error.toString()))
                                        );*/
                                        return IconButton(
                                          onPressed: (){
                                            Provider.of<MeteoService>(context,listen: false).applyChange();
                                          },
                                          icon: const Icon(Icons.restart_alt,color: Colors.white),
                                        );
                                      }

                                      if(!snapshot.hasData){
                                        return const Text(
                                          "Service indisponnible",
                                          style: TextStyle(color: Colors.white),
                                        );
                                      }

                                      return Text(
                                        "${snapshot.data!}°C",
                                        style: const TextStyle(
                                          fontSize: 53,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white
                                        ),
                                      );

                                    },
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                    child: Text(
                      "PANNEAU DEME",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0,left: 15.0,right: 15.0),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    //crossAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildCardAccueil("Appareil", "appareil_icon.png", true,const AppareilPage()),
                      _buildCardAccueil("Historique", "historique_icon.png", false,const HistoriquePage()),
                      _buildCardAccueil("Equipement", "equipement_icon.png", false,const EquipementPage()),
                      _buildCardAccueil("Electricien", "electricien_icon.png", true,const ElectricienPage())
                    ],
                  ),
                  _buildCardAccueil("Faire un\ndimensionnement", "dim_icon.png", false,const DimensionnementPage()),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Voulez-vous vraiment vous\ndeconnecer ?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          overflow: TextOverflow.visible
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 30.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                Provider.of<UserService>(context, listen: false).removeUserFromSharedPreferences().then((value) {
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const AuthPage()),(route)=>false);
                                                }).catchError((onError){print(onError);});
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(253, 184, 19, 1),
                                                  borderRadius: BorderRadius.circular(3)
                                                ),
                                                child: const Text(
                                                  "OUI",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(29, 29, 119, 1),
                                                  borderRadius: BorderRadius.circular(3)
                                                ),
                                                child: const Text(
                                                  "NON",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            )
                          );
                        },
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: const Color.fromRGBO(29, 29, 119, 1),
                          child: Image.asset("assets/images/out_icon.png",scale: 5,),
                        ),
                      )
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _buildCardAccueil(String nom,String imagePath,bool jaune,Widget? page){
    return InkWell(
      onTap: (){
        if(page != null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
      highlightColor: jaune ? const Color.fromRGBO(255, 234, 48, 0.5) : const Color.fromRGBO(29, 29, 119, 0.5),
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 18,
        color: !jaune ? Colors.white : const Color.fromRGBO(255, 234, 48, 1),
        surfaceTintColor: !jaune ? Colors.white : const Color.fromRGBO(255, 234, 48, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 10.0,top: 10.0),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(29, 29, 119, 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Image.asset("assets/images/$imagePath",scale: 5,),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0,bottom: 10),
                  child: Text(
                    nom,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(29, 29, 119, 1)
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
