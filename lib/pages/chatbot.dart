import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

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

  // ================= RESPIRACIÓN =================
  bool respirando = false;
  double tamanioCirculo = 80;
  Timer? _timer;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void toggleRespiracion() async {
    if (respirando) {
      // 🔻 FADE OUT
      for (double v = 1.0; v >= 0; v -= 0.05) {
        await _audioPlayer.setVolume(v);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      await _audioPlayer.stop();
      _timer?.cancel();
    } else {
      await _audioPlayer.setVolume(0);
      await _audioPlayer.play(AssetSource('audio/relax.mp3'));

      // 🔺 FADE IN
      for (double v = 0; v <= 0.3; v += 0.03) {
        await _audioPlayer.setVolume(v);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _timer = Timer.periodic(const Duration(milliseconds: 4900), (timer)  {
        setState(() {
          tamanioCirculo = tamanioCirculo == 80 ? 150 : 80;
        });
      });
    }

    setState(() {
      respirando = !respirando;
    });
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
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "La ansiedad puede ser muy intensa, pero no estás solo.$canalizacion";
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
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por decirlo. Lo que sientes importa y merece atención.$canalizacion";
    }

    return "Gracias por contarme cómo te sientes. Estoy aquí para escucharte.";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0D5),
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Image.asset(
              'assets/chat/lumi.png',
              width: 200,
            ),

            const SizedBox(height: 10),

            const Text(
              '- L U M I -',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),

            const SizedBox(height: 15),

            AnimatedContainer(
              duration: const Duration(seconds: 4),
              width: tamanioCirculo,
              height: tamanioCirculo,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8D77AB).withOpacity(0.4),
              ),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: toggleRespiracion,
              child: Text(
                respirando ? "Detener respiración" : "Calmarme",
              ),
            ),

            const SizedBox(height: 10),

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
                        msg.replaceFirst(esUsuario ? "Tú: " : "Lumi: ", ""),
                        style: TextStyle(
                          color: esUsuario ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (mostrarBotonLlamada)
              ElevatedButton.icon(
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