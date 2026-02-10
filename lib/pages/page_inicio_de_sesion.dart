import 'package:flutter/material.dart';
import 'page_menu.dart';
import 'page_registro_user.dart';
import 'page_carga.dart';
class InicioDeSesion extends StatefulWidget {
  const InicioDeSesion({super.key});

  @override
  State<InicioDeSesion> createState() => InicioDeSesionState();
}


class InicioDeSesionState extends State<InicioDeSesion> {
   final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
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
      emailController.dispose();
      passwordController.dispose();
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
              height: 260,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                'assets/logo_app/logo_app.png',
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
                       mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'INICIO DE SESIÓN',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,                           
                          ),
                           ),
                      ],
                    ),

                    const SizedBox(height: 60),   
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [              
                    // INPUT CORREO
                    _InputBox(
                      text: 'Ingresa tu correo electrónico',
                      controller: emailController,
                      validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                    ),

                    const SizedBox(height: 30),
                    // INPUT CONTRASEÑA
                    _InputBox(
                      text: 'Ingresa tu contraseña',
                      controller: passwordController,
                      isPassword: true,
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

                    // BOTON
                      // SIGUIENTE
                       GestureDetector(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await showLoading(context, seconds: 3);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MenuUI()),
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
                                  'Iniciar sesión',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                       
                           const SizedBox(height: 40),

                           Center( 
                            child: GestureDetector(
                            onTap: () async {
                              await showLoading(context, seconds: 3);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterUser(),
                                ),
                              );
                            },
                        
                            child: Text(
                                '¿Aún no tienes una cuenta?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple,
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