import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
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

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
    bool esSituacionFuerte = false; 
  final GlobalKey<_VideoLumiState> lumiKey = GlobalKey();
  final TextEditingController _controller = TextEditingController();
  final List<String> _mensajes = [];

  // ================= LLAMADA =================
  bool mostrarBotonLlamada = false;
  String telefonoAyuda = "";

  @override
void initState() {
  super.initState();

}
  void animarLumi() {
  lumiKey.currentState?.reproducirAnimacion();
}

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

  void _enviarMensaje() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    animarLumi();

    esSituacionFuerte = false;

    setState(() {

  // 👇 elimina la opción de calma si existe
  _mensajes.removeWhere((m) => m == "Lumi_opcion_calma");

  _mensajes.add("Tú: $input");
  mostrarBotonLlamada = false;
  telefonoAyuda = "";
});

    final respuesta = generarRespuesta(input);

setState(() {
  _mensajes.add("Lumi: $respuesta");
});

if (esSituacionFuerte) {
  Future.delayed(const Duration(milliseconds: 500), () {
    setState(() {
      _mensajes.add("Lumi_opcion_calma");
    });
  });
}
_controller.clear();
  }

  String generarRespuesta(String input) {
    input = input.toLowerCase();

    const canalizacion =
        " Tal vez no te puedo ayudar directamente, "
        "pero sí puedo ponerte en contacto con alguien que te ayude.";

    if (contiene(input, [
      "hola","buenas","buen día","buenas tardes","buenas noches"
    ])) {
      return "¡Hola! Soy Lumi, tu asistente de compañía. ¿Cómo te sientes hoy?";
    }

    if (contiene(input, [
      "violencia sexual","abuso sexual","me abusaron",
      "me violaron","me tocaron sin permiso","acoso sexual"
    ])) {
      esSituacionFuerte = true;
      mostrarBotonLlamada = true;
      telefonoAyuda = "911";
      return "Lamento mucho que estés pasando por algo tan difícil. No es tu culpa.$canalizacion";
    }

    if (contiene(input, [
  "me pegan","me golpean","me agreden","me lastiman","me maltratan",
  "me están pegando","me están golpeando","me están agrediendo",
  "me pegaron","me golpearon","me agredieron","me lastimaron",
  "me maltrataron","me hizo daño","me hacen daño","me hicieron daño",
  "me empujan","me empujaron","me jalonean","me jalan",
  "me cachetean","me cachetearon","me bofetean","me bofetearon",
  "me patean","me patearon","me dan patadas",
  "me dan puñetazos","me dieron puñetazos",
  "me dan golpes","me dieron golpes",
  "me aventaron","me avientan","me tiraron al suelo",
  "me arrastran","me arrastraron",
  "me pellizcan","me pellizcaron",
  "me queman","me quemaron","me intentaron quemar",
  "me cortaron","me cortan","me hicieron cortadas",
  "me amenazan con golpearme",
  "me amenazan con matarme",
  "me atacan","me atacaron",
  "me rompen mis cosas","rompieron mis cosas",
  "me azotan","me azotaron",
  "me aprietan fuerte","me sujetan fuerte",
  "me encierran","me encerraron",
  "no me dejan salir",
  "me controlan con violencia",
  "me agarran del cuello",
  "me ahorcan","me intentaron ahorcar",
  "me tiran cosas",
  "me lanzan objetos",
  "me agredió mi pareja",
  "mi pareja me pega",
  "mi esposo me golpea",
  "mi esposa me golpea",
  "mi papá me pega",
  "mi mamá me pega",
  "me pega mi hermano",
  "me pega mi familiar",
  "vivo violencia",
  "sufro violencia",
  "hay violencia en mi casa",
  "me siento en peligro",
  "tengo miedo de que me pegue",
  "tengo miedo de que me lastime",
  "me tratan con violencia",
  "me violentan",
  "me hacen moretones",
  "me dejaron moretones",
  "me dejaron heridas",
  "tengo heridas por golpes",
  "me sangraron por golpearme",
  "me rompieron algo",
  "me fracturaron",
  "me pegaron con cinturón",
  "me pegaron con objeto",
  "me pegaron con palo",
  "me golpearon la cara",
  "me golpearon la cabeza",
  "me golpearon el cuerpo",
  "me pegaron en el estómago",
  "me pegaron en la espalda",
  "me golpearon fuerte",
  "me pegan diario",
  "me golpean seguido",
  "me maltratan siempre",
  "me agreden constantemente"
])) {
      esSituacionFuerte = true;
      mostrarBotonLlamada = true;
      telefonoAyuda = "6751035059";
      return "Lo que describes es violencia física y es algo serio. Mereces estar a salvo.$canalizacion";
    }

    if (contiene(input, [
  "bullying","acoso escolar","me molestan","se burlan de mi","me humillan",

  // Burlas
  "se ríen de mi","se rien de mi","me hacen burla","me insultan",
  "me dicen cosas feas","me ponen apodos","me dicen apodos",
  "me dicen groserías","me ofenden","me ridiculizan",
  "me exhiben","me hacen sentir menos",

  // Exclusión
  "me excluyen","me ignoran","nadie me habla",
  "no me dejan jugar","no me quieren en el grupo",
  "me dejan solo","me apartan","me rechazan",
  "no me invitan","me hacen a un lado",

  // Amenazas
  "me amenazan","me intimidan","me asustan",
  "me dicen que me van a pegar",
  "me dicen que me van a hacer algo",

  // Agresiones físicas relacionadas
  "me empujan en la escuela",
  "me pegan en la escuela",
  "me golpean en la escuela",
  "me tiran mis cosas",
  "me esconden mis cosas",
  "me rompen mis cosas",

  // Redes sociales (ciberbullying)
  "me molestan por redes",
  "me acosan por internet",
  "me insultan en redes",
  "publicaron algo de mi",
  "compartieron fotos mías",
  "me hacen memes",
  "hablan mal de mi en redes",

  // Sentimientos asociados
  "me siento humillado",
  "me siento avergonzado",
  "me siento rechazado",
  "tengo miedo de ir a la escuela",
  "no quiero ir a la escuela",
  "odio la escuela por lo que me hacen",
  "me siento solo en la escuela"
])) {
      esSituacionFuerte = true;
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento mucho que estés pasando por esto. No mereces que te traten así.$canalizacion";
    }

    if (contiene(input, [
  "ansiedad","me siento ansioso","me siento ansiosa","ataque de ansiedad",

  // Variaciones comunes
  "estoy ansioso","estoy ansiosa",
  "tengo ansiedad","sufro ansiedad",
  "me da ansiedad","me está dando ansiedad",
  "crisis de ansiedad","ataque de pánico",
  "crisis de panico","me dio un ataque",

  // Síntomas físicos
  "no puedo respirar ",
  "me late rápido el corazón",
  "me tiembla el cuerpo",
  "me tiemblan las manos",
  "me sudan las manos",
  "me falta el aire",
  "siento que no puedo respirar",
  "siento presión en el pecho",
  "me duele el pecho por nervios",
  "tengo náuseas por nervios",
  "me siento mareado",
  "me siento mareada",
  "siento un nudo en la garganta",
  "tengo opresión en el pecho",

  // Pensamientos acelerados
  "sobrepienso mucho",
  "no puedo dejar de pensar",
  "mi mente no se detiene",
  "pienso demasiado",
  "sobrepienso todo",
  "no puedo controlar mis pensamientos",
  "siento que algo malo va a pasar",
  "estoy muy nervioso",
  "estoy muy nerviosa",

  // Conductuales
  "no puedo dormir por ansiedad",
  "me cuesta dormir por nervios",
  "me siento inquieto",
  "me siento inquieta",
  "no puedo relajarme",
  "me siento desesperado",
  "me siento desesperada",
  "estoy muy alterado",
  "estoy muy alterada"
  ])){
      esSituacionFuerte = true;
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "La ansiedad puede ser muy intensa, pero no estás solo.$canalizacion";
    }
//============llamada de btn respiracion=========
    if (contiene(input, [
  "necesito calmarme",
  "quiero calmarme",
  "ayúdame a calmarme",
  "ayudame a calmarme",
  "quiero tranquilizarme",
  "estoy nervioso",
  "estoy nerviosa",
  "estoy muy nervioso",
  "estoy muy nerviosa",
  "estoy alterado",
  "estoy alterada",
  "estoy ansioso",
  "estoy ansiosa"
])) {
  esSituacionFuerte = true;
  telefonoAyuda = "6751035059";
  return "Vamos a calmarnos juntos. Puedo guiarte con un ejercicio de respiración.";
}
//============respuesta para cerrar el este de opciones====
  if (contiene(input, [
  "no quiero nada",
  "no quiero ayuda",
  "no quiero hacer nada",
  "no gracias",
  "estoy bien",
  "solo quería decirlo",
  "solo quería hablar",
  "muchas gracias",
  "no",
  "ya me siento mejor",
])) {
  return "Está bien. Estoy aquí para escucharte si deseas contarme algo más.";
}

    if (contiene(input, [
  "depresión","depresion",
  "estoy deprimido","estoy deprimida",
  "me siento deprimido","me siento deprimida",
  "me siento vacío","me siento vacio",
  "no tengo ganas de nada",
  "ya no quiero seguir",
  "no quiero vivir",
  "quisiera desaparecer",
  "me quiero morir",
  "me quiero matar",
  "quiero matarme",
  "quiero morirme",
  "no vale la pena vivir",
  "mi vida no tiene sentido",
  "no le importo a nadie",
  "me siento inútil",
  "me siento sin esperanza",
  "todo sería mejor sin mí",
  "sería mejor si no estuviera aquí"
])) {
      esSituacionFuerte = true;
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por decirlo. Lo que sientes importa y merece atención.$canalizacion";
    }

    return "Gracias por contarme cómo te sientes. Estoy aquí para escucharte.";
  }
//============popup de respiracion=========
  void mostrarPopupRespiracion(String videoPath) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        backgroundColor: const Color(0xFFB3D4CB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          height: 450,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const Text(
                "Respira conmigo",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // 👇 AQUÍ VA TU VIDEO
              Expanded(
  child: ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: VideoEjercicio(videoPath: videoPath),
  ),
),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text("Cerrar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8D77AB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
void dispose() {
  _controller.dispose();
  super.dispose();
}
//============UI=========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // SUB MENÚ SUPERIOR<==no borrar LUIS!!
      appBar: AppBar(
        toolbarHeight: 110,
        elevation: 0,
        leadingWidth: 100,
        backgroundColor: const Color(0xFFE6F0D5),
        titleSpacing: 60, // 👈 espacio entre leading y title
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
              '- L U M I -',
              style: TextStyle(
                fontSize: 20,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 252, 247),
      body: SafeArea(
  child: Column(
    children: [
      // ================= PARTE SUPERIOR FIJA =================
      SizedBox(
        height: 240,
        child: Column(
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
           Container(
  width: 190,
  height: 190,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
  ),
  child: ClipOval(
    child: VideoLumi(key: lumiKey),
  ),
)
          ],
        ),
      ),

      // ================= CHAT =================
      Expanded(
  child: ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: _mensajes.length,
    itemBuilder: (_, i) {
      final msg = _mensajes[i];

      // 👇 MENSAJE ESPECIAL PARA OPCIÓN DE CALMA
      if (msg == "Lumi_opcion_calma") {
  return Align(
    alignment: Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🟡 BURBUJA DEL MENSAJE
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFDC67F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "¿Qué quieres hacer?",
            ),
          ),

          const SizedBox(height: 8),

          // 🟣 BOTONES
          Row(
  children: [

    // 📞 BOTÓN LLAMAR
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDC67F),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: const Icon(Icons.phone),
      label: const Text("Hacer llamada"),
      onPressed: () {
        llamarAyuda();
      },
    ),

    const SizedBox(width: 10),

    // 🧘 BOTÓN RELAJARSE
    ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFDC67F),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      icon: const Icon(Icons.self_improvement),
      label: const Text("Relajarse"),
      onPressed: () {
        mostrarPopupRespiracion("assets/chat/respira.mp4");
      },
    ),
  ],
)
        ],
      ),
    ),
  );
}
      // 👇 MENSAJES NORMALES
      final esUsuario = msg.startsWith("Tú:");

      return Align(
        alignment:
            esUsuario ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.65,
    ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: esUsuario
                ? const Color(0xFF9B88B7)
                : const Color(0xFFFDC67F),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            msg.replaceFirst(esUsuario ? "Tú: " : "Lumi: ", ""),
            style: TextStyle(
              color: esUsuario ? Colors.white : Colors.black,
            ),
          ),
        ),
        ),
      );
    },
  ),
),
      // ================= INPUT =================
      Container(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          children: [
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
              color: const Color(0xFF8D77AB),
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
}
//============video de respiracion=========
class VideoEjercicio extends StatefulWidget {
  final String videoPath;

  const VideoEjercicio({super.key, required this.videoPath});

  @override
  State<VideoEjercicio> createState() => _VideoEjercicioState();
}

class _VideoEjercicioState extends State<VideoEjercicio> {
  VideoPlayerController? _controller;
  bool error = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller!.initialize();
      await _controller!.setLooping(true);
      await _controller!.play();

      if (mounted) setState(() {});
    } catch (e) {
      error = true;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (error) {
      return const Center(
        child: Text("Error cargando el video"),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}

class VideoLumi extends StatefulWidget {
  const VideoLumi({super.key});

  @override
  State<VideoLumi> createState() => _VideoLumiState();
}
//============chat imagen=========
class _VideoLumiState extends State<VideoLumi> {
  VideoPlayerController? _controller;
  bool mostrarImagen = true;
  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void reproducirAnimacion() async {
  if (_controller == null || !_controller!.value.isInitialized) return;

  setState(() {
    mostrarImagen = false;
  });

  await _controller!.seekTo(Duration.zero);
  await _controller!.play();

  final duracion = _controller!.value.duration;

  await Future.delayed(duracion);

  await _controller!.pause();

  if (mounted) {
    setState(() {
      mostrarImagen = true;
    });
  }
}

  Future<void> _initVideo() async {
    _controller = VideoPlayerController.asset(
      "assets/chat/chat-hablando.mp4",
    );

    await _controller!.initialize();
    await _controller!.setLooping(true); // 👈 se cicla
    await _controller!.pause();// 👈 inicia automático
    await _controller!.setVolume(0);
    
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  if (mostrarImagen) {
    return Image.asset(
      "assets/chat/lumi.png",
      fit: BoxFit.cover,
    );
  }

  if (_controller == null || !_controller!.value.isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  return AspectRatio(
    aspectRatio: _controller!.value.aspectRatio,
    child: VideoPlayer(_controller!),
  );
}
}