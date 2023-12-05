import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:panneau_deme/model/utilisateur.dart';
import 'package:panneau_deme/pages/reset_password/resetPwdPage.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';

import '../accueil.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key, this.utilisateur, this.email,required this.code, required this.action });

  final Utilisateur? utilisateur;
  final String? email;
  final String code;
  final String action;

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {

  bool _codeError = false;
  bool _enableResendCode = false;
  Timer? _countdownTimer;
  Duration _duration = const Duration(minutes: 2);
  String _code = "";


  @override
  void initState() {
    super.initState();
    _startTimer();
    _code = widget.code;
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2,'0');
    final minutes = strDigits(_duration.inMinutes.remainder(60));
    final seconds = strDigits(_duration.inSeconds.remainder(60));
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
                "Code de vérification",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5,bottom: 30),
              child: Text(
                "Entrez le code de vérification è six (6)\nqui vous a été envoyer à votre\nadresse email",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, left: 40.0, right: 40.0),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    width: 1.0,
                    color: _codeError ? Colors.red : const Color.fromRGBO(29, 29, 119, 1)
                  )
                )
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "######",
                  contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                  errorText: _codeError ? "Code incorrect" : null
                ),
                textAlign: TextAlign.center,
                onChanged: (value){
                  if(_codeError){
                    setState(() {
                      _codeError = false;
                    });
                  }
                  if(value.length == 6){
                    if(value == _code){
                      if(widget.action == "ajout"){
                        _saveUser();
                      }else{
                        _code = "";
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPwdPage(email: widget.email!)));
                      }
                    }else{
                      setState(() {
                        _codeError = true;
                      });
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: GestureDetector(
                onTap: (){
                  if(_enableResendCode) {
                    _resendCode();
                  }
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                          children: [
                            TextSpan(
                                text: "Réenvoyer le code ",
                                style: TextStyle(
                                  color: _enableResendCode ? const Color.fromRGBO(29, 29, 119, 1) : Colors.grey
                                )
                            ),
                            !_enableResendCode ? TextSpan(
                              text: "$minutes:$seconds",
                              style: const TextStyle(
                                color: Colors.black
                              )
                            ) : const TextSpan()
                          ]
                      )
                    ]
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Center(
                child: Image.asset(
                    "assets/images/logo_for_forgot_page.png"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
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

  _saveUser() async{
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
    await Provider.of<UserService>(context,listen: false).saveUser(widget.utilisateur!).then((value) {
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const Accueil()),(route)=> false);
    }).catchError((onError){
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

  void _startTimer(){
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) => _setCountDown());
  }

  void _setCountDown(){
    const reductionSeconds = 1;
    setState(() {
      final seconds = _duration.inSeconds - reductionSeconds;
      if(seconds < 0){
        _countdownTimer!.cancel();
        _enableResendCode = true;
      }else{
        _duration = Duration(seconds: seconds);
      }
    });
  }

  _resendCode() async{
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

    await Provider.of<UserService>(context,listen: false).verifUserMail(widget.email!).then((value) {
      Navigator.pop(context);
      setState(() {
        _code = value;
        _enableResendCode = false;
        _duration = const Duration(minutes: 2);
        _startTimer();
      });
    }).catchError((onError){
      Navigator.pop(context);
      debugPrint(onError.toString());
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
