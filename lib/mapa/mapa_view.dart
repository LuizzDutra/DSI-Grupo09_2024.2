import 'package:app_gp9/mapa/mapa.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class MapaView extends StatefulWidget {
  const MapaView({super.key});

  @override
  State<MapaView> createState() => _MapaState();
}

class _MapaState extends State<MapaView> {
  
  
  
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  bool conected = false;
  var mapa = Mapa();

  @override
  void initState() {
    super.initState();
    //Primeira verificação
    Connectivity().checkConnectivity().then((result){
      if(!result.contains(ConnectivityResult.none)){
        conected = true;
        setState((){});
      }
    });
    //Stream
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result){
      if(!result.contains(ConnectivityResult.none)){
        if(conected == false){
          conected = true;
          setState(() {
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: mapa.getMapBuilder(conected)
              )
    );
  }
}

