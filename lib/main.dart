import 'package:alertme/pages/page_inicio_registro_contactos.dart';
import 'package:alertme/pages/page_inicio_registro_contactos2.dart';
import 'package:alertme/pages/page_inicio_registro_contactos3.dart';
import 'package:flutter/material.dart';
import 'pages/page_inicio_de_sesion.dart';
import 'pages/page_user_data.dart';

// Raíz de la interfaz
void main() {
  runApp(const MyApp());
}

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
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(
              builder: (_) => const InicioDeSesion(),
            );

          case '/profile':
            final args = settings.arguments as Map<String, dynamic>?;
            if (args != null && args.containsKey('usuarioId')) {
              return MaterialPageRoute(
                builder: (_) =>
                    UserProfilePage(usuarioId: args['usuarioId']),
              );
            }
            return _errorRoute();

          case '/contact1':
            final args = settings.arguments as int?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => Contact(usuarioId: args),
              );
            }
            return _errorRoute();
          case '/contact2':
            final args = settings.arguments as int?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => Contact2(usuarioId: args),
              );
            }
            return _errorRoute();
          case '/contact3':
            final args = settings.arguments as int?;
            if (args != null) {
              return MaterialPageRoute(
                builder: (_) => Contact3(usuarioId: args),
              );
            }
            return _errorRoute();

          default:
            return _errorRoute();
        }
      },
    );
  }

  // 🔹 Método de ayuda definido **fuera de build**
  MaterialPageRoute _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Ruta no encontrada')),
      ),
    );
  }
}

