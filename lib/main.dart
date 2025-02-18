//import 'package:app_gp9/backend.dart';
import 'package:app_gp9/home_page/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/login_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true

      ),
    home: (){
      if(FirebaseAuth.instance.currentUser == null){
        return const Login();}
        return const Home();}(),
  
  )
  
  );
}