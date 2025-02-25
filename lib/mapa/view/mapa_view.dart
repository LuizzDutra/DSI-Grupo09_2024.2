import 'package:app_gp9/custom_colors.dart';
import 'package:app_gp9/mapa/controller/mapa_controller.dart';
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
  String filter = "";
  TextEditingController searchController = TextEditingController();
  late Timer debouncer;

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
    searchController.addListener(processFilter);
    debouncer = Timer(Duration(milliseconds: 500), saveFilter);
  }

  void processFilter(){
    debouncer.cancel();
    debouncer = Timer(Duration(milliseconds: 500), saveFilter);
  }

  void saveFilter(){
    setState(() => MapaController.setMapFilter(searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mapa"),
          centerTitle: true,
          iconTheme: IconThemeData(size: 35, color: Colors.white),
          backgroundColor: customColors[7],
          foregroundColor: Colors.white,
        ),
        body: Stack(
        alignment: Alignment.topCenter,
        children: [
        SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: MapaController.getMapBuilder(conected)),
        Positioned(child: 
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(color: customColors[6]!),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Filtre por segmento"
            ),
            controller: searchController,
          ),
        ))
      ]),
    );
  }
}

