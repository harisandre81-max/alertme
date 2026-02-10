/*material.dart → widgets base de Flutter (Scaffold, AppBar, Button, etc.)
registro_contactos.dart → pantalla a la que navega “Registrar contactos”*/
import 'page_inicio_de_sesion.dart';
import 'package:flutter/material.dart';

//La pantalla, solo dibuja UI
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    /*Scaffold (estructura base)
    Scaffold = esqueleto de la pantalla
    AppBar = barra superior*/
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginShellUI(),
    );
  }
}

class LoginShellUI extends StatelessWidget {
  const LoginShellUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0D5),

  /*Center → centra todo en pantalla
  Column → coloca widgets uno debajo del otro */
      body: SafeArea(
        child: Column(
          children: [

            const Spacer(),

            // LOGO + CHECK
            Stack(
              /*mainAxisAlignment.center → centra verticalmente
              children → lista de widgets */
              clipBehavior: Clip.none,
              children: [
                // LOGO (placeholder)
               Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  'assets/imagenes/Logo.jpeg',
                  fit: BoxFit.contain,
                ),
              ),

              ],
            ),

            const Spacer(),

            // BOTÓN INICIAR SESIÓN
            
            GestureDetector(
              onTap: () {
                // AQUÍ VA LA ACCIÓN
                // ejemplo: navegar a otra pantalla
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InicioDeSesion(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  height: 58,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC27D),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'INICIAR SESION',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

