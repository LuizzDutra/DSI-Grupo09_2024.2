import 'package:cloud_firestore/cloud_firestore.dart';

class PlanoNegocios {
  // Classe Entidade
  Map<String, dynamic>? _descClientes;
  Map<String, dynamic>? _descValor;
  Map<String, dynamic>? _descCanais;
  Map<String, dynamic>? _descRelacionamentos;
  Map<String, dynamic>? _descReceita;
  Map<String, dynamic>? _descRecursos;
  Map<String, dynamic>? _descAtividades;
  Map<String, dynamic>? _descParcerias;
  Map<String, dynamic>? _descCustos;
  String? _nome;
  int? _idPessoa;
  DocumentReference? _referencia;

  Map<String, dynamic>? get descClientes => _descClientes;
  Map<String, dynamic>? get descValor => _descValor;
  Map<String, dynamic>? get descCanais => _descCanais;
  Map<String, dynamic>? get descRelacionamentos => _descRelacionamentos;
  Map<String, dynamic>? get descReceita => _descReceita;
  Map<String, dynamic>? get descRecursos => _descRecursos;
  Map<String, dynamic>? get descAtividades => _descAtividades;
  Map<String, dynamic>? get descParcerias => _descParcerias;
  Map<String, dynamic>? get descCustos => _descCustos;
  String? get descNome => _nome;
  int? get idPessoa => _idPessoa;
  DocumentReference? get referencia => _referencia;

  set descClientes(Map<String, dynamic>? value) => _descClientes = value;
  set descValor(Map<String, dynamic>? value) => _descValor = value;
  set descCanais(Map<String, dynamic>? value) => _descCanais = value;
  set descRelacionamentos(Map<String, dynamic>? value) =>
      _descRelacionamentos = value;
  set descReceita(Map<String, dynamic>? value) => _descReceita = value;
  set descRecursos(Map<String, dynamic>? value) => _descRecursos = value;
  set descAtividades(Map<String, dynamic>? value) => _descAtividades = value;
  set descParcerias(Map<String, dynamic>? value) => _descParcerias = value;
  set descCustos(Map<String, dynamic>? value) => _descCustos = value;
  set descNome(String? value) => _nome = value;
  set idPessoa(int? value) => _idPessoa = value;
  set referencia(DocumentReference? value) => _referencia = value;

  PlanoNegocios(
    this._descAtividades,
    this._descCanais,
    this._descClientes,
    this._descCustos,
    this._descParcerias,
    this._descReceita,
    this._descRecursos,
    this._descRelacionamentos,
    this._descValor,
    this._nome,
  );

  Map<String, dynamic> toJson() {
    return {
      'Atividades': _descAtividades, //
      'Canais': _descCanais, //
      'Clientes': _descClientes, //
      'Custos': _descCustos, //
      'Parcerias': _descParcerias, //
      'Receita': _descReceita, //
      'Recursos': _descRecursos, //
      'Relacionamento': _descRelacionamentos, //
      'Proposta de valor': _descValor, //
      'nome': _nome, //
      "referencia": _referencia //
    };
  }

  PlanoNegocios.fromJson(Map<String, dynamic> dados) {
    _descClientes = dados['Clientes']; //
    _descValor = dados['Proposta de valor']; //
    _descCanais = dados['Canais']; //
    _descCustos = dados['Custos']; //
    _descParcerias = dados['Parcerias']; //
    _descReceita = dados['Receita']; //
    _descRecursos = dados['Recursos']; //
    _descAtividades = dados['Atividades']; //
    _descRelacionamentos = dados['Relacionamento']; //
    _nome = dados['nome']; //
    _referencia = dados['referencia']; //
  }
}
