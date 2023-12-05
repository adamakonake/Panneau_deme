import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/equipement.dart';

class EquipementService extends ChangeNotifier{

  final String _apiUrl = "http://10.0.2.2:8080/equipement";

  List<Equipement> equipement = [];

  String _trieValue = "";
  bool _isTrie = false;
  String _searchValut = "";
  bool _isSearch = false;

  Future<List<Equipement>> getEquipements() async {

    if(_isTrie){
      _isTrie = false;
      print("es true");
      List<Equipement> list = equipement;
      if(_trieValue == "type"){
        list.sort((a,b) => a.typeEquipement!.titre!.compareTo(b.typeEquipement!.titre!));
      }else{
        list.sort((a,b) => a.marque!.compareTo(b.marque!));
      }
      return list;
    }
    if(_isSearch){
      _isSearch = false;
      return equipement.where((element) => element.marque!.toLowerCase().contains(_searchValut.toLowerCase()) ||
          element.typeEquipement!.titre!.toLowerCase().contains(_searchValut.toLowerCase()) ||
          element.puissance.toString().contains(_searchValut.toLowerCase()) ||
          element.tension.toString().contains(_searchValut) ||
          element.intensite.toString().contains(_searchValut)).toList();
    }

    final response = await http.get(Uri.parse("$_apiUrl/list"));

    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      equipement = body.map((dynamic item) => Equipement.fromJson(item)).toList();
      return equipement;
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }

  }

  void applyTrie(String value){
    _isTrie = true;
    _trieValue = value;
  }

  void applySearch(String query){
    _isSearch = true;
    _searchValut = query;
    applyChange();
  }

  void applyChange(){
    notifyListeners();
  }
}