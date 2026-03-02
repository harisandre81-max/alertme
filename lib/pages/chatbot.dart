import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const ChatBotApp());
}



// ================= APP =================
class ChatBotApp extends StatelessWidget {
  const ChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlertMe',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFE1EAED),
      ),
      home: const ChatScreen(usuarioId: 1),
    );
  }
}

// ================= CHAT SCREEN =================
class ChatScreen extends StatefulWidget {
  final int usuarioId;
  const ChatScreen({super.key, required this.usuarioId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _mensajes = [];

  // ================= LLAMADA =================
  bool mostrarBotonLlamada = false;
  String telefonoAyuda = "";

  // ================= FUNCIONES =================
  bool contiene(String input, List<String> palabras) {
    input = input.toLowerCase();
    for (var palabra in palabras) {
      if (input.contains(palabra)) return true;
    }
    return false;
  }

  Future<void> llamarAyuda() async {
    if (telefonoAyuda.isEmpty) return;

    final phoneUri = Uri(
      scheme: 'tel',
      path: telefonoAyuda,
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // ================= ENVIAR MENSAJE =================
  void _enviarMensaje() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _mensajes.add("Tú: $input");
      mostrarBotonLlamada = false;
      telefonoAyuda = "";
    });

    final respuesta = generarRespuesta(input);

    setState(() {
      _mensajes.add("Lumi: $respuesta");
    });

    _controller.clear();
  }

  // ================= RESPUESTAS =================
  String generarRespuesta(String input) {
    input = input.toLowerCase();

    const canalizacion =
        " Tal vez no te puedo ayudar directamente, "
        "pero sí puedo ponerte en contacto con alguien que te ayude.";

    if (contiene(input, [
      "hola",
      "buenas",
      "buen día",
      "buenas tardes",
      "buenas noches",
    ])) {
      return "¡Hola! Soy Lumi, tu asistente de compañía. ¿Cómo te sientes hoy?";
    }

    if (contiene(input, [
      "violencia sexual",
      "abuso sexual",
      "me abusaron",
      "me violaron",
      "me tocaron sin permiso",
      "acoso sexual",
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "911";
      return "Lamento mucho que estés pasando por algo tan difícil. "
          "No es tu culpa.$canalizacion";
    }

    if (contiene(input, [
      "me pegan",
      "me golpean",
      "me agreden",
      "me lastiman",
      "me maltratan",
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6751035059";
      return "Lo que describes es violencia física y es algo serio. "
          "Mereces estar a salvo.$canalizacion";
    }

    if (contiene(input, [
      "bullying",
      "acoso escolar",
      "me molestan",
      "se burlan de mi",
      "me humillan",
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento mucho que estés pasando por esto. "
          "No mereces que te traten así.$canalizacion";
    }

    if (contiene(input, [
      "ansiedad",
      "me siento ansioso",
      "me siento ansiosa",
      "ataque de ansiedad",
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "La ansiedad puede ser muy intensa, pero no estás solo.$canalizacion";
    }

    if (contiene(input, [
      "depresión",
      "depresion",
      "me quiero morir",
      "me quiero matar",
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por decirlo. "
          "Lo que sientes importa y merece atención.$canalizacion";
    }

    return "Gracias por contarme cómo te sientes. Estoy aquí para escucharte.";
  }

  // ================= UI =================
  @override
 Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFE6F0D5),
    body: SafeArea(
      child: Column(
        children: [
          // ───────────── BARRA SUPERIOR (SOLO BACK) ─────────────
         Container(
  height: 50,
  padding: const EdgeInsets.symmetric(horizontal: 8),
  color: const Color(0xFFE6F0D5),
  child: Stack(
    alignment: Alignment.center,
    children: [

      // 🔙 Botón atrás
      Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF8D77AB)),
          iconSize: 35,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),

      //Imagen centrada
      Image.asset(
        'assets/logo_inter/logo.png',
        height: 150,
        width: 150,
      ),
    ],
  ),
),

          // ───────────── LUMI GRANDE (FUERA DE LA BARRA) ─────────────
          const SizedBox(height: 1),

         Column(
  children: [
    const SizedBox(height: 1),

   /* Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE0EBC8),
      ),*/
      Center(
        child: Image.asset(
          'assets/chat/lumi.png',
          width: 230,
          height: 230,
          fit: BoxFit.cover,
        ),
      ),
   // ),
              const SizedBox(height: 1),

              const Text(
                '- L U M I -',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  
                  
                ),
              ),
            ],
          ),

          const SizedBox(height: 1),

          // ───────────── CHAT ─────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _mensajes.length,
              itemBuilder: (_, i) {
                final msg = _mensajes[i];
                final esUsuario = msg.startsWith("Tú:");
                return Align(
                  alignment: esUsuario
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: esUsuario
                          ? const Color(0xFFFDC67F)
                          : const Color(0xFF9B88B7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      msg.replaceFirst(
                          esUsuario ? "Tú: " : "Lumi: ", ""),
                      style: TextStyle(
                        color: esUsuario
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ───────────── BOTÓN DE LLAMADA ─────────────
          if (mostrarBotonLlamada)
            ElevatedButton.icon(
              icon: const Icon(Icons.phone),
              label: const Text("Llamar a apoyo"),
              onPressed: llamarAyuda,
            ),

          // ───────────── INPUT ─────────────
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [

const SizedBox(height: 10,),

                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Escribe algo...",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Color(0xFF8D77AB),
                  onPressed: _enviarMensaje,
                  iconSize: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  // ================= DISPOSE =================
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}