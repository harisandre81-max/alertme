import 'package:flutter/material.dart';
class TerminosUIPage extends StatelessWidget {
  const TerminosUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  centerTitle: true, // 👈 centra el título
  title: const Text(
    'Términos y Condiciones',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
    ),
  ),
  backgroundColor: const Color(0xFFE6F0D5),
  iconTheme: const IconThemeData(color: Colors.deepPurple),
),

      body: Padding(
  padding: const EdgeInsets.all(20),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(height: 20), // 👈 espacio superior

        Text(
          '''
1. Uso de la aplicación
El usuario acepta utilizar la aplicación de forma responsable.

2. Privacidad
Los datos ingresados serán protegidos.

3. Responsabilidad
La app no se hace responsable del mal uso.

4. Aceptación
Al registrarte aceptas estos términos.
          ''',
          style: TextStyle(
            fontSize: 14,
            color: Colors.deepPurple, // 👈 texto púrpura
          ),
        ),
      ],
    ),
  ),
),

    );
  }
}