import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/appareil.dart';

class AppareilService extends ChangeNotifier{

  final String _apiUrl = "http://10.0.2.2:8080/appareil";

  List<Appareil> appareils = [];
  String _searchQuery = "";
  bool _isSearch = false;
  
  Future<String> addAppareil(Appareil appareil) async{
    print(appareil.toMap());
    final response  = await http.post(
      Uri.parse("$_apiUrl/create"),
      headers: <String,String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(appareil.toMap())
    );

    if(response.statusCode == 200){
      applyChange();
      return "succes";
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }

  Future<List<Appareil>> getAppareils(int idUser) async{

    if(_isSearch){
      _isSearch = false;
      return appareils.where((element) => element.nom!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }else{
      final response = await http.get(Uri.parse("$_apiUrl/$idUser/appareils"));

      if(response.statusCode == 200){
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        appareils = body.map((dynamic item) => Appareil.fromJson(item)).toList();
        return appareils;
      }else{
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
      }
    }
  }

  Future<String> updateAppareil(Appareil appareil) async{
    print(appareil.toMap());
    final response  = await http.put(
        Uri.parse("$_apiUrl/update"),
        headers: <String,String>{'Content-Type' : 'application/json; charset=UTF-8'},
        body: jsonEncode(appareil.toMap())
    );

    if(response.statusCode == 200){
      applyChange();
      return "succes";
    }else{
      print(jsonDecode(utf8.decode(response.bodyBytes)));
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }

  Future<String> deleteAppareil(int idAppareil) async{
    final response = await http.delete(Uri.parse("$_apiUrl/delete/$idAppareil"));

    if(response.statusCode == 200){
      applyChange();
      return "succes";
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }


  void applySearch(String query){
    _isSearch = true;
    _searchQuery = query;
    applyChange();
  }

  void applyChange(){
    notifyListeners();
  }
}