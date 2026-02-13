import 'package:flutter/material.dart';
import 'page_inicio_registro_contactos2.dart';
import 'page_menu.dart';
import 'page_carga.dart';
class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
   final TextEditingController nomController = TextEditingController();
    final TextEditingController edadController = TextEditingController();
    final TextEditingController telController = TextEditingController();
    final TextEditingController parentezcoController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

  
  Future<void> showLoading(BuildContext context, {int seconds = 3}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingScreen(),
  );

  await Future.delayed(Duration(seconds: seconds));
  Navigator.of(context).pop();
}
  void mostrarDialogoContactos() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Necesitas registrar tus contactos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        content: const Text(
          'Debes registrar tus contactos de emergencia para poder usar la app.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // solo cierra el dialogo
            },
            child: const Text(
              'Hacerlo ahora',
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // cerrar dialogo
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MenuUI()),
              );
            },
            child: const Text(
              'Hacerlo más tarde',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

void mostrarDialogoContactos() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Necesitas registrar tus contactos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        content: const Text(
          'Debes registrar tus contactos de emergencia para poder usar la app.',
        ),
        actions: [
  TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.edit,
          color: Colors.deepPurple,
          size: 18,
        ),
        SizedBox(width: 6),
        Text(
          'Hacerlo ahora',
          style: TextStyle(color: Colors.deepPurple),
        ),
      ],
    ),
  ),

  ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuUI()),
      );
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(
          Icons.schedule,
          color: Colors.white,
          size: 18,
        ),
        SizedBox(width: 6),
        Text(
          'Hacerlo más tarde',
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  ),
],

      );
    },
  );
}


  @override
    void dispose() {
      nomController.dispose();
      edadController.dispose();
      telController.dispose();
      parentezcoController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFE6F0D5),

      body: SafeArea(
         child: SingleChildScrollView(
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

            // LOGO / ESCUDO (PLACEHOLDER)
            Container(
              height: 150,
              width: 140,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/logo_inter/logo.png',
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            // CARD PRINCIPAL
           Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF6E3),
                  borderRadius: BorderRadius.circular(30),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // TITULO + PASO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
<<<<<<< HEAD
                         Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'REGISTRO DE CONTACTOS',
=======
                           Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Text(
                          'Registro de contactos',
>>>>>>> d801475763a74121f3d1879fc99bb40822e0f717
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),         
                      Padding(
<<<<<<< HEAD
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'NO.1',
=======
                        padding: EdgeInsets.only(right: 50),
                        child: Text(
                          'contacto no 1',
>>>>>>> d801475763a74121f3d1879fc99bb40822e0f717
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),       
                      ),
                      ),
                      ],
                    ),
                  const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _InputBox(
                            text: 'Nombre',
                            controller: nomController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _InputBox(
                            text: 'Edad',
                            controller: edadController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              final edad = int.tryParse(value);
                              if (edad == null || edad < 18) {
                                return 'Debe ser mayor de 18 años';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),
                          _InputBox(
                            text: 'Parentezco',
                            controller: parentezcoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _InputBox(
                            text: 'Telefono',
                            controller: telController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    // BOTONES
                    Row(
                      children: [

                        // OMITIR
                       Expanded(
                        child: GestureDetector(
                          onTap: () async {
                              mostrarDialogoContactos();
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD8A8),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      Icons.skip_next_rounded,
      color: Colors.white,
      size: 20,
    ),
    SizedBox(width: 8),
    Text(
      'OMITIR',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
  ],
),

                          ),
                        ),
                      ),

                        const SizedBox(width: 16),

                        // SIGUIENTE
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await showLoading(context, seconds: 3);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Contact2()),
                                );
                              }
                            },

                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB562),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'SIGUIENTE',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    SizedBox(width: 8),
    Icon(
      Icons.arrow_forward_rounded,
      color: Colors.white,
      size: 20,
    ),
  ],
),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }
}


// INPUT VISUAL 
class _InputBox extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const _InputBox({
    required this.text,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔹 ETIQUETA ARRIBA
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 5),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ),

        // 🔹 CAMPO
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.deepPurple,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
              hintText: 'ingrese sus datos...',
          hintStyle: TextStyle(
            color: Colors.deepPurple.withOpacity(0.6),
            fontSize: 14,
          ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20),

            helperText: ' ',
            helperStyle: const TextStyle(height: 0.8),

            errorStyle: const TextStyle(
              height: 1,
              fontSize: 12,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
