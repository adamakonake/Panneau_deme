import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/model/utilisateur.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  final _formKey = GlobalKey<FormState>();
  //Les informations de l'utilisateur
  String _nom = "";
  String _prenom = "";
  String _email = "";
  String _ancien_pass = "";
  String _mot_de_passe = "";
  String _confirmation = "";
  bool _obscureText = true;
  bool _onEditForm = false;
  bool _old_pass_error = false;
  //les controller des input
  final _nomInputControl = TextEditingController();
  final _prenomInputControl = TextEditingController();
  final _emailInputControl = TextEditingController();

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  void dispose() {
    super.dispose();
    _nomInputControl.dispose();
    _prenomInputControl.dispose();
    _emailInputControl.dispose();
  }


  @override
  void initState() {
    super.initState();
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
            Stack(
              alignment: const Alignment(0, 2.8),
              children: [
                Container(
                  height: 237,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/auth_background.jpg"),
                          fit: BoxFit.cover
                      )
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40,left: 40),
                        child: Text(
                          "PANNEAU",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            overflow: TextOverflow.visible
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
                            color: Colors.white,
                            overflow: TextOverflow.visible
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Consumer<UserService>(
                  builder: (context, userService, child) {
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color.fromRGBO(253, 184, 19, 1),
                          child: Text(
                            "${userService.currentUser.prenom!.substring(0,1)} ${userService.currentUser.nom!.substring(0,1)}",
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                            "${userService.currentUser.prenom!.substring(0,1).toUpperCase()}${userService.currentUser.prenom!.substring(1).toLowerCase()} "
                                "${userService.currentUser.nom!.substring(0,1).toUpperCase()}${userService.currentUser.nom!.substring(1).toLowerCase()}",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100,left: 15.0,right: 15.0),
              child: Column(
                children: [
                  Consumer<UserService>(
                    builder: (context, userService, child) {
                      _nomInputControl.text = userService.currentUser.nom!;
                      _prenomInputControl.text = userService.currentUser.prenom!;
                      _emailInputControl.text = userService.currentUser.email!;
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                controller: _nomInputControl,
                                readOnly: !_onEditForm,
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
                                controller: _prenomInputControl,
                                readOnly: !_onEditForm,
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
                                controller: _emailInputControl,
                                readOnly: true,
                                validator: (value) {
                                  if(value == null || value.isEmpty){
                                    return "Veuilez remplir le champs";
                                  }
                                  _email = value;
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Email",
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                                ),
                              ),
                            ),
                            _onEditForm ? Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                obscureText: true,
                                validator: (value) {

                                  if(value!.isNotEmpty && value.length < 6){
                                    return "Votre ancien mot de passe est inferieur à 6 chiffres";
                                  }
                                  _ancien_pass = value;
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: "Ancien mot de passe",
                                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                                  errorText: _old_pass_error ? "Mot de passe incorrect" : null
                                ),
                              ),
                            ) : const Center(),
                            _onEditForm ? Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if(value!.isNotEmpty && value!.length < 6){
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
                                ),
                              ),
                            ) : const Center(),
                            _onEditForm ? Padding(
                              padding: const EdgeInsets.only(top: 5.0,bottom: 20.0),
                              child: TextFormField(
                                obscureText: _obscureText,
                                validator: (value) {
                                  if(value != _mot_de_passe){
                                    return "Incorrect";
                                  }
                                  if(value != null)
                                    _confirmation = value;
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Confirmation",
                                    contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0)
                                ),
                              ),
                            ) : const Center(),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0,bottom: 10.0),
                              child: _onEditForm ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if(_formKey.currentState!.validate()){
                                        if(_old_pass_error){
                                          setState(() {
                                            _old_pass_error = false;
                                          });
                                        }
                                        Utilisateur utilisateur = Utilisateur(nom: _nom,prenom: _prenom,email: _email, motDePasse: _mot_de_passe);
                                        Utilisateur oldInfoUser = Provider.of<UserService>(context,listen: false).currentUser;
                                        utilisateur.idUtilisateur = oldInfoUser.idUtilisateur;
                                        if(_mot_de_passe.isEmpty){
                                          utilisateur.motDePasse = oldInfoUser.motDePasse;
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

                                        await userService.updateUser(utilisateur, _ancien_pass).then((value) {
                                          Navigator.pop(context);
                                          setState(() {
                                            _onEditForm = false;
                                          });
                                          showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      margin: const EdgeInsets.all(15.0),
                                                      child: const Text(
                                                        "Les informations de votre compte on été modifiées avec succès",
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.visible,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }).catchError((onError){
                                          print(onError);
                                          Navigator.pop(context);
                                          if(onError.toString().replaceAll("Exception: ", "") == "old invalid"){
                                            setState(() {
                                              _old_pass_error = true;
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
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                      margin: const EdgeInsets.only(left: 5.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(253, 184, 19, 1),
                                        borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "ENREGISTRE",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _onEditForm = false;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                      margin: const EdgeInsets.only(left: 5.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(29, 29, 119, 1),
                                        borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "ANNULER",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _onEditForm = true;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(253, 184, 19, 1),
                                        borderRadius: BorderRadius.circular(3)
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "MODIFIER",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
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
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
