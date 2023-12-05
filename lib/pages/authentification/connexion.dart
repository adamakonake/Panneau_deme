import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/pages/reset_password/forgotPage.dart';
import 'package:panneau_deme/pages/reset_password/resetPwdPage.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

import 'package:panneau_deme/services/authPageService.dart';

import '../accueil.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  //Les informations de l'utilisateur
  String _email = "";
  String _mot_de_passe = "";
  bool _obscureText = true;
  bool _emailError = false;
  bool _passError = false;

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
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
                      margin: const EdgeInsets.only(left: 15.0,right: 15.0),
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
                                      "connectez-vous",
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
                                    padding: const EdgeInsets.only(top: 15, bottom: 7.5),
                                    child: TextFormField(
                                      validator: (value) {
                                        if(value == null || value.isEmpty){
                                          return "Veuilez remplir le champs";
                                        }
                                        _email = value;
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: "Email",
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                        errorText: _emailError ? "Email incorrect" : null
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 7.5,bottom: 5.0),
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
                                        border: const OutlineInputBorder(),
                                        labelText: "Mot de passe",
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                        suffixIcon: IconButton(
                                          onPressed: (){_toggle();},
                                          icon: _obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                        ),
                                        errorText: _passError ? "Mot de passe incorrect" : null
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0,bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () async{
                                        if(_formKey.currentState!.validate()){
                                          if(_passError || _emailError){
                                            setState(() {
                                              _emailError = false;
                                              _passError = false;
                                            });
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
                                          await Provider.of<UserService>(context, listen: false).connectUser(_email, _mot_de_passe).then((value) {
                                            Navigator.pop(context);
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const Accueil()),(route)=> false);
                                          }).catchError((onError){
                                            Navigator.pop(context);
                                            debugPrint(onError.toString());
                                            if(onError.toString().replaceAll("Exception: ", "") == "email invalid"){
                                              setState(() {
                                                _emailError = true;
                                              });
                                            }else if(onError.toString().replaceAll("Exception: ", "") == "pass invalid"){
                                              setState(() {
                                                _passError = true;
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
                                        padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
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
                                            "Connexion",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
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
                                      "Vous n'avez pas de compte ?",
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
                                      Provider.of<AuthPageService>(context,listen: false).changeIndex(1);
                                    },
                                    child: const Text(
                                        "inscrivez-vous",
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
            Padding(
              padding: const EdgeInsets.only(top: 50,bottom: 15),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPage()));
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                          color: Color.fromRGBO(29, 29, 119, 1)
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
