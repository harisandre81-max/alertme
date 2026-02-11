import 'package:flutter/material.dart';
import 'page_menu.dart';
import 'page_inicio_registro_contactos.dart';
import 'page_terminos_y_condiciones.dart';
import 'page_carga.dart';
class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
   final TextEditingController nomController = TextEditingController();
    final TextEditingController edadController = TextEditingController();
    final TextEditingController telController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController dirController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool acceptTerms = false;

    Future<void> showLoading(BuildContext context, {int seconds = 3}) async {
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingScreen(),
    );

    await Future.delayed(Duration(seconds: seconds));

    Navigator.of(context).pop(); // cerrar loading
    }


  @override
    void dispose() {
      nomController.dispose();
      edadController.dispose();
      telController.dispose();
      emailController.dispose();
      passwordController.dispose();
      dirController.dispose();
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
            // LOGO / ESCUDO (PLACEHOLDER)
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      // BOTÓN REGRESAR
      IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.deepPurple,
          size: 28,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      const SizedBox(width: 85),

      // LOGO
      Container(
              height: 90,
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

      const Spacer(),
    ],
  ),
),


            const SizedBox(height: 15),

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
                    // TITULO + PASO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                         Padding(
                        padding: EdgeInsets.only(left: 110),
                        child: Text(
                          'REGISTRATE',
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
                            text: 'Ingresa tu nombre',
                            controller: nomController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _InputBox(
                            text: 'Ingresa tu edad',
                            controller: edadController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 15),
                          _InputBox(
                            text: 'Ingresa tu dirección',
                            controller: dirController,
                            keyboardType: TextInputType.streetAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _InputBox(
                            text: 'Ingresa tu correo electrónico',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _InputBox(
                            text: 'Ingresa tu telefono',
                            controller: telController,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _InputBox(
                            text: 'Ingresa tu contraseña',
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 10),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 20),
                              Checkbox(
                                value: acceptTerms,
                                activeColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    acceptTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const TerminosUIPage(),
                                      ),
                                    );
                                  },
                                  child: RichText(
          
                                    text: TextSpan(
                                      text: 'Acepto los ',
                                      style: TextStyle(
                                        color: Colors.deepPurple.withOpacity(0.7),
                                        fontSize: 14,
                                          height: 2.4,
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Términos y Condiciones',
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                          ),
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

                    // BOTONES
                    // SIGUIENTE
                          GestureDetector(
                            onTap: () async  {
                              if (_formKey.currentState!.validate()) {
                                 if (!acceptTerms) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Debes aceptar los términos y condiciones'),
                                      ),
                                    );
                                    return;
                                  }

                                await showLoading(context, seconds: 3);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Contact()),
                                );
                              }
                            },
                            child: Container(
                              height: 56, 
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB562),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
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
class _InputBox extends StatefulWidget {
    final String text;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;

  const _InputBox({
    required this.text,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });
   @override
  State<_InputBox> createState() => _InputBoxState();
}
  
  class _InputBoxState extends State<_InputBox> {
    bool _obscure = true;

  @override
  Widget build(BuildContext context) {
     return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      obscureText: widget.isPassword ? _obscure : false,
      style: const TextStyle(fontSize: 14, color: Colors.deepPurple),
      decoration: InputDecoration(
        hintText: widget.text,
        filled: true,
        fillColor: Colors.white,
        hintStyle: TextStyle(
            color: Colors.deepPurple.withOpacity(0.6),
            fontSize: 14,
          ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.deepPurple,
                ),
                onPressed: () {
                  setState(() => _obscure = !_obscure);
                },
              )
            : null,

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