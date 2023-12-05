import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/pages/authentification/authPage.dart';
import 'package:provider/provider.dart';

import '../../services/userService.dart';

class ResetPwdPage extends StatefulWidget {
  const ResetPwdPage({super.key, required this.email});

  final String email;

  @override
  State<ResetPwdPage> createState() => _ResetPwdPageState();
}

class _ResetPwdPageState extends State<ResetPwdPage> {

  final _formKey = GlobalKey<FormState>();
  String _mot_de_passe = "";
  String _confirmation = "";
  bool _obscureText = true;

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 60),
              child: Text(
                "Créer un nouveau mot\nde passe",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                "Veuiilez entre un nouveau mot de passe,\nelle doit contenir au moins\nsix (6) caractères",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100,left: 30,right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      obscureText: _obscureText,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Saisisser votre mot de passe";
                        }
                        _mot_de_passe = value;
                        return null ;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Mot de passe",
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                        suffixIcon: IconButton(
                          onPressed: (){_toggle();},
                          icon: _obscureText ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        obscureText: _obscureText,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Confirmer votre mot de passe";
                          }
                          if(value != _mot_de_passe){
                            return "Incorrect";
                          }
                          _confirmation = value;
                          return null ;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirmation",
                            contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: GestureDetector(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            _resetPass();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
                          color: const Color.fromRGBO(29, 29, 119, 1),
                          child: const Center(
                            child: Text(
                              "Réinitialiser",
                              style: TextStyle(
                                  fontSize: 20,
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
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back,color: Color.fromRGBO(29, 29, 119, 1), size: 16,),
                    Text(
                      " Retour",
                      style: TextStyle(
                          fontSize: 16,
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

  _resetPass() async{
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

    await Provider.of<UserService>(context,listen: false).resetPassword(widget.email,_mot_de_passe).then((value) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const AuthPage()),(route) => false);
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
    });
  }
}
