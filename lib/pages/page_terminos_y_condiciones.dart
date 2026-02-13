import 'package:flutter/material.dart';

class TerminosUIPage extends StatelessWidget {
  const TerminosUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E3),
       // SUB MENÚ SUPERIOR
      appBar: AppBar(
  toolbarHeight: 110,
  elevation: 0,
  leadingWidth: 80,
  backgroundColor: const Color(0xFFE6F0D5),

  titleSpacing: 40, // 👈 espacio entre leading y title

  leading: Padding(
    padding: const EdgeInsets.all(5.0),
    child: Image.asset(
      'assets/logo_inter/logo.png',
      width: 70,
      height: 70,
      fit: BoxFit.contain,
    ),
  ),

  title: const Text(
    'Términos y Condiciones',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
    ),
  ),
),

body: ListView(
  padding: const EdgeInsets.all(20),
  children: [
     Align(
  alignment: Alignment.topLeft,
  child: IconButton(
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.deepPurple,
      size: 28,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
),

    _buildBloque(
      "1. Uso de la aplicación",
      "El usuario se compromete a utilizar la aplicación de manera responsable y legal.",
    ),

    _buildBloque(
      "2. Protección de datos",
      "La información proporcionada será tratada con confidencialidad y conforme a la ley.",
    ),

    _buildBloque(
      "3. Responsabilidad",
      "La app no se hace responsable del uso indebido por parte del usuario.",
    ),

  ],
),

    );
  }
}
Widget _buildBloque(String titulo, String contenido) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          contenido,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}
