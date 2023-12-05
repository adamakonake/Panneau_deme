import 'package:flutter/material.dart';
import 'package:panneau_deme/model/dimensionnement.dart';
import 'package:panneau_deme/pages/dimensionnementDetailPage.dart';
import 'package:panneau_deme/services/dimensionnementService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {

  final _formKey = GlobalKey<FormState>();
  final _searchInputController = TextEditingController();

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
                      "Historique",
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
                                      child: const Text("Recherche Dimensionnement",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
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
                                                  Provider.of<DimensionnementService>(context,listen: false).applySearch(_searchInputController.text);
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
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(19)
                  ),
                  color: Colors.white
              ),
              child: Consumer<DimensionnementService>(
                builder: (context, dimensionnementService, child) {
                  return FutureBuilder(
                    future: dimensionnementService.getDimensionnementByUserId(Provider.of<UserService>(context,listen: false).currentUser.idUtilisateur!),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if(snapshot.hasError){

                      }

                      if(!snapshot.hasData || snapshot.data!.isEmpty){
                        return const Center(
                          child: Text("Aucun dimensionnement trouvé"),
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
                            return _buildCardHistorique(snapshot.data![index]);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCardHistorique(Dimensionnement dimensionnement){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DimensionnementDetailPage(dimensionnement: dimensionnement)));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15,right: 15,bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 0),
              blurRadius: 10
            )
          ],
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              dimensionnement.description!,
              style: TextStyle(
                fontSize: 16
              ),
            ),
            const Divider(
              height: 20,
              color: Colors.white,
            ),
            Text(
              dimensionnement.date!,
              style: const TextStyle(
                fontSize: 12
              ),
              textAlign: TextAlign.end,
            )
          ],
        ),
      ),
    );
  }
}
