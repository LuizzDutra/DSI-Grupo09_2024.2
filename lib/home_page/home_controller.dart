import 'package:firebase_auth/firebase_auth.dart';

class HomeController{

  static void signOut(){
    FirebaseAuth.instance.signOut();
  }


  static Future<String> sendMessage(String message) async{
    await Future.delayed(Duration(seconds: 1));
    return message;
  }
}