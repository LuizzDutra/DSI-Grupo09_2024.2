import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app_gp9/empresa.dart';
import 'package:latlong2/latlong.dart';

class Mapa{
  double markerWidth;
  double markerHeight;
  bool noMarker = false;
  final MapController _mapController = MapController();


  Mapa(this.markerWidth, this.markerHeight, [this.noMarker = false]);

  LatLng getMapCenter(){
    return _mapController.camera.center;
  }

  Future<List<Marker>> createMarkers() async {
    List<Marker> list = [];
    if(noMarker){return list;}

    for (var empresa in await EmpresaCollection.getEmpresas()) {
      list.add(Marker(
          point: empresa.loc,
          width: markerWidth,
          height: markerHeight,
          child: Column(children: [
            Text(empresa.nomeNegocio),
            GestureDetector(
              child: Image(image: AssetImage("assets/images/Logo.png")),
              onTap: () {
                print("Apertou: ${empresa.loc.toString()}");
              },
            ),
          ])));
    }
    return list;
  }

  Future<FlutterMap> getMap() async {
    List<Marker> markers = await createMarkers();

    return FlutterMap(options: MapOptions(initialZoom: 3), mapController: _mapController, 
    children: [
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
    String connectionText = "";
    if(!conected){
      connectionText = "Sem conexão";
    }
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
                              Text(connectionText)
                            ]);
                        }
                        }
                      );
  }
}