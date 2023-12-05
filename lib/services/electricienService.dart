import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/electricien.dart';

class ElectricienService extends ChangeNotifier {

  final String _apiUrl = "http://10.0.2.2:8080/electricien";

  List<Electricien> electriciens = [];

  Future<Map<String,dynamic>> getElectriciens() async{

    final response = await http.get(Uri.parse("$_apiUrl/listActive"));

    if(response.statusCode == 200){
      //List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes))['data'];
      //equipement = body.map((dynamic item) => Equipement.fromJson(item)).toList();
      return jsonDecode(utf8.decode(response.bodyBytes))['data'];
    }else{
      throw Exception(jsonDecode(utf8.decode(response.bodyBytes))['message']);
    }
  }
}