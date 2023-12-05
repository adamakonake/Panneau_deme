import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/services/dimensionnementService.dart';
import 'package:provider/provider.dart';

import '../model/appareil.dart';
import '../services/appareilService.dart';
import '../services/userService.dart';

class DimensionnementAppareilList extends StatefulWidget {
  const DimensionnementAppareilList({super.key});

  @override
  State<DimensionnementAppareilList> createState() => _DimensionnementAppareilListState();
}

class _DimensionnementAppareilListState extends State<DimensionnementAppareilList> {

  List<Appareil> _listAppareils = [];
  List<Appareil> _searchResult = [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _fetchAppareilsData();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.91,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(3)
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 40,right: 40,top: 15,bottom: 15),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [0.2,0.2],
                            colors: [
                              Color.fromRGBO(29, 29, 119, 1),
                              Color.fromRGBO(255, 255, 255, 1)
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.2),
                              blurRadius: 10
                          ),
                        ]
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Icon(Icons.search, color: Colors.white,size: 30,),
                        ),
                        Expanded(
                          flex: 4,
                          child: TextField(
                            onChanged: (value) {
                              _searchAppareil(value);
                            },
                            decoration: const InputDecoration(
                              hintText: "Recherche",
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(0, 0, 0, 0.25)
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10)
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            _loading ?
                const Center(
                  child: CircularProgressIndicator(),
                ) :
                _error ?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Erreur serveur veuillez verifier votre connexion internet ou réessayer plus tard",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                        IconButton(
                          onPressed: (){
                            _fetchAppareilsData();
                          },
                          icon: const Icon(Icons.restart_alt,color: Colors.white,size: 30,)
                        )
                      ],
                    ) :
            _searchResult.isEmpty ?
            const Center(
              child: Text("Aucun appareil trouvé"),
            ) :
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  setState(() {
                    _loading = true;
                    _error = false;
                    _fetchAppareilsData();
                  });
                },
                child: ListView.builder(
                  //controller: scrollController,
                  itemCount: _searchResult.length,
                  itemBuilder: (context, index) {
                    return _buildCardAppareil(_searchResult[index],index);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCardAppareil(Appareil appareil,int index){
    return Consumer<DimensionnementService>(
      builder: (context, dimensionnementService, child) {
        Appareil? appareilVerif = dimensionnementService.dimAppareils.where((element) => element.nom == appareil.nom).firstOrNull;
        return Container(
          margin: index == 0 ? const EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 10) : const EdgeInsets.only(left: 15,right: 15,bottom: 15),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  offset: Offset(0.0, 0.0),
                  blurRadius: 5
              )
            ],
          ),
          child: ListTile(
            onTap: (){
              _selectAppareil(appareil);
            },
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              decoration:  appareilVerif != null ?
              const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(29, 29, 119, 1)
              ) : const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(29, 29, 119, 0.25)
              ),
              child: const Icon(Icons.check,color: Colors.white,size: 30,),
            ),
            title: Text(
              "${appareil.nom}",
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                      "Quantité : ${appareil.quantite}"
                  ),
                ),
                Expanded(
                  child: Text(
                      "Puissance : ${appareil.puissance} watt"
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _fetchAppareilsData() async{
    await Provider.of<AppareilService>(context,listen: false).getAppareils(Provider.of<UserService>(context,listen: false).currentUser.idUtilisateur!).then((value) {
      setState(() {
        _loading = false;
        _error = false;
        _listAppareils = value;
        _searchResult = value;
      });
    }).catchError((onError){
      setState(() {
        _error = true;
        _loading = false;
      });
    });
  }

  void _selectAppareil(Appareil appareil){
    Provider.of<DimensionnementService>(context,listen: false).updateListAppareil(appareil);
  }

  void _searchAppareil(String query){
    setState(() {
      _searchResult = _listAppareils.where((element) => element.nom!.
      toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  /*bool _verifAppareil(Appareil appareil){
    Appareil? appareilVerif = Provider.of<DimensionnementService.>(context,listen: false).where((element) => element.nom == appareil.nom).firstOrNull;
    if(appareilVerif != null) {
      dimAppareils.remove(appareil);
    }else{
      dimAppareils.add(appareil);
    }
  }*/

}
