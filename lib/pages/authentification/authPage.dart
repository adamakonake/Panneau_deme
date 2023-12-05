import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panneau_deme/model/utilisateur.dart';
import 'package:panneau_deme/pages/accueil.dart';
import 'package:panneau_deme/pages/authentification/connexion.dart';
import 'package:panneau_deme/pages/authentification/inscription.dart';
import 'package:panneau_deme/services/authPageService.dart';
import 'package:panneau_deme/services/userService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  //Liste widget inscription et connexion
  final List _pages = [
    const Connexion(),
    const Inscription()
  ];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthPageService>(builder: (context, authPageService, child) {
      return _pages[authPageService.index];
    },);
  }
}
