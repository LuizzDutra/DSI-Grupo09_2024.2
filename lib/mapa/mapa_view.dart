import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
      child: FlutterMap(
        options: MapOptions(initialZoom: 3), 
        children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        MarkerLayer(markers: [
          Marker(
            point: LatLng(0, 0),
            width: 80,
            height: 80,
            child: GestureDetector(
            child: Image(image: AssetImage("assets/images/Logo.png")),
            onTap: (){
              print("Apertou papai");
            },
            ),
          )
        ])
      ]),
    )));
  }
}
