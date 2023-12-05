import 'package:flutter/material.dart';
import 'package:panneau_deme/model/electricien.dart';
import 'package:panneau_deme/services/electricienService.dart';
import 'package:panneau_deme/widget/cardElectricien.dart';
import 'package:provider/provider.dart';

class ElectricienPage extends StatefulWidget {
  const ElectricienPage({super.key});

  @override
  State<ElectricienPage> createState() => _ElectricienPageState();
}

class _ElectricienPageState extends State<ElectricienPage> {
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
                      "Electriciens",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white
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
              child: Consumer<ElectricienService>(
                builder: (context, electricienService, child) {
                  return FutureBuilder(
                    future: electricienService.getElectriciens(),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if(snapshot.hasError){

                      }

                      if(!snapshot.hasData){
                        return const Center(
                          child: Text("Aucun appareil trouvé"),
                        );
                      }

                      List<dynamic> list = snapshot.data!["electriciens"];
                      List<dynamic> notes = snapshot.data!["notes"];
                      List<Electricien> electriciens = list.map((dynamic item) => Electricien.fromJson(item)).toList();
                      print(electriciens[0]);

                      return RefreshIndicator(
                        onRefresh: () async{
                          setState(() {

                          });
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: electriciens.length,
                          itemBuilder: (context, index) {
                            return CardElectricien(electricien: electriciens[index],index: index,note: notes[index],);
                          },
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
}
