class OrcamentoController {
  /// Calcula quanto o artesão ganha por hora trabalhada.
  double calcularValorHora({
    required double pretensaoSalarial,
    required double horasTrabalhadasNoMes,
  }) {
    if (horasTrabalhadasNoMes <= 0) return 0.0;
    return pretensaoSalarial / horasTrabalhadasNoMes;
  }

  /// Calcula o preço final da peça tirando a dificuldade.
  double calcularPrecoFinal({
    required double custoMateriais,
    required int horasProducao,
    required int minutosProducao,
    required double pretensaoSalarial,
    required double horasTrabalhadasNoMes,
    required double margemLucroPorcentagem,
    required double valorFrete,
    required bool incluirFreteNoPreco,
  }) {
    // 1. Descobre o valor da hora base
    double valorHora = calcularValorHora(
      pretensaoSalarial: pretensaoSalarial,
      horasTrabalhadasNoMes: horasTrabalhadasNoMes,
    );

    // 2. Converte o tempo gasto na peça para horas (ex: 1h e 30m = 1.5h)
    double tempoGastoEmHoras = horasProducao + (minutosProducao / 60.0);

    // 3. Custo da mão de obra para esta peça
    double custoMaoDeObra = tempoGastoEmHoras * valorHora;

    // 4. Custo base (Materiais + Mão de obra)
    double custoTotal = custoMateriais + custoMaoDeObra;

    // 5. Aplica a margem de lucro
    double precoComLucro = custoTotal * (1 + (margemLucroPorcentagem / 100.0));

    // 6. Soma o frete se estiver marcado
    if (incluirFreteNoPreco) {
      precoComLucro += valorFrete;
    }

    return precoComLucro;
  }
}