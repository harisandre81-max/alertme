import 'package:flutter/material.dart';
import 'page_menu.dart';
import 'page_registro_user.dart';
import 'page_carga.dart';
import 'package:alertme/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart'; //sesion abierta
import 'package:google_sign_in/google_sign_in.dart';
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

  //guarda la sesion
  Future<void> guardarSesion(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', true);
  await prefs.setInt('userId', userId);
  }
  Future signInWithGoogle() async {

  try {

    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn();

    if (googleUser == null) return;

    final email = googleUser.email;

    final user =
        await DatabaseHelper.instance.loginWithEmail(email);

    if (user != null) {

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user['id']);

      await showLoading(context, seconds: 2);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => MenuUI(usuarioId: user['id']),
        ),
        (route) => false,
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Este correo no está registrado en AlertMe"),
        ),
      );

    }

  } catch (e) {

    print("Error login Google: $e");

  }

}
  //limpia los campos
  @override
    void dispose() {
      emailController.dispose();
      passwordController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE6F0D5),
      body: LayoutBuilder(
      builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: constraints.maxHeight,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
           const SizedBox(height: 20),

            // LOGO / ESCUDO (PLACEHOLDER)
            Container(
              height: size.height * 0.3,
              width: size.width * 0.4,
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
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

                    SizedBox(height: size.height * 0.05),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [              
                    // INPUT CORREO
                    _InputBox(
                      text: 'Correo electrónico',
                      controller: emailController,
                      validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              return null;
                            },
                    ),

                    const SizedBox(height: 20),
                    // INPUT CONTRASEÑA
                    _InputBox(
                      text: 'Contraseña',
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

                    const SizedBox(height: 40),

                    // BOTON
                      // SIGUIENTE
                       GestureDetector(
                            onTap: () async {
                            if (_formKey.currentState!.validate()) {

                              final user = await DatabaseHelper.instance.login(
                                emailController.text,
                                passwordController.text,
                              );
                              if (user != null) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setInt('userId', user['id']); // 👈 GUARDAR SESIÓN
                                await showLoading(context, seconds: 2);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenuUI(
                                      usuarioId: user['id'],
                                    ),
                                  ),
                                  (route) => false, // 👈 elimina todo el historial
                                );

                              } else {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Correo o contraseña incorrectos'),
                                  ),
                                );
                              }
                            }
                          },

                            child: Container(
                              height: 56, 
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB562),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.login,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Iniciar sesion',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),

                            ),
                          ),  
                          const SizedBox(height: 40),
                 Row(
  children: const [
    Expanded(child: Divider()),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("o",style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple,
                                ),),
    ),
    Expanded(child: Divider()),
  ],
),
const SizedBox(height: 10),
                 Center(
  child: SizedBox(
    width: 250,
    child: ElevatedButton.icon(
      icon: Image.asset(
        'assets/google.png',
        height: 24,
      ),
      label: const Text("Continuar con Google"),
      onPressed: () async {
        await signInWithGoogle();
      },
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
                                  fontSize: 18,
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
const SizedBox(height: 70),
                 ],
              ),
             ),
            ),
          );
        },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔹 ETIQUETA ARRIBA
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 5),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple,
            ),
          ),
        ),

        // 🔹 CAMPO
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.isPassword ? _obscure : false,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.deepPurple,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
              hintText: 'ingrese sus datos...',
          hintStyle: TextStyle(
            color: Colors.deepPurple.withOpacity(0.6),
            fontSize: 18,
          ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20),

            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.deepPurple,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  )
                : null,

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
          ),
        ),
      ],
    );
  }
}