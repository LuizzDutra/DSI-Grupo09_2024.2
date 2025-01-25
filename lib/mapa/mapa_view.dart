import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_gp9/empresa.dart';


class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    createMarkers().then((value){
      setState(() {
        markers = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(
      child: FlutterMap(options: MapOptions(initialZoom: 3), children: [
        TileLayer(
          // Display map tiles from any source
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
          userAgentPackageName: 'com.example.app',
          // And many more recommended properties!
        ),
        MarkerLayer(markers: markers),
    ]))));
  }
}


Future<List<Marker>> createMarkers() async{
  List<Marker> list = [];

  double defaultWidth = 80;
  double defaultHeight = 80;

  for (var empresa in await EmpresaCollection.getEmpresas()){
    list.add(
      Marker(
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
              ])
      )
    );
  }
  return list;
}
