import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/model/utilisateur.dart';
import 'package:panneau_deme/pages/accueil.dart';
import 'package:panneau_deme/pages/reset_password/validationPage.dart';
import 'package:panneau_deme/services/authPageService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  final _formKey = GlobalKey<FormState>();
  //Les informations de l'utilisateur
  String _nom = "";
  String _prenom = "";
  String _email = "";
  String _mot_de_passe = "";
  String _confirmation = "";
  bool _obscureText = true;
  bool _action = false;
  bool _emailExist = false;

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 464,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/auth_background.jpg"),
                  fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(10.0)
                )
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 130,left: 40),
                    child: Text(
                      "PANNEAU",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0,left: 190),
                    child: Text(
                      "DEME",
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: Card(
                elevation: 18,
                margin: const EdgeInsets.only(left: 15.0,right: 15.0,bottom: 30.0),
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "Bienvenue sur",
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                            ),
                          ),
                          Expanded(
                            child: Text(
                                " Panneau dèmè",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(253, 184, 19, 1)
                                )
                            ),
                          )
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                                "inscrivez-vous",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                          )
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  _nom = value;
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Nom",
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  _prenom = value;
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Prenom",
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: TextFormField(
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  _email = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email",
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                  errorText: _emailExist ? "Cet email existe déjà" : null,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  if(value.length < 6){
                                    return "Votre mot de passe est inferieur à 6 chiffres";
                                  }
                                  _mot_de_passe = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Mot de passe",
                                  contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                  suffixIcon: IconButton(
                                    onPressed: (){_toggle();},
                                    icon: _obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 20.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  if(value != _mot_de_passe){
                                    return "Incorrect";
                                  }
                                  _confirmation = value;
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Confirmation",
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if(_formKey.currentState!.validate()){
                                        Utilisateur utilisateur = Utilisateur(nom: _nom,prenom: _prenom,email: _email, motDePasse: _mot_de_passe);

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

                                        await Provider.of<UserService>(context,listen: false).verifNewUserMail(_email).then((value){
                                          Navigator.pop(context);
                                          _formKey.currentState!.reset();
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ValidationPage(code: value,utilisateur: utilisateur, action: "ajout")));
                                        }).catchError((onError){
                                          Navigator.pop(context);
                                          debugPrint(onError.toString());
                                          if(onError.toString().replaceAll("Exception: ", "") == "exist"){
                                            setState(() {
                                              _emailExist = true;
                                            });
                                          }else{
                                            showDialog(
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
                                            );
                                          }
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                              begin: Alignment(0,0),
                                              end: Alignment(1,0),
                                              colors: [
                                                Color.fromRGBO(29, 29, 119, 1),
                                                Color.fromRGBO(29, 29, 119, 0.75),
                                              ]
                                          )
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Inscription",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                                "Avez-vous déjà un compte ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Provider.of<AuthPageService>(context,listen: false).changeIndex(0);
                              },
                              child: const Text(
                                  "connectez-vous",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    color: Color.fromRGBO(253, 184, 19, 1)
                                  )
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
