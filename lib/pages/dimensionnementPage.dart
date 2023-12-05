import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:panneau_deme/model/appareil.dart';
import 'package:panneau_deme/model/dimensionnement.dart';
import 'package:panneau_deme/pages/dimensionnementDetailPage.dart';
import 'package:panneau_deme/services/dimensionnementService.dart';
import 'package:panneau_deme/services/meteoService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:panneau_deme/widget/dimensionnementAppareilList.dart';
import 'package:provider/provider.dart';

class DimensionnementPage extends StatefulWidget {
  const DimensionnementPage({super.key});

  @override
  State<DimensionnementPage> createState() => _DimensionnementPageState();
}

class _DimensionnementPageState extends State<DimensionnementPage> with SingleTickerProviderStateMixin{

  late final AnimationController animationController;
  final _formKey = GlobalKey<FormState>();
  String _description = "";
  bool _descError = false;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<DimensionnementService>(context,listen: false).dimAppareils = [];
  }

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
                      "Formulaire de dimensionnement",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                        overflow: TextOverflow.visible
                      ),
                    ),
                    const SizedBox(width: 40,)
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
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.only(left: 15,right: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 0),
                            blurRadius: 10
                          )
                        ]
                      ),
                      child: TextFormField(
                        maxLines: 2,
                        maxLength: 200,
                        validator: (value) {
                          if(value == null || value.isEmpty){
                            return "Veuillez saisir une description";
                          }
                          if(value.length < 10){
                            return "Nombre de caractère inferieure à dix";
                          }
                          _description = value;
                          return null;
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Description",
                          errorText: _descError ? "Cet dimensionnement exist déjà" : null
                        ),
                      ),
                    ),
                  ),
                  Consumer<DimensionnementService>(
                    builder: (context, dimensionnementService, child) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: dimensionnementService.dimAppareils.length,
                          itemBuilder: (context, index) {
                            return _buildCardAppareil(dimensionnementService.dimAppareils[index],index);
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 35),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) => Stack(
            children: [
              Positioned(
                  left: MediaQuery.sizeOf(context).width - (MediaQuery.sizeOf(context).width * animationController.value),
                  child: FloatingActionButton(
                    heroTag: "valider",
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        if(Provider.of<DimensionnementService>(context,listen: false).dimAppareils.length<2){
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(15.0),
                                      child: const Text(
                                        "Veuillez selectionner au moins deux appareils",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                          return ;
                        }

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
                        Dimensionnement dimensionnement = Dimensionnement();
                        dimensionnement.description = _description;
                        Position position = Provider.of<MeteoService>(context,listen: false).position;
                        print(position);
                        await Provider.of<DimensionnementService>(context,listen: false).addDimensionnement(_description, position,
                        Provider.of<UserService>(context,listen: false).currentUser.idUtilisateur!).then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> DimensionnementDetailPage(dimensionnement: value)));
                        }).catchError((onError){
                          Navigator.pop(context);
                          if(onError.toString().replaceAll("Exception: ", "") == "exist"){
                            setState(() {
                              _descError = true;
                            });
                          }else{
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(15.0),
                                        child: Text(
                                          onError.toString(),
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
                    },
                    backgroundColor: const Color.fromRGBO(29, 29, 119, 1),
                    shape: const CircleBorder(),
                    tooltip: 'Valider',
                    child: const Icon(Icons.check,color: Colors.white,size: 30,),
                  )
              ),
              Positioned(
                  right: 0 ,
                  child: FloatingActionButton(
                    heroTag: "ajouter",
                    onPressed: (){
                      showModalBottomSheet(
                        enableDrag: false,
                        isDismissible: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => const DimensionnementAppareilList()
                      );
                    },
                    backgroundColor: const Color.fromRGBO(29, 29, 119, 1),
                    shape: const CircleBorder(),
                    tooltip: 'Ajouter un appareil',
                    child: const Icon(Icons.add,color: Colors.white,size: 30,),
                  )
              ),
            ],
          ),
        ),
      ),
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
        ],
      ),
    );
  }

}
