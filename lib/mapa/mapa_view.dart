import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_gp9/empresa.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  
  
  
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  bool conected = false;

  @override
  void initState() {
    super.initState();
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((result){
      if(result.contains(ConnectivityResult.none)){
        if(conected == true){
          conected = false;
          setState(() {
            
          });
        }
      }else{
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
        body: Container(
            child: Center(
                child: getMapBuilder(conected)
                  )
              )
    );
  }
}

Future<List<Marker>> createMarkers() async {
  List<Marker> list = [];

  double defaultWidth = 80;
  double defaultHeight = 80;

  for (var empresa in await EmpresaCollection.getEmpresas()) {
    list.add(Marker(
        point: LatLng(empresa["loc"].latitude, empresa["loc"].longitude),
        width: defaultWidth,
        height: defaultHeight,
        child: Column(children: [
          Text(empresa["nomeNegocio"]),
          GestureDetector(
            child: Image(image: AssetImage("assets/images/Logo.png")),
            onTap: () {
              print("Apertou");
            },
          ),
        ])));
  }
  return list;
}

Future<FlutterMap> getMap() async {
  List<Marker> markers = await createMarkers();

  return FlutterMap(options: MapOptions(initialZoom: 3), children: [
    TileLayer(
      // Display map tiles from any source
      urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
      userAgentPackageName: 'com.example.app',
      // And many more recommended properties!
    ),
    MarkerLayer(markers: markers),
  ]);
}

FutureBuilder<FlutterMap> getMapBuilder(bool conected){
  Future<FlutterMap> map = getMap();
  return FutureBuilder(
                    future: map,
                    builder: (BuildContext context,
                        AsyncSnapshot<FlutterMap> snapshot) {
                      if (snapshot.hasData & conected) {
                        return Center(child: snapshot.data);
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                "Algo de errado aconteceu: ${snapshot.error}"));
                      }else{
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text("Sem conexão")
                          ]);
                      }
                      }
                    );
}
