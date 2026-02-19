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
      await _audioPlayer.play(
        AssetSource('audio/Respiracion.mp3'),
      );
    }

    setState(() {
      _reproduciendo = !_reproduciendo;
    });
  }

  Future<void> llamarAyuda() async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: '6751035059',
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  // ================= ENVIAR MENSAJE =================
  Future<void> _enviarMensaje() async {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _mensajes.add("Tú: $input");
      mostrarBotonLlamada = false;
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
        "pero sí puedo mandarte con alguien que te ayude.";

    // ================= SALUDO =================
    if (contiene(input, [
      "hola",
      "buenas",
      "buen día",
      "buenas tardes",
      "buenas noches"
    ])) {
      return "¡Hola! 😊 ¿Cómo te sientes hoy?";
    }

    // ================= VIOLENCIA SEXUAL =================
    if (contiene(input, [
      "violencia sexual",
      "abuso sexual",
      "abuso",
      "me abusaron",
      "abusaron de mi",
      "me tocaron",
      "me tocaron sin permiso",
      "me obligaron",
      "me forzaron",
      "me violaron",
      "acoso sexual"
    ])) {
      mostrarBotonLlamada = true;
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
      "me lastimaron",
      "me dejaron moretones",
      "me sangró la nariz",
      "me ahorcaron"
    ])) {
      mostrarBotonLlamada = true;
      return "Lamento mucho que estés viviendo esta situación 😔. "
             "Lo que describes es violencia física y no está bien. "
             "Mereces estar a salvo.$canalizacion";
    }

    // ================= BULLYING =================
    if (contiene(input, [
      "bullying",
      "me molestan",
      "se burlan de mi",
      "me humillan",
      "me traen carrilla"
    ])) {
      mostrarBotonLlamada = true;
      return "Lo que estás viviendo duele y no está bien. "
             "No estás solo.$canalizacion";
    }

    // ================= VIOLENCIA EN CASA =================
    if (contiene(input, [
      "en mi casa",
      "mi papá me pega",
      "mi mamá me pega",
      "violencia familiar"
    ])) {
      mostrarBotonLlamada = true;
      return "Gracias por confiar en mí. "
             "Mereces estar a salvo.$canalizacion";
    }

    // ================= MIEDO =================
    if (contiene(input, [
      "tengo miedo",
      "me da miedo",
      "estoy asustado",
      "me siento inseguro"
    ])) {
      mostrarBotonLlamada = true;
      return "Sentir miedo después de algo difícil es normal. "
             "No tienes que enfrentarlo solo.$canalizacion";
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
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_mensajes[index]),
                );
              },
            ),
          ),

          if (mostrarBotonLlamada)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.phone),
              label: const Text("Llamar a ayuda"),
              onPressed: llamarAyuda,
            ),

          Padding(
            padding: const EdgeInsets.all(8.0),
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