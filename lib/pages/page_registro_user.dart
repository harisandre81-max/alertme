import 'dart:io';
import 'package:alertme/pages/page_inicio_de_sesion.dart';
import 'package:flutter/material.dart';
import 'page_inicio_registro_contactos.dart';
import 'page_terminos_y_condiciones.dart';
import 'page_carga.dart';
import 'package:alertme/database/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';

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

//==================FUNCION PARA PEDIR PERMISOS================
Future<void> _requestInitialPermissions() async {
  final Location location = Location();

  // 📍 UBICACIÓN
  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    await location.requestPermission();
  }

  print("Permisos solicitados al registrarse");
}

//==================PANTALLA DE CARGA================
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
    //==================CONVERTIDOR DE IMAGENES A UN FORMATO MENOS PESADO================
  File? _profileImage;
final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 600,       // ancho máximo
    maxHeight: 600,      // alto máximo
    imageQuality: 85,    // calidad de compresión (0-100)
  );

  if (image != null) {
    setState(() {
      _profileImage = File(image.path);
    });
  }
}
          

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE6F0D5),
      body: SafeArea(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      // LOGO
        Center(
      child: Container(
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
        ),

            const SizedBox(height: 15),

            
        // CARD
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6E3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Center(
                child: Text(
                  'REGÍSTRATE',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),

                  const SizedBox(height: 40),
                   // FOTO DE PERFIL
                  // FOTO DE PERFIL
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: const Color.fromARGB(136, 255, 182, 98),
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : const AssetImage('assets/avatar.png') as ImageProvider,
                          ),
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                              print('Editar foto');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.deepPurple,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _InputBox(
                            text: 'Nombre completo',
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
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          _InputBox(
                            text: 'Dirección',
                            controller: dirController,
                            keyboardType: TextInputType.streetAddress,
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

                          const SizedBox(height: 20),

                          _InputBox(
                            text: 'Correo electrónico',
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Ingresa un correo válido';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _InputBox(
                            text: 'Contraseña',
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obligatorio';
                              }
                              if (value.length < 8) {
                                return 'Debe tener al menos 8 caracteres';
                              }

                              final passwordRegex = RegExp(
                                r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&._-])[A-Za-z\d@$!%*?&._-]{8,}$',
                              );

                              if (!passwordRegex.hasMatch(value)) {
                                return 'Debe contener letras, números y un carácter especial';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 40),

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
                            onTap: () async {
                            if (_formKey.currentState!.validate()) {

                              if (!acceptTerms) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Debes aceptar los términos y condiciones'),
                                  ),
                                );
                                return;
                              }
    

                              try {
                                final fotoPath = _profileImage?.path ?? 'assets/avatar.png';
                                // 🔹 GUARDAR USUARIO EN SQLITE
                                String hashedPassword = BCrypt.hashpw(
                                passwordController.text,
                                BCrypt.gensalt(),
                              );

                                final userId = await DatabaseHelper.instance.insertUsuario({
                                  'nombre': nomController.text,
                                  'edad': int.parse(edadController.text),
                                  'direccion': dirController.text,
                                  'telefono': telController.text,
                                  'email': emailController.text,
                                  'password': hashedPassword,
                                  'foto': fotoPath, // nunca será null
                                });

                                // 👇 PEDIR PERMISOS AQUÍ
                                await _requestInitialPermissions();

                                // 🔹 GUARDAR SESIÓN AUTOMÁTICAMENTE
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setInt('userId', userId);

                                await showLoading(context, seconds: 2); //pantalla de carga

                                // 🔹 PASAR EL ID AL REGISTRO DE CONTACTO
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Contact(usuarioId: userId),
                                  ),
                                  (route) => false,
                                );

                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al registrar usuario: $e'),
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
                              child: const Center(
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.person_add_alt_1,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Registrarse',
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
                          ),
                          const SizedBox(height: 40),
                          Center( 
                            child: GestureDetector(
                            onTap: () async {
                              await showLoading(context, seconds: 3);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const InicioDeSesion(),
                                ),
                              );
                            },
                        
                            child: Text(
                                '¿Ya tienes una cuenta?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepPurple,
                                ),
                              ),

                          ),
                           ),
                  ],
                ),
              ),
            ],
         ),
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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      // 🔹 ETIQUETA ARRIBA
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 5),
        child: Text(
          widget.text, // este será el título
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
      ),

      // 🔹 CAMPO DE TEXTO
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          
           // 👇 ICONO DE OJITO
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

          helperText: ' ', // 👈 RESERVA ESPACIO
          helperStyle: const TextStyle(height: 0.8),

          errorStyle: const TextStyle(
            height: 1,
            fontSize: 14,
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