import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:panneau_deme/model/electricien.dart';

class CardElectricien extends StatelessWidget {
  const CardElectricien({super.key, required this.electricien, required this.index, required this.note});

  final Electricien electricien;
  final int index;
  final double note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: index == 0 ? const EdgeInsets.only(left: 15,right: 15,bottom: 15,top: 10) : const EdgeInsets.only(left: 15,right: 15,bottom: 15),
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
                    "Note : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    )
                  )
                ),
                Expanded(
                  flex: 6,
                  child: RatingBarIndicator(
                    rating: note,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 16,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    direction: Axis.horizontal,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
