import 'package:flutter/material.dart';
import 'page_menu.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const ChatBotApp());
}
//no cambiar, administra el acceso al chatbot
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
      home: ChatScreen(usuarioId: 1), // ✅ ya no const porque es dinámico
    );
  }
}

//no cambiar ed parte del de ariba
class ChatScreen extends StatefulWidget {
  final int usuarioId; // ⬅️ final, debe inicializarse

  const ChatScreen({super.key, required this.usuarioId}); // ⬅️ required

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _mensajes = [];
  

  // ================= AUDIO =================
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _reproduciendo = false;

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

  void _enviarMensaje() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _mensajes.add("Tú: $input");
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
//==================== SALUDO =====================
// ================= SALUDO =================
if (contiene(input, ["hola", "buenas", "buen día", "buenas tardes", "buenas noches"])) {
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
      "me tocaron donde no debian",
      "me tocaron partes privadas",
      "me obligaron",
      "me forzaron",
      "me violaron",
      "intento de violacion",
      "me acosaron sexualmente",
      "me manosearon",
      "me besaron sin permiso",
      "no fue consensuado",
      "no di permiso",
      "me senti asustado",
      "me senti culpable",
      "me senti avergonzado"
    ])) {
      return "Lamento mucho que estés pasando por algo tan difícil. No es tu culpa. Estoy aquí contigo y podemos buscar ayuda juntos. ";
    }

    // ================= VIOLENCIA FÍSICA =================
    if (contiene(input, [
      "me pegan",
      "me golpean",
      "me empujan",
      "me madrearon",
      "me chingaron",
      "me fregaron"
    ])) {
      return "Siento mucho que estés viviendo esto. Nadie tiene derecho a lastimarte. Tu bienestar es importante. ";
    }

    // ================= BULLYING =================
    if (contiene(input, [
      "bullying",
      "me hacen bullying",
      "me molestan",
      "me traen carrilla",
      "se burlan de mi",
      "me humillan"
    ])) {
      return "Eso que estás viviendo duele y no está bien. No estás solo, mereces respeto. ";
    }

    // ================= VIOLENCIA EN CASA =================
    if (contiene(input, [
      "en mi casa",
      "mi papá me pega",
      "mi mamá me pega",
      "mi padrastro",
      "hay violencia en mi casa"
    ])) {
      return "Gracias por confiar en mí. Lo que pasa en casa también importa y mereces estar a salvo. 🤍";
    }

    // ================= MIEDO =================
    if (contiene(input, [
      "tengo miedo",
      "me da miedo",
      "estoy asustado",
      "ando asustado"
    ])) {
      return "Es normal sentir miedo después de algo difícil. Respira conmigo, estoy aquí contigo. ";
    }

    // ================= DEFAULT =================
    return "Gracias por contarme cómo te sientes. Estoy aquí para escucharte. ";
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // SUB MENÚ SUPERIOR
      appBar: AppBar(
  toolbarHeight: 110,
  elevation: 0,
  leadingWidth: 80,
  backgroundColor: const Color(0xFFE6F0D5),

  titleSpacing: 80, // 👈 espacio entre leading y title

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
    'Chatbot Lumi 💬',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
    ),
  ),
),
      body: Column(
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
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _enviarMensaje,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== BOTÓN CALMARME =====
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDC67F),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            icon: Icon(
              _reproduciendo ? Icons.stop : Icons.play_arrow,
              size: 28,
            ),
            label: Text(
              _reproduciendo ? "Detener" : "Calmarme",
              style: const TextStyle(fontSize: 18),
            ),
            onPressed: _toggleCalma,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}