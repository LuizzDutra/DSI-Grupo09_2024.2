import 'package:cloud_firestore/cloud_firestore.dart';

class Meta {
  final String id; // ID da Meta
  final String titulo; // Nome da meta
  final double valorInicio; // Valor inicial da meta
  final double valorAtual; // Valor que já foi atingido
  final double valorFim; // Valor final da meta
  final String descricao; // Descrição da meta
  final DateTime prazo; // Data limite para atingir a meta
  final DocumentReference referencia; // Referência no Firestore

 Meta({
    required this.id,
    required this.titulo,
    required this.valorInicio,
    required this.valorAtual,
    required this.valorFim,
    required this.descricao,
    required this.prazo,
    required this.referencia,
  });

// Converte um documento Firestore para um objeto Meta
  factory Meta.fromMap(String id, Map<String, dynamic> map, DocumentReference referencia) {
    return Meta(
      id: id,
      titulo: map['titulo'] ?? '',
      valorInicio: (map['valorInicio'] as num?)?.toDouble() ?? 0.0,
      valorAtual: (map['valorAtual'] as num?)?.toDouble() ?? 0.0,
      valorFim: (map['valorFim'] as num?)?.toDouble() ?? 0.0,
      descricao: map['descricao'] ?? '',
      prazo: (map['prazo'] != null) 
        ? (map['prazo'] as Timestamp).toDate() 
        : DateTime.now(),
      referencia: referencia,
    );
  }

   // Converte objeto Meta para um Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'valorInicio': valorInicio,
      'valorAtual': valorAtual,
      'valorFim': valorFim,
      'descricao': descricao,
      'prazo': Timestamp.fromDate(prazo),
    };
  }

// Calcula o progresso da meta financeira
  double calcularProgresso() {
    if (valorFim == 0) return 0;
    return ((valorAtual - valorInicio) / (valorFim - valorInicio)) * 100;
  }
}