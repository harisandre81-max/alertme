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
  // Directas
  "me pegan",
  "me golpean",
  "me agreden",
  "me lastiman",
  "me maltratan",
  "me golpearon",

  // Acciones físicas
  "me empujan",
  "me empujaron",
  "me patean",
  "me patearon",
  "me dieron un golpe",
  "me dieron golpes",
  "me cachetean",
  "me cachetearon",
  "me jalonean",
  "me jalaron",
  "me agarran fuerte",
  "me sacuden",
  "me aventaron",
  "me aventaron contra la pared",
  "me tiraron al suelo",
  "me ahorcaron",
  "me apretaron el cuello",

  // Consecuencias
  "me dejaron moretones",
  "tengo moretones",
  "tengo marcas",
  "me dejaron marcas",
  "me sangró la nariz",
  "me sangré",
  "me duele el cuerpo",
  "me duele por los golpes",
  "tengo heridas",
  "me lastimaron la cara",

  // Indirectas / sutiles
  "me lastiman cuando se enojan",
  "pierden el control conmigo",
  "se desquitan conmigo",
  "me empujan sin querer",
  "me agarran cuando discuten",

  // Modismos (MX)
  "me madrearon",
  "me pusieron una madriza",
  "me dieron una madriza",
  "me pegaron feo",
  "me zarandearon",
  "me dieron una cachetada"
  // Modismos mexicanos comunes
  "me dieron una madriza",
  "me pusieron una madriza",
  "me madrearon",
  "me acomodaron",
  "me dieron en la madre",
  "me surtieron",
  "me pusieron una chinga",
  "me dieron una chinga",
  "me pegaron feo",
  "me pegaron duro",
  "me pegaron macizo",
  "me agarraron a golpes",
  "me agarraron a madrazos",
  "me dieron de madrazos",
  "me dieron de golpes",

  // Golpes específicos
  "me dieron un putazo",
  "me soltaron un putazo",
  "me dieron un trancazo",
  "me soltaron un trancazo",
  "me dieron un chingadazo",
  "me metieron un golpe",
  "me acomodaron un golpe",

  // Empujones y jaloneos
  "me aventaron",
  "me aventaron feo",
  "me empujaron recio",
  "me zarandearon",
  "me zarandearon gacho",
  "me jalonearon",
  "me jalonearon feo",

  // Daño visible
  "me dejaron todo moreteado",
  "me dejaron todo golpeado",
  "me dejaron hinchado",
  "me dejaron sangrando",
  "me dejaron tirado",
  "me dejaron tirada",

  // Frases muy coloquiales
  "me dieron hasta para llevar",
  "me dieron como piñata",
  "me dieron como costal",
  "me dejaron bien madreado",
  "me dejaron bien golpeado",
  "me dejaron mal",

  // Minimización (igual es violencia)
  "nomás fue un golpe",
  "solo me empujaron",
  "solo fue un jalón",
  "fue un arranque"
])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6751035059";
      return "Lo que describes es violencia física y es algo serio. "
          "Mereces estar a salvo.$canalizacion";
    }

    // ================= BULLYING =================
 if (contiene(input, [
  // Palabras formales
  "bullying",
  "acoso escolar",
  "acoso en la escuela",
  "Sufro de acoso escolar"
  // Directas
  "me molestan",
  "me molestaron",
  "se burlan de mi",
  "se burlaron de mi",
  "me humillan",
  "me humillaron",
  "me insultan",
  "me insultaron",
  "me excluyen",
  "me excluyeron",
  "me ignoran",
  "me ignoran siempre",
  "me hacen a un lado",
  "me siento rechazado",
  "me siento rechazado en la escuela",

  // Redes sociales
  "se burlan de mi en redes",
  "me atacan en redes",
  "me molestan por internet",
  "me tiran hate",
  "me hacen memes",
  "me exhiben",

  // Modismos mexicanos
  "me carrillean",
  "me agarran de bajada",
  "me traen de su puerquito",
  "se pasan conmigo",
  "me tratan mal en la escuela",
  "me hacen menos",
  "me tiran carrilla pesada",

  // Frases comunes con faltas
  "se burlan d mi",
  "se burlan de mii",
  "me ignorran",
  "me umillan",
  "me insultan feo"
])){
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento mucho que estés pasando por esto. "
          "No mereces que te traten así.$canalizacion";
    }

    // ================= VIOLENCIA EN CASA =================
    if (contiene(input, [
      // Control y miedo
"me tienen miedo en casa",
"tengo miedo de llegar a mi casa",
"me da miedo estar en mi casa",
"no me siento seguro en mi casa",
"camino con cuidado en mi casa",

// Amenazas
"me amenazan en casa",
"me dicen que me van a pegar",
"me dicen que me calle",
"me amenazan con correrme",
"me dicen que me vaya de la casa",

// Castigos y encierro
"me castigan con golpes",
"me encierran",
"me dejan sin comer",
"me quitan mis cosas",
"me quitan el celular",
"me quitan mis cosas si hablo",

// Violencia psicológica
"me hacen sentir inútil",
"me dicen que no sirvo",
"me comparan todo el tiempo",
"me menosprecian",
"me humillan frente a la familia",
"se burlan de mi en casa",

// Pareja (si vive en casa)
"mi pareja me pega",
"mi novio me pega",
"mi novia me pega",
"mi esposo me pega",
"mi esposa me pega",
"mi pareja me grita",
"mi pareja me humilla",

// Alcohol / enojo
"cuando toma se pone violento",
"cuando se enoja me pega",
"cuando se emborracha me grita",
"pierde el control en casa",

// Frases normalizadas
"es por mi bien",
"me pegan para corregirme",
"así educan en mi casa",
"si no obedezco me pegan",
"dicen que me lo merezco",

// Lenguaje muy coloquial MX
"me tratan culero en mi casa",
"me hablan bien feo",
"me gritan bien gacho",
"me ponen unas chingas",
"me traen cortito",
"me traen a pan y agua",
"me tienen de su pendejo",

// Escritura con errores comunes
"me pegan en kasa",
"me gritan bn feo",
"mi papa m grita",
"mi mama m grita",
"me ase sentir mal",
"me amenazan en ksa"
    ])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Gracias por confiar en mí. "
          "Tu casa debería ser un lugar seguro.$canalizacion";
    }

    // ================= ANSIEDAD =================
   if (contiene(input, [
  // Palabra clave
  "ansiedad",

  // Directas
  "me siento ansioso",
  "me siento ansiosa",
  "me da ansiedad",
  "tengo ansiedad",
  "siento ansiedad",
  "ataque de ansiedad",
  "ataque de panico",
  "ataque de pánico",

  // Síntomas físicos
  "no puedo respirar",
  "me falta el aire",
  "siento que no respiro",
  "me duele el pecho",
  "siento presión en el pecho",
  "mi corazón late rápido",
  "me tiembla el cuerpo",
  "me tiemblan las manos",
  "me sudan las manos",
  "me mareo",
  "me siento mareado",
  "me dan náuseas",
  "me dan ganas de vomitar",

  // Sensaciones mentales
  "me siento muy nervioso",
  "me siento muy nerviosa",
  "me siento inquieto",
  "no puedo estar tranquilo",
  "no puedo relajarme",
  "siento que algo malo va a pasar",
  "tengo miedo sin razón",
  "siento desesperación",

  // Pensamientos comunes
  "siento que me voy a morir",
  "siento que me voy a desmayar",
  "siento que pierdo el control",
  "siento que me vuelvo loco",
  "siento que me estoy volviendo loco",

  // Frases coloquiales MX
  "ando bien ansioso",
  "ando bien nervioso",
  "ando bien alterado",
  "ando acelerado",
  "ando intranquilo",
  "me siento bien sacado de onda",

  // Normalización (igual es ansiedad)
  "solo estoy nervioso",
  "solo es estrés",
  "es estrés",
  "mucho estrés",
  "estrés acumulado",

  // Escritura con faltas
  "ansieda",
  "anciedad",
  "me siento ansiozo",
  "me siento nerviozo",
  "no puedo respirrar",
  "me falta el ayre",
  "ataqe de ansiedad"
])) {
      mostrarBotonLlamada = true;
      telefonoAyuda = "6758670579";
      return "Siento que te estés sintiendo así . "
          "La ansiedad puede ser muy intensa, pero no estás solo.$canalizacion";
    }

    if (contiene(input, [
  // Palabra clave
  "depresión",
  "depresion",

  // Directas
  "me siento deprimido",
  "me siento deprimida",
  "estoy deprimido",
  "estoy deprimida",
  "me siento vacío",
  "me siento vacía",
  "me siento sin ganas",
  "no tengo ganas de nada",
  "no quiero hacer nada",
  "todo me da igual",

  // Tristeza profunda
  "estoy muy triste",
  "me siento muy triste",
  "lloro todo el tiempo",
  "tengo ganas de llorar siempre",
  "me siento apagado",
  "me siento apagada",

  // Cansancio emocional
  "estoy cansado de todo",
  "estoy cansada de todo",
  "ya no puedo",
  "ya no aguanto",
  "todo me pesa",
  "vivir me pesa",

  // Desesperanza
  "ya no quiero seguir",
  "no le veo sentido a nada",
  "no vale la pena seguir",
  "siento que nada va a cambiar",
  "siento que todo es inútil",
  "siento que no sirvo",

  // Aislamiento
  "no quiero ver a nadie",
  "me alejo de todos",
  "me siento solo",
  "me siento sola",
  "nadie me entiende",
  "siento que no le importo a nadie",

  // Autodesprecio
  "me odio",
  "me siento un estorbo",
  "soy un fracaso",
  "no sirvo para nada",
  "todo es mi culpa",

  // Ideación suicida (ALTA GRAVEDAD)
  "me quiero morir",
  "quiero morirme",
  "me quiero matar",
  "quiero matarme",
  "no quiero vivir",
  "ojalá no despertara",
  "sería mejor no existir",
  "quisiera desaparecer",

  // Lenguaje coloquial MX
  "ando bien triste",
  "ando bien bajoneado",
  "ando bien bajoneada",
  "ando bien mal",
  "me siento de la chingada",
  "me siento bien culero",

  // Escritura con errores
  "deprecion",
  "me siento deprimio",
  "me siento deprimia",
  "me siento vacio",
  "me siento basio",
  "ya no kiero seguir",
  "me kiero morir",
  "me kiero matar"
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
          'Chatbot -  Lumi',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
            fontSize: 20
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
