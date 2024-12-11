import 'package:app_gp9/autenticacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Logado como:\n ${FirebaseAuth.instance.currentUser!.email}"),
      ),
    );
  }
}
