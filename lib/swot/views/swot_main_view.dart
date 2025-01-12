import 'package:app_gp9/swot/controller/swot_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_gp9/swot/models/swot_model.dart';

class SwotMainView extends StatefulWidget {
  final AnaliseSwot swot;

  const SwotMainView({super.key, required this.swot});

  @override
  State<SwotMainView> createState() => _SwotMainViewState();
}

class _SwotMainViewState extends State<SwotMainView> {
  final SwotController _swotController = SwotController();
  final user = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(widget.swot.id!),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'SWOT - ${widget.swot.nome}',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color(0xFF001800),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ambiente Interno',
                style: TextStyle(fontSize: 20, fontFamily: "Poppins-regular"),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
