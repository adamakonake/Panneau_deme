import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/model/electricien.dart';
import 'package:panneau_deme/model/notePojo.dart';
import 'package:provider/provider.dart';

import '../services/dimensionnementService.dart';

class CardElectricienDimensionnement extends StatefulWidget {
  const CardElectricienDimensionnement({super.key, required this.electricien, required this.notePojo});

  final Electricien electricien;
  final NotePojo notePojo;

  @override
  State<CardElectricienDimensionnement> createState() => _CardElectricienDimensionnementState();
}

class _CardElectricienDimensionnementState extends State<CardElectricienDimensionnement> {

  late Electricien electricien;
  late NotePojo notePojo;

  @override
  void initState() {
    super.initState();
    electricien = widget.electricien;
    notePojo = widget.notePojo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                blurRadius: 5,
                offset: Offset(0, 0)
            )
          ],
          color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color.fromRGBO(29, 29, 119, 1),
                      width: 2
                  ),
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("http://10.0.2.2${electricien.photo}"),
                    radius: 30,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RichText(
                      //softWrap: true,
                        text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: "Nom : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  )
                              ),
                              TextSpan(
                                  text: "${electricien.nom}",
                                  style: const TextStyle(
                                      color: Colors.black
                                  )
                              )
                            ]
                        )
                    ),
                  ),
                  RichText(
                    //softWrap: true,
                      text: TextSpan(
                          children: [
                            const TextSpan(
                                text: "Prenom : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                            TextSpan(
                                text: "${electricien.prenom}",
                                style: const TextStyle(
                                    color: Colors.black
                                )
                            )
                          ]
                      )
                  )
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7,bottom: 7),
            child: RichText(
              //softWrap: true,
                text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Experience : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                      ),
                      TextSpan(
                          text: "${electricien.experience} an(s)",
                          style: const TextStyle(
                              color: Colors.black
                          )
                      )
                    ]
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: RichText(
              //softWrap: true,
                text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Email : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                      ),
                      TextSpan(
                          text: "${electricien.email}",
                          style: const TextStyle(
                              color: Colors.black
                          )
                      )
                    ]
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: RichText(
              //softWrap: true,
                text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Tel : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          )
                      ),
                      TextSpan(
                          text: "${electricien.telephone}",
                          style: const TextStyle(
                              color: Colors.black
                          )
                      )
                    ]
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              children: [
                const Expanded(
                    flex: 1,
                    child: Text(
                        "Notez : ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                        )
                    )
                ),
                Expanded(
                    flex: 6,
                    child: RatingBar.builder(
                      initialRating: notePojo.valeur!,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: 16,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
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
                        notePojo.valeur = rating;
                        Provider.of<DimensionnementService>(context,listen: false).noteElectricien(notePojo).then((value) {
                          Navigator.pop(context);
                        }).catchError((onError){
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
                        });
                      },
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}
