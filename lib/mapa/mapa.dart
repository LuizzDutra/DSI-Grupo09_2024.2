import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:app_gp9/empresa.dart';
import 'package:latlong2/latlong.dart';

class Mapa{
  double markerWidth;
  double markerHeight;
  bool noMarker;
  bool disabled;
  LatLng defaultCenter;
  double defaultZoom;
  final MapController _mapController = MapController();


  Mapa(
      {this.markerWidth = 80,
      this.markerHeight = 80,
      this.noMarker = false,
      this.disabled = false,
      this.defaultCenter = const LatLng(0, 0),
      this.defaultZoom = 3});

  LatLng getMapCenter(){
    return _mapController.camera.center;
  }

  Future<List<Marker>> createMarkers() async {
    List<Marker> list = [];
    if(noMarker){return list;}

    for (var empresa in await EmpresaCollection.getEmpresas()) {
      list.add(Marker(
          alignment: Alignment(0, -1.2),
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

  int getInteraction(){
    if(disabled){
      return InteractiveFlag.none;
    }
    return InteractiveFlag.all;
  }

  Future<FlutterMap> getMap() async {
    List<Marker> markers = await createMarkers();

    return FlutterMap(options: MapOptions(initialCenter: defaultCenter, initialZoom: defaultZoom, interactionOptions: InteractionOptions(flags: getInteraction())), mapController: _mapController, 
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