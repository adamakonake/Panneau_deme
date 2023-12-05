import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/pages/reset_password/validationPage.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {

  final _formKey = GlobalKey<FormState>();
  bool _emailInvalid = false;
  String _email = "";

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
                "Mot de passe oublié ?",
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
                "Entrez vôtre adresse email avec lequel\nvous avez enregistrer votre compte\net nous vous enverons un email\nde confirmation pour réinitialiser\nvotre compte",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 70),
              child: Center(
                child: Image.asset(
                  "assets/images/logo_for_forgot_page.png"
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40,left: 30,right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Saisisser votre email";
                        }
                        _email = value;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Email",
                        contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                        errorText: _emailInvalid ? "Email invalid" : null
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: GestureDetector(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            _verifMail();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
                          color: const Color.fromRGBO(29, 29, 119, 1),
                          child: const Center(
                            child: Text(
                              "Envoyer code",
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
              padding: EdgeInsets.only(top: 70),
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

  _verifMail() async{

    if(_emailInvalid){
      setState(() {
        _emailInvalid = false;
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

    await Provider.of<UserService>(context,listen: false).verifUserMail(_email).then((value) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ValidationPage(code: value,email: _email, action: "reset")));
    }).catchError((onError){
      Navigator.pop(context);
      debugPrint(onError.toString());
      if(onError.toString().replaceAll("Exception: ", "") == "invalid"){
        setState(() {
          _emailInvalid = true;
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

}
