import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'page_inicio_de_sesion.dart';
import 'package:alertme/database/database_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class UserProfilePage extends StatefulWidget {
  final int usuarioId; // <-- id del usuario actual

  const UserProfilePage({super.key, required this.usuarioId});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}


class _UserProfilePageState extends State<UserProfilePage> {
  String userName = '';
  String email = '';
  String phone = '';
  String age = '';
  String city = '';
  String? fotoPath;


  String password = ''; // almacena la contraseña actual

Future<void> _loadUserData() async {
  final db = DatabaseHelper.instance;
  final usuario = await db.loginById(widget.usuarioId);

  if (usuario != null) {
    setState(() {
      userName = usuario['nombre'];
      email = usuario['email'];
      phone = usuario['telefono'];
      age = usuario['edad'].toString();
      city = usuario['direccion'];
      password = usuario['password']; 
      fotoPath = usuario['foto']; // si tu tabla tiene la columna 'foto'
      if (usuario['foto'] != null && usuario['foto'].toString().isNotEmpty) {
  _profileImage = File(usuario['foto']);
}
    });
  }
}

  Future<void> _updateUsuario() async {
  await DatabaseHelper.instance.updateUsuario(widget.usuarioId, {
    'nombre': userName,
    'email': email,
    'telefono': phone,
    'edad': int.tryParse(age) ?? 0,
    'direccion': city,
    'password': password,
  });
}

  File? _profileImage;
final ImagePicker _picker = ImagePicker();

  void _editName(BuildContext context) {
  final controller = TextEditingController(text: userName);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Editar nombre'),
      content: TextField(controller: controller),
      actions: [
         TextButton(
        onPressed: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min, // para que el Row ocupe solo el espacio necesario
          children: const [
            Icon(Icons.cancel, color: Colors.deepPurple),
            SizedBox(width: 5),
            Text('Cancelar', style: TextStyle(color: Colors.deepPurple)),
          ],
        ),
      ),
        ElevatedButton(
  onPressed: () async {
    // 1️⃣ Actualiza el estado local (síncrono)
    setState(() {
      userName = controller.text;
    });

    // 2️⃣ Actualiza la base de datos fuera de setState
    await _updateUsuario();

    // 3️⃣ Cierra el diálogo
    Navigator.pop(context);
  },
   style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.withOpacity(0.6), // opcional: cambia color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 5),
            Text('Guardar', style: const TextStyle(color: Colors.white),),
          ],
        ),
),
      ],
    ),
  );
}


  void _editField({
  required BuildContext context,
  required String title,
  required String initialValue,
  required Function(String) onSave,
})
 {
  final controller = TextEditingController(text: initialValue);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller),
      actions: [
        TextButton(
        onPressed: () => Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min, // para que el Row ocupe solo el espacio necesario
          children: const [
            Icon(Icons.cancel, color: Colors.deepPurple),
            SizedBox(width: 5),
            Text('Cancelar', style: TextStyle(color: Colors.deepPurple)),
          ],
        ),
      ),
        ElevatedButton(
  onPressed: () async {
    // 1️⃣ Primero actualiza el estado local (síncrono)
    setState(() {
      onSave(controller.text); // aquí solo cambia el valor en memoria
    });

    // 2️⃣ Luego, fuera de setState, haces la operación async
    await _updateUsuario();

    // 3️⃣ Finalmente, cierras el diálogo
    Navigator.pop(context);
  },
   style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.withOpacity(0.6), // opcional: cambia color
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.save, color: Colors.white),
            SizedBox(width: 5),
            Text('Guardar', style: const TextStyle(color: Colors.white),),
          ],
        ),
),

      ],
    ),
  );
}


  Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    final Directory appDir = await getApplicationDocumentsDirectory();

    // Nombre único
    final String fileName =
        'perfil_${widget.usuarioId}_${DateTime.now().millisecondsSinceEpoch}.png';

    final String savedPath = join(appDir.path, fileName);

    // Copiar imagen al almacenamiento interno de la app
    final File newImage = await File(image.path).copy(savedPath);

    setState(() {
      _profileImage = newImage;
      fotoPath = savedPath;
    });

    // Guardar nueva ruta en la base de datos
    await DatabaseHelper.instance.updateUsuario(widget.usuarioId, {
      'foto': savedPath,
    });
  }
}


  void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        '¿Estás seguro que deseas cerrar sesión?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: () {
            Navigator.pop(context);

            // Aquí navegas a login
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login', // asegúrate de tener esta ruta
              (route) => false,
            );
          },
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );
}
@override
void initState() {
  super.initState();
  _loadUserData(); // cargamos datos al iniciar la pantalla
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 247),
       // SUB MENÚ SUPERIOR
      appBar: AppBar(
  toolbarHeight: 110,
  elevation: 0,
  leadingWidth: 80,
  backgroundColor: const Color(0xFFE6F0D5),

  titleSpacing: 100, // 👈 espacio entre leading y title

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
    'Perfil',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
      fontSize: 20
    ),
  ),
),


      body: SingleChildScrollView(
    child: Padding(
        padding: const EdgeInsets.all(20),
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
            
             const SizedBox(height: 30),
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

            // NOMBRE
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      userName,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.deepPurple,
      ),
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () => _editName(context),
      child: const Icon(
        Icons.edit,
        size: 18,
        color: Colors.deepPurple,
      ),
    ),
  ],
),



            const SizedBox(height: 100),

            // DATOS
            _InfoTile(
              text: email,
              icon: Icons.email,
              onEdit: () => _editField(
                context: context,
                title: 'Editar email',
                initialValue: email,
                onSave: (v) async {
                  setState(() => email = v);
                  await _updateUsuario();
                },

              ),
            ),

            _InfoTile(
              text: phone,
              icon: Icons.phone,
              onEdit: () => _editField(
                context: context,
                title: 'Editar teléfono',
                initialValue: phone,
                onSave: (v) async {
                  setState(() => phone = v);
                  await _updateUsuario();
                },
              ),
            ),

            _InfoTile(
              text: age,
              icon: Icons.cake,
              onEdit: () => _editField(
                context: context,
                title: 'Editar edad',
                initialValue: age,
                onSave: (v) async {
                  setState(() => age = v);
                  await _updateUsuario();
                },
              ),
            ),

            _InfoTile(
              text: city,
              icon: Icons.location_on,
              onEdit: () => _editField(
                context: context,
                title: 'Editar ciudad',
                initialValue: city,
                onSave: (v) async {
                  setState(() => city = v);
                  await _updateUsuario();
                },
              ),
            ),
            const SizedBox(height: 40),

GestureDetector(
  onTap: () {
    _showLogoutDialog(context);
  },
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: Colors.red.shade400,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.logout, // icono referente a cerrar sesión
          color: Colors.white,
          size: 20,
        ),
        SizedBox(width: 8),
        Text(
          'Cerrar sesión',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600, fontSize: 18
          ),
        ),
      ],
    ),
  ),
),

          ],
        ),
      ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onEdit;

  const _InfoTile({
    required this.icon,
    required this.text,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(136, 255, 182, 98),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 18),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepPurple,
              ),
            ),
          ),

          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit,
              size: 18,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

