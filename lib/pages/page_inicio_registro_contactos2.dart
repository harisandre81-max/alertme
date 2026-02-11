import 'package:flutter/material.dart';
import 'page_inicio_registro_contactos3.dart';
import 'page_menu.dart';
import 'page_carga.dart';
class Contact2 extends StatefulWidget {
  const Contact2({super.key});

  @override
  State<Contact2> createState() => _Contact2State();
}

class _Contact2State extends State<Contact2> {
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
        child: Column(
          children: [

            const SizedBox(height: 20),

            // LOGO / ESCUDO (PLACEHOLDER)
            Container(
              height: 200,
              width: 120,
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
            Expanded(
              child: Container(
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
                         Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Text(
                          'CONTACTO',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),     
                      Padding(
                        padding: EdgeInsets.only(right: 100),
                        child: Text(
                          '2',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),       
                      ),
                      ),
                      ],
                    ),
                  const SizedBox(height: 20),
                     Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _InputBox(
                            text: 'Ingresa su nombre',
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
                            text: 'Ingresa su edad',
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
                            text: 'Ingresa su parentezco',
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
                            text: 'Ingresa su telefono',
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
                          onTap: () async{
                            await showLoading(context, seconds: 3);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MenuUI(),
                              ),
                            );
                          },
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD8A8),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                'OMITIR',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
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
                                  MaterialPageRoute(builder: (context) => const Contact3()),
                                );
                              }
                            },

                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB562),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  'SIGUIENTE',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,     
      validator: validator,
      
      style: const TextStyle(
        fontSize: 14,
       color: Colors.deepPurple, // ← TEXTO DEL USUARIO
     ),
      decoration: InputDecoration(
          hintText: text,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            color: Colors.deepPurple.withOpacity(0.6),
            fontSize: 14,
          ),

          helperText: ' ', // reserva espacio
          helperStyle: const TextStyle(height: 1),

           errorStyle: const TextStyle(
            height: 1,
            fontSize: 12,
           ),

          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        
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
    );
  }
}