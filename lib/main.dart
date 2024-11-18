//import 'package:app_gp9/backend.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/HomePage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true

      ),
    home: const Login(),
  
  )
  
  );
}