import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MeteoService extends ChangeNotifier {

  late Position position;

  Future<String> getTemperature() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Service de localisation desactivé');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission de localisation désactivée');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('La permission de localisation est permamment desactivée');
    }

    position = await Geolocator.getCurrentPosition();
    
    final response = await http.get(Uri.parse("https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&current=temperature_2m"));

    if(response.statusCode == 200){
      int index = "${jsonDecode(response.body)["current"]["temperature_2m"]}".indexOf(".");
      return "${jsonDecode(response.body)["current"]["temperature_2m"]}".substring(0,index);
    }else{
      return Future.error('Verifier votre connexion');
    }
  }

  void applyChange(){
    notifyListeners();
  }

}