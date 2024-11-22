//Este arquivo destinasse a criação de funções auxiliares.

Future <String> stringInserirDados(String tabela, List <dynamic> lista) async{
    int tamanho = lista.length;
    String inicial = "(";
    
    for (var i = 0; i < tamanho - 1; i++) {
      inicial += "?, ";
    }

    inicial += "?)";

    return 'INSERT INTO $tabela VALUES $inicial';

  }

Future <String> stringUpdateDados(String tabela, List <dynamic> colunas, String where) async{
  int tamanho = colunas.length;
  String inicial = "";
  
  for (var i = 0; i < tamanho - 1; i++) {
    inicial += "${colunas[i]} = ?, ";
  }

  inicial += "${colunas[tamanho-1]} = ?";

  return "UPDATE $tabela SET $inicial WHERE = ?";

}

