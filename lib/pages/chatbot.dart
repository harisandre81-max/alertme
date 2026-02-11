import 'package:flutter/material.dart';

void main() {
  runApp(const ChatBotApp());
}

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
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _yaSaludo = false;

  final List<String> _respuestasSugeridas = [
    "Me siento mal",
    "Me pegan",
    "Me insultan",
    "Me molestan en la escuela",
    "Pasa en mi casa",
    "Tengo miedo"
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      Message(
        text:
            "Bienvenido a AlertMe.\nSoy Lumi y estoy aquí para escucharte y orientarte.",
        isUser: false,
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });

    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 300), () {
      final reply = chatbotResponse(text);
      setState(() {
        _messages.add(Message(text: reply, isUser: false));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String chatbotResponse(String input) {
    input = input.toLowerCase();

    if (!_yaSaludo) {
      _yaSaludo = true;
      return "Hola. Cuéntame qué está pasando.";
    }

    if (_contains(input, ["me golpean", "me pegan", "", "me empujan"])) {
      return """
Tipo de violencia identificado: Violencia física.

Nadie tiene derecho a hacerte daño.
Busca ayuda inmediata con un adulto de confianza
o autoridades.
""";
    }

    if (_contains(input, ["insultan", "me gritan", "me humillan"])) {
      return """
Tipo de violencia identificado: Violencia psicológica.

Las palabras también causan daño.
Hablar con alguien de confianza puede ayudarte.
""";
    }

    if (_contains(input, ["me controlan", "me ignoran", "me manipulan"])) {
      return """
Tipo de violencia identificado: Violencia emocional.

El control no es normal.
Busca apoyo emocional y orientación.
""";
    }

    if (_contains(input, ["abuso", "me obligaron", "me tocaron","me Violaron"])) {
      return """
Tipo de violencia identificado: Violencia sexual.

Esto es grave y no es tu culpa.
Busca ayuda inmediata con autoridades o personal especializado.
""";
    }

    if (_contains(input, ["en mi casa", "mi familia", "mi papá", "mi mamá"])) {
      return """
Tipo de violencia identificado: Violencia doméstica.

La violencia en el hogar no es normal.
Busca apoyo con familiares, maestros o instituciones.
""";
    }

    if (_contains(input, ["escuela", "bullying", "me molestan"])) {
      return """
Tipo de violencia identificado: Violencia escolar.

No estás solo.
Informa a un maestro u orientador escolar.
""";
    }

    return "Te escucho. Puedes contarme un poco más.";
  }

  bool _contains(String input, List<String> words) {
    for (final word in words) {
      if (input.contains(word)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // BOTÓN REGRESAR
       backgroundColor: const Color(0xFFE6EED2),
  leading: IconButton(
    icon: const Icon(
      Icons.arrow_back,
      color: Colors.deepPurple,
      size: 28,
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
       title: const Text(
    "AlertMe • Lumi",
    style: TextStyle(color: Colors.deepPurple),
  ),
    centerTitle: false, // opcional
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
            color: const Color(0xFFF9F6E6),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          ),
          _sugerencias(),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _sugerencias() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _respuestasSugeridas.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDC67F),
                foregroundColor: Colors.black,
              ),
              onPressed: () =>
                  _sendMessage(_respuestasSugeridas[index]),
              child: Text(_respuestasSugeridas[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      //padding: const EdgeInsets.fromLTRB(8, 6, 8, 20),
      color: const Color(0xFFF9F6E6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Escribe un mensaje...",
                border: InputBorder.none,
              ),
              onSubmitted: (value) => _sendMessage(value),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: const Color(0xFF8D77AB),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
  
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final Message message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF8D77AB)
              : const Color(0xFFFDC67F),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
