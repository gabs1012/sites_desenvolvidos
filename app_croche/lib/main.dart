import 'package:flutter/material.dart';
import 'views/formulario_page.dart';

void main() {
  runApp(const MeuAppCroche());
}

class MeuAppCroche extends StatelessWidget {
  const MeuAppCroche({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Crochê',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.brown,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          primary: Colors.brown,
          surfaceTint: Colors.transparent,
        ),
        // Customização padrão dos campos de texto para parecer o site
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const FormularioPage(),
    );
  }
}
