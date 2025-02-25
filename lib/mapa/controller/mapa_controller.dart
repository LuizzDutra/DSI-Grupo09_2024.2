import 'package:app_gp9/empresa.dart';
import 'package:app_gp9/mapa/model/mapa.dart';


class MapaController {

  static Mapa mapa = Mapa();

  static getMap(String filter){
    return mapa;
  }

  static getMapBuilder(bool conected){
    return mapa.getMapBuilder(conected);
  }
  
  static setMapFilter(String filter){
    mapa.filter = filter;
  }

  static setMapCallBack(void Function(Empresa empresa) callback){
    mapa.tapCallBack = callback;
  }

}