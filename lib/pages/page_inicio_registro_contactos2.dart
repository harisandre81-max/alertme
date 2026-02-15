import 'dart:io';
import 'package:flutter/material.dart';
import 'page_inicio_registro_contactos3.dart';
import 'page_menu.dart';
import 'page_carga.dart';
import 'package:alertme/database/database_helper.dart';
import 'package:image_picker/image_picker.dart';
class Contact2 extends StatefulWidget {
  final int usuarioId;

  const Contact2({
    super.key,
    required this.usuarioId,
  });

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
String? parentescoSeleccionado;

final List<String> opcionesParentesco = [
  "Madre",
  "Padre",
  "Tutor",
  "Profesor",
];


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
        MaterialPageRoute(builder: (_) => MenuUI(usuarioId: widget.usuarioId)),
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
  File? _profileImage;
final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
  );

  if (image != null) {
    setState(() {
      _profileImage = File(image.path);
    });
  }
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
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'REGISTRO DE CONTACTOS',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),     
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          'NO.2',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.deepPurple,
                          ),       
                      ),
                      ),
                      ],
                    ),
                  const SizedBox(height: 40),
                  // FOTO DE PERFIL
            Stack(
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
                          Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    // 🔹 ETIQUETA ARRIBA
    const Padding(
      padding: EdgeInsets.only(left: 8, bottom: 5),
      child: Text(
        "Parentesco",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.deepPurple,
        ),
      ),
    ),

    // 🔹 DROPDOWN
    DropdownButtonFormField<String>(
      value: parentescoSeleccionado,
      hint: const Text(
        "Selecciona el parentesco",
        style: TextStyle(
          color: Color.fromARGB(167, 104, 58, 183),
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
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
      items: opcionesParentesco.map((String opcion) {
        return DropdownMenuItem<String>(
          value: opcion,
          child: Text(
            opcion,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          parentescoSeleccionado = value;
          parentezcoController.text = value ?? "";
        });
      },
      validator: (value) =>
          value == null ? "Selecciona una opción" : null,
    ),
  ],
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

                        const SizedBox(width: 16),

                        // SIGUIENTE
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
  if (_formKey.currentState!.validate()) {

    await DatabaseHelper.instance.insertContactoLimitado({
      'usuario_id': widget.usuarioId,  // 👈 AQUÍ SE USA
      'nombre': nomController.text,
      'edad': int.parse(edadController.text),
      'telefono': telController.text,
      'parentesco': parentescoSeleccionado,
    });

    await showLoading(context, seconds: 3);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Contact3(usuarioId: widget.usuarioId),
      ),
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
        fontSize: 18,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🔹 ETIQUETA ARRIBA
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 5),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
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
