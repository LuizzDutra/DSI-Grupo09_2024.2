import 'package:app_gp9/empresa.dart';

class Pessoa{
  
  final String idUsuario;
  final int idPessoa;
  final String email;
  final String nome;
  String? pais;
  DateTime? _dataNascimento;
  Empresa? empresa;

  Pessoa(this.idUsuario, this.idPessoa, this.nome, this.email);

  set dataNascimento(String dataNascimento){
    _dataNascimento = DateTime.parse(dataNascimento);
  }

  String get dataNascimento => _dataNascimento.toString();

}