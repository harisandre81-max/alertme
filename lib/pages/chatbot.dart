import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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

  // ================= AUDIO =================
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _reproduciendo = false;

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

  Future<void> _toggleCalma() async {
    if (_reproduciendo) {
      await _audioPlayer.stop();
    } else {
      await _audioPlayer.play(AssetSource('audio/Respiracion.mp3'));
    }
    setState(() => _reproduciendo = !_reproduciendo);
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
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _mensajes.add("Tú: $input");
      mostrarBotonLlamada = false;
      telefonoAyuda = "";
    });

    String respuesta = generarRespuesta(input);

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

    // ================= SALUDO =================
    if (contiene(input, [
      "hola",
      "buenas",
      "buen día",
      "buenas tardes",
      "buenas noches"
    ])) {
      return "¡Hola!  Soy Lumi, tu asistente de compañía. ¿Cómo te sientes hoy?";
    }

    // ================= VIOLENCIA SEXUAL =================
    if (contiene(input, [
      "violencia sexual",
      "abuso sexual",
      "me abusaron",
      "me violaron",
      "me tocaron sin permiso",
      "acoso sexual"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "911";
      return "Lamento mucho que estés pasando por algo tan difícil. "
          "No es tu culpa.$canalizacion";
    }

    // ================= VIOLENCIA FÍSICA =================
    if (contiene(input, [
      "me pegan",
      "me golpean",
      "me empujan",
      "me patearon",
      "me madrearon",
      "me sangró la nariz",
      "me ahorcaron"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "911";
      return "Lo que describes es violencia física y es algo serio. "
          "Mereces estar a salvo.$canalizacion";
    }

    // ================= BULLYING =================
    if (contiene(input, [
      "bullying",
      "acoso escolar",
      "me molestan",
      "se burlan de mi",
      "me humillan",
      "me insultan",
      "me excluyen",
      "me ignoran",
      "me siento rechazado"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento mucho que estés pasando por esto. "
          "No mereces que te traten así.$canalizacion";
    }

    // ================= VIOLENCIA EN CASA =================
    if (contiene(input, [
      "violencia familiar",
      "en mi casa",
      "mi papá me pega",
      "mi mamá me pega",
      "me gritan en casa",
      "me golpean en casa"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por confiar en mí. "
          "Tu casa debería ser un lugar seguro.$canalizacion";
    }

    // ================= ANSIEDAD =================
    if (contiene(input, [
      "ansiedad",
      "me siento ansioso",
      "me da ansiedad",
      "no puedo respirar",
      "me siento muy nervioso",
      "ataque de ansiedad"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento que te estés sintiendo así . "
          "La ansiedad puede ser muy intensa, pero no estás solo.$canalizacion";
    }

    // ================= DEPRESIÓN =================
    if (contiene(input, [
      "depresión",
      "me siento deprimido",
      "me siento vacío",
      "no tengo ganas de nada",
      "estoy muy triste",
      "ya no quiero seguir",
      "me quiero matar",
      "me quiero morir",
      "me quiero matar"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por decirlo . "
          "Lo que sientes importa y merece atención.$canalizacion";
    }

    // ================= DEFAULT =================
    return "Gracias por contarme cómo te sientes. Estoy aquí para escucharte.";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Lumi 💬'),
        backgroundColor: const Color(0xFFE6F0D5),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _mensajes.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_mensajes[i]),
              ),
            ),
          ),

          if (mostrarBotonLlamada)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.phone),
              label: const Text("Llamar a apoyo"),
              onPressed: llamarAyuda,
            ),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Escribe aquí...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDC67F),
              foregroundColor: Colors.black,
            ),
            icon: Icon(_reproduciendo ? Icons.stop : Icons.play_arrow),
            label: Text(_reproduciendo ? "Detener" : "Calmarme"),
            onPressed: _toggleCalma,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
