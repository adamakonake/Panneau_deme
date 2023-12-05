import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:panneau_deme/model/utilisateur.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {

  final String _apiUrl = "http://10.0.2.2:8080/utilisateur";

  //Utilisateur currentUser = Utilisateur(idUtilisateur: 1,nom: "KONAKE",prenom: "Adama",email: "adamakonake@gmail.com",motDePasse: "adama123");
  late Utilisateur currentUser ;

  Future<String> connectUser(String email,String password) async {
    debugPrint("$email $password");
    Map<String,dynamic> credential = {
      "email" : email,
      "password" : password
    };
    final response = await http.post(
        Uri.parse("$_apiUrl/connect"),
        headers: {'Content-Type' : 'application/json; charset=UTF-8'},
        body: jsonEncode(credential)
    );

    if(response.statusCode == 200){
      currentUser = Utilisateur.fromJsno(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      await addUserToSharedPreferences(currentUser);
      return "succes";
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }

  }

  Future<String> verifNewUserMail(String email) async{
    final response = await http.get(Uri.parse("$_apiUrl/verifnewmail?email=$email"));

    if(response.statusCode == 200){
      return jsonDecode(utf8.decode(response.bodyBytes))['message'];
    }else{
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }

  }

  Future<String> saveUser(Utilisateur user) async{
    debugPrint("${user.toMap()}");
    final response = await http.post(
      Uri.parse("$_apiUrl/create"),
      headers: <String,String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(user.toMap())
    );

    if(response.statusCode == 200){
      currentUser = Utilisateur.fromJsno(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      await addUserToSharedPreferences(currentUser);
      return "succes";
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }

  }

  Future<String> updateUser(Utilisateur utilisateur, String ancien) async {
    Map<String,dynamic> bodyRequest;
    if(ancien.isEmpty){
      bodyRequest = {
        "user" : jsonEncode(utilisateur.toMap())
      };
    }else{
      bodyRequest = {
        "user" : jsonEncode(utilisateur.toMap()),
        "oldPass" : ancien
      };
    }

    final response = await http.put(
        Uri.parse("$_apiUrl/update"),
        //headers: <String,String>{'Content-Type' : 'multipart/form_data'},
        body: bodyRequest
    );

    if(response.statusCode == 200){
      print(response.body);
      currentUser = Utilisateur.fromJsno(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      await addUserToSharedPreferences(currentUser);
      applyChange();
      return "succes";
    }else{
      print(response.body);
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }

  Future<String> verifUserMail(String email) async{
    final response = await http.get(Uri.parse("$_apiUrl/verifmail?email=$email"));

    if(response.statusCode == 200){
      return jsonDecode(utf8.decode(response.bodyBytes))['message'];
    }else{
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }

  }

  Future<String> resetPassword(String email, String password) async{
    final response = await http.put(Uri.parse("$_apiUrl/resetpassword?email=$email&password=$password"));

    if(response.statusCode == 200){
      currentUser = Utilisateur.fromJsno(jsonDecode(utf8.decode(response.bodyBytes))['data']);
      await addUserToSharedPreferences(currentUser);
      applyChange();
      return "succes";
    }else{
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }

  }

  Future<String> addUserToSharedPreferences(Utilisateur utilisateur) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("currentUser", jsonEncode(utilisateur.toMap()));
    return "succes";
  }

  Future<String?> getUserFromSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("currentUser");
    if(userString != null) {
      currentUser = Utilisateur.fromJsno(jsonDecode(userString!));
      return "succec";
    }else{
      throw Exception("error");
    }
  }

  Future<String> removeUserFromSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("currentUser");
    currentUser = Utilisateur();
    return "succes";
  }



  void applyChange(){
    notifyListeners();
  }

}