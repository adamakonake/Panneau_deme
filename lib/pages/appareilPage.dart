import 'package:flutter/material.dart';
import 'package:panneau_deme/model/appareil.dart';
import 'package:panneau_deme/services/appareilService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:panneau_deme/widget/addAppareilDialog.dart';
import 'package:panneau_deme/widget/deleteAppareilDialog.dart';
import 'package:provider/provider.dart';

import '../widget/draggableFabutton.dart';

class AppareilPage extends StatefulWidget {
  const AppareilPage({super.key});

  @override
  State<AppareilPage> createState() => _AppareilPageState();
}

class _AppareilPageState extends State<AppareilPage> {

  final GlobalKey _parentKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final _searchInputController = TextEditingController();
  //late ScrollController _scrollController; //Pour la fnction scroll


  @override
  void initState() {
    //_scrollController = ScrollController(); //Pour la fnction scroll
    //_scrollController.addListener(_scrollListener); //Pour la fnction scroll
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        key: _parentKey,
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
                    "Mes appareils",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
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
                                    child: const Text("Recherche appareil",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            child: TextFormField(
                                              controller: _searchInputController,
                                              /*validator: (value) {
                                                if(value == null || value.isEmpty){
                                                  return "remplissez le champs";
                                                }
                                                return null;
                                              },*/
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding: EdgeInsets.only(bottom: 5.0, left: 10.0)
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              if(_formKey.currentState!.validate()){
                                                Provider.of<AppareilService>(context,listen: false).applySearch(_searchInputController.text);
                                                _formKey.currentState!.reset();
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                              margin: const EdgeInsets.only(top: 30,left: 30,right: 30),
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(29, 29, 119, 1),
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: const Center(
                                                child: Text("Rechercher",style: TextStyle(color: Colors.white),),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        );
                      },
                      icon: const Icon(Icons.search_rounded,color: Colors.white,size: 35)
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 19),
            margin: const EdgeInsets.only(top: 51),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(19)
              ),
              color: Colors.white
            ),
            child: Consumer<AppareilService>(
              builder: (context, appareilService, child) {
                return FutureBuilder(
                  future: appareilService.getAppareils(Provider.of<UserService>(context,listen: false).currentUser.idUtilisateur!),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if(snapshot.hasError){
                      /*showDialog(
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
                      );*/
                    }

                    if(!snapshot.hasData){
                      return const Center(
                        child: Text("Aucun appareil trouvé"),
                      );
                    }

                    if(snapshot.data!.isEmpty){
                      return const Center(
                        child: Text("Aucun appareil trouvé"),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async{
                        setState(() {

                        });
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildCardAppareil(snapshot.data![index],index);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          DraggableFloatingActionButton(
            initialOffset: const Offset(120, 70),
            parentKey: _parentKey,
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: const AddAppareilDialog(ajout: true,),
                )
              );
            },
            child: FloatingActionButton(
              onPressed: (){},
              backgroundColor: const Color.fromRGBO(29, 29, 119, 1),
              shape: const CircleBorder(),
              tooltip: 'Ajouter un appareil',
              child: const Icon(Icons.add,color: Colors.white,size: 30,),
            ),
          )
        ],
      )
    );
  }
  
  _buildCardAppareil(Appareil appareil,int index){
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: (){
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: AddAppareilDialog(appareil: appareil,ajout: false),
                      )
                  );
                },
                icon: Image.asset("assets/icon/edit_icon.png",scale: 5),
                padding: const EdgeInsets.all(0),
              ),
              IconButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: DeleteAppareilDialod(idAppareil: appareil.idAppareil!),
                      )
                  );
                },
                icon: Image.asset("assets/icon/delete_icon.png",scale: 5),
                padding: const EdgeInsets.all(0),
              )
            ],
          )
        ],
      ),
    );
  }

  //Fonction pour capter le scroll en bas ou haut
  /*_scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
      });
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
      !_scrollController.position.outOfRange) {
      setState(() {});
    }
  }*/
  
}
