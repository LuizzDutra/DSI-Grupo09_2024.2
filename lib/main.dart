//import 'package:app_gp9/backend.dart';
import 'package:app_gp9/mapa/mapa_view.dart';
import 'package:app_gp9/perfil/perfil_view.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/home_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true

      ),
    home: const PerfilView()//const Login(),
  
  )
  
  );
}