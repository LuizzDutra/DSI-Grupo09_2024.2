import 'package:cloud_firestore/cloud_firestore.dart';

class AnaliseSwot {
  final String id;
  final String nome;
  final Map<String, dynamic> analise;
  final DocumentReference referencia;

  AnaliseSwot({
    required this.id,
    required this.nome,
    required this.analise,
    required this.referencia,
  });

  factory AnaliseSwot.fromMap(String id, Map<String, dynamic> map) {
    return AnaliseSwot(
      id: id,
      nome: map['nome'],
      analise: map['analise'],
      referencia: map['referencia'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'analise': analise,
      'referencia': referencia,
    };
  }
}

