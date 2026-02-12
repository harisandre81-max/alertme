import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});
  
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String userName = 'Luis Fernando Herrera';
  String email = 'luis@email.com';
  String phone = '555 555 5555';
  String age = '25';
  String city = 'Ciudad de México';

  
  File? _profileImage;
final ImagePicker _picker = ImagePicker();

  void _editName(BuildContext context) {
    final controller = TextEditingController(text: userName);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nombre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nombre completo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _editField({
  required String title,
  required String initialValue,
  required Function(String) onSave,
}) {
  final controller = TextEditingController(text: initialValue);

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => onSave(controller.text));
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}


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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 252, 247),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFE6F0D5),
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: SingleChildScrollView(
    child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
             const SizedBox(height: 30),

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
                title: 'Editar email',
                initialValue: email,
                onSave: (v) => email = v,
              ),
            ),

            _InfoTile(
              text: phone,
              icon: Icons.phone,
              onEdit: () => _editField(
                title: 'Editar teléfono',
                initialValue: phone,
                onSave: (v) => phone = v,
              ),
            ),

            _InfoTile(
              text: age,
              icon: Icons.cake,
              onEdit: () => _editField(
                title: 'Editar edad',
                initialValue: age,
                onSave: (v) => age = v,
              ),
            ),

            _InfoTile(
              text: city,
              icon: Icons.location_on,
              onEdit: () => _editField(
                title: 'Editar ciudad',
                initialValue: city,
                onSave: (v) => city = v,
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
          const SizedBox(width: 12),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
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

