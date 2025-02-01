import 'package:firebase_auth/firebase_auth.dart';

class HomeController{

  static void signOut(){
    FirebaseAuth.instance.signOut();
  }
}