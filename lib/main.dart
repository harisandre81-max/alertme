import 'package:flutter/material.dart';
import 'pages/page_inicio_de_sesion.dart';
import 'pages/page_menu.dart';

//raiz de la interfaz
void main() {
  runApp(const MyApp());
}
//poner separadores entre los widgets del menu, acomodar el logo y las demas interfaces
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  
      title: 'Mi App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InicioDeSesion(),//llama la pantalla
    );
  }
}
