import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/orcamento_controller.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _controller = OrcamentoController();

  // Controladores dos campos de texto
  final _pretensaoSalarialController = TextEditingController(text: '3000.0');
  final _horasMesController = TextEditingController(text: '192');
  final _custoMateriaisController = TextEditingController(text: '0.0');
  final _horasProducaoController = TextEditingController(text: '0');
  final _minutosProducaoController = TextEditingController(text: '0');
  final _lucroController = TextEditingController(text: '0');
  final _freteController = TextEditingController(text: '0.0');

  @override
void initState() {
  super.initState();
  // Calcula o valor inicial logo ao abrir a tela
  _atualizarCalculo();
}
@override
void dispose() {
  _pretensaoSalarialController.dispose();
  _horasMesController.dispose();
  _custoMateriaisController.dispose();
  _horasProducaoController.dispose();
  _minutosProducaoController.dispose();
  _lucroController.dispose();
  _freteController.dispose();
  super.dispose();
}
  bool _incluirFrete = false;
  double _resultadoFinal = 0.0;

  void _atualizarCalculo() {
    double pretensao = double.tryParse(_pretensaoSalarialController.text) ?? 0.0;
    double horasMes = double.tryParse(_horasMesController.text) ?? 0.0;
    double custoMat = double.tryParse(_custoMateriaisController.text) ?? 0.0;
    int horasProd = int.tryParse(_horasProducaoController.text) ?? 0;
    int minutosProd = int.tryParse(_minutosProducaoController.text) ?? 0;
    double lucro = double.tryParse(_lucroController.text) ?? 0.0;
    double frete = double.tryParse(_freteController.text) ?? 0.0;

    setState(() {
      _resultadoFinal = _controller.calcularPrecoFinal(
        pretensaoSalarial: pretensao,
        horasTrabalhadasNoMes: horasMes,
        custoMateriais: custoMat,
        horasProducao: horasProd,
        minutosProducao: minutosProd,
        margemLucroPorcentagem: lucro,
        valorFrete: frete,
        incluirFreteNoPreco: _incluirFrete,
      );
    });
  }

  void _compartilharOrcamento() {
    final mensagem = Uri.encodeComponent(
      'Olá! Segue o orçamento do seu crochê:\n\n'
      '📦 Frete incluso: ${_incluirFrete ? "Sim" : "Não"}\n'
      '---------------------------\n'
      '💰 *Valor Total: R\$ ${_resultadoFinal.toStringAsFixed(2)}*\n\n'
      'Obrigado pela preferência! 😊'
    );
    
    final urlCompleta = 'https://wa.me/?text=$mensagem';
    final uri = Uri.parse(urlCompleta);
    _abrirLinkNativo(uri);
  }

  void _abrirLinkNativo(Uri uri) async {
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F0),
      appBar: AppBar(
        title: const Text('Novo Orçamento - Crochê'),
        backgroundColor: Colors.brown[300],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD DO VALOR FINAL
            Card(
              color: Colors.brown[100],
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Preço Sugerido ao Cliente', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${_resultadoFinal.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.brown),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SEÇÃO: MÃO DE OBRA / SALÁRIO BASE
            const Text('Configurações do Seu Salário', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pretensaoSalarialController,
                    decoration: const InputDecoration(labelText: 'Pretensão Salarial (R\$)'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _atualizarCalculo(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _horasMesController,
                    decoration: const InputDecoration(labelText: 'Horas Trab. no Mês'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _atualizarCalculo(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // SEÇÃO: DADOS DA PEÇA
            const Text('Dados da Peça', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _custoMateriaisController,
              decoration: const InputDecoration(labelText: 'Custo Total dos Materiais (R\$)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _atualizarCalculo(),
            ),
            const SizedBox(height: 12),

            // TEMPO DE PRODUÇÃO
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _horasProducaoController,
                    decoration: const InputDecoration(labelText: 'Horas de Produção'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _atualizarCalculo(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _minutosProducaoController,
                    decoration: const InputDecoration(labelText: 'Minutos'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _atualizarCalculo(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // MARGEM DE LUCRO
            TextField(
              controller: _lucroController,
              decoration: const InputDecoration(labelText: 'Margem de Lucro (%)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _atualizarCalculo(),
            ),
            const SizedBox(height: 12),

            // FRETE
            TextField(
              controller: _freteController,
              decoration: const InputDecoration(labelText: 'Valor do Frete (R\$)'),
              keyboardType: TextInputType.number,
              onChanged: (_) => _atualizarCalculo(),
            ),
            
            CheckboxListTile(
              title: const Text('Incluir frete no preço final?'),
              value: _incluirFrete,
              onChanged: (valor) {
                setState(() {
                  _incluirFrete = valor ?? false;
                  _atualizarCalculo();
                });
              },
            ),
            const SizedBox(height: 24),

            // BOTÕES DE AÇÃO
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Limpar Tudo'),
                    onPressed: () {
                      setState(() {
                        _pretensaoSalarialController.text = '3000.0';
                        _horasMesController.text = '192';
                        _custoMateriaisController.text = '0.0';
                        _horasProducaoController.text = '0';
                        _minutosProducaoController.text = '0';
                        _lucroController.text = '0';
                        _freteController.text = '0.0';
                        _incluirFrete = false;
                        _atualizarCalculo();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.share),
                    label: const Text('Enviar ao Cliente'),
                    onPressed: () {
                      _compartilharOrcamento();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}