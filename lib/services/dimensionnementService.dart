import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:panneau_deme/model/dimensionnement.dart';
import 'package:http/http.dart' as http;
import 'package:panneau_deme/model/notePojo.dart';

import '../model/appareil.dart';

class DimensionnementService extends ChangeNotifier {

  final String _apiUrl = "http://10.0.2.2:8080/dimensionnement";
  final String _apiNoteUrl = "http://10.0.2.2:8080/note";

  List<Appareil> dimAppareils = [];

  String _searchQuery = "";
  bool _isSearch = false;
  List<Dimensionnement> _list = [];

  Future<Dimensionnement> addDimensionnement(String description,Position position,int idUser) async {
    //List<Map<String,dynamic>> listMap =
    Map<String,dynamic> info = {
      "description" : description,
      "coordonnee" : {
        "latitude" : position.latitude,
        "longitute" : position.longitude
      },
      "appareils" : dimAppareils.map((e) => e.toMap()).toList()
    };

    final request = http.MultipartRequest('POST', Uri.parse("$_apiUrl/create/$idUser"));

    request.fields['description'] = description;
    request.fields['appareils'] = jsonEncode(dimAppareils.map((e) => e.toMap()).toList());
    request.fields['latitude'] = "${position.latitude}";
    request.fields['longitude'] = "${position.longitude}";

    print("${position.longitude}");

    final responseStream = await request.send();

    final response = await http.Response.fromStream(responseStream);

    if(response.statusCode == 200){
      print(jsonDecode(utf8.decode(response.bodyBytes))["data"]);
      return Dimensionnement.fromJson(jsonDecode(utf8.decode(response.bodyBytes))["data"]);
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }
  }

  Future<List<Dimensionnement>> getDimensionnementByUserId(int idUser) async{

    if(_isSearch){
      _isSearch = false;
      return _list.where((element) => element.description!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }else{

      final response = await http.get(Uri.parse("$_apiUrl/list/$idUser"));

      if(response.statusCode == 200){
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes))['data'];
        _list = body.map((dynamic item) => Dimensionnement.fromJson(item)).toList();
        return _list;
      }else{
        throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
      }

    }

  }

  Future<Map<String,dynamic>> getDimensionnementById(int id) async {
    final response = await http.get(Uri.parse("$_apiUrl/$id"));

    if(response.statusCode == 200){
      return jsonDecode(utf8.decode(response.bodyBytes))['data'];
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }

  Future<String> noteElectricien(NotePojo notePojo) async {

    final response = await http.post(
      Uri.parse("$_apiNoteUrl/create"),
      headers: <String,String>{'Content-Type' : 'application/json; charset=UTF-8'},
      body: jsonEncode(notePojo.toMap())
    );

    if(response.statusCode == 200){
      return "success";
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))["message"]);
    }

  }

  void updateListAppareil(Appareil appareil){
    Appareil? appareilVerif = dimAppareils.where((element) => element.nom == appareil.nom).firstOrNull;
    if(appareilVerif != null) {
      dimAppareils.remove(appareilVerif);
    }else{
      dimAppareils.add(appareil);
    }
    notifyListeners();
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