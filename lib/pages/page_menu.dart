import 'package:flutter/material.dart';
import 'page_user_data.dart';
import 'chatbot.dart';
import 'page_carga.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:telephony/telephony.dart';


 final Telephony telephony = Telephony.instance;
 Location location = Location();

//Fin del codigo de verificacion de permisos de ubicacion

//Inicio de la funcion de mensaje y ubicacion
 void mostrarubicacion() async{
  LocationData datos = await location.getLocation();

  print('Latitud: ${datos.latitude}');
  print('Longitud: ${datos.longitude}');
  print('Altitud: ${datos.altitude}');

  String ubicacion = "https://maps.google.com/?q=${datos.latitude},${datos.longitude}";

  await telephony.sendSms(to: '6751035059', message: 'Ayuda, estoy en peligro' + '\nMi ubcacion es: $ubicacion' );

 }

class MenuUI extends StatefulWidget {
  const MenuUI({super.key});

  @override
  State<MenuUI> createState() => _MenuUIState();
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 24),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuUIState extends State<MenuUI> {

  final ScrollController _scrollController = ScrollController();

  Future<void> showLoading(BuildContext context, {int seconds = 3}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingScreen(),
  );

  await Future.delayed(Duration(seconds: seconds));
  Navigator.of(context).pop();
  }

  Future<bool> checkLocation() async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return false;
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return false;
  }

  return true;
}

 Future<LocationData?> ubicacion() async{
  if(!await checkLocation()) return null;
  return await location.getLocation();

 }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

      // SUB MENÚ SUPERIOR
      appBar: AppBar(
        toolbarHeight: 110,
        elevation: 0,
  leadingWidth: 80,
        backgroundColor: const Color(0xFFE6F0D5),
        leading: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
      'assets/logo_inter/logo.png',
      width: 70,
      height: 70,
      fit: BoxFit.contain,
    ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(

              icon: const Icon(
                size: 43,
                Icons.person,
                color: Color(0xFFFFB562),
              ),
              onPressed: () async{
                await showLoading(context, seconds: 3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),


      body: Stack(
  children: [

    // ===============================
    // CONTENIDO NORMAL (CON SCROLL)
    // ===============================
    Column(
      children: [

        const SizedBox(height: 20),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
              const SizedBox(height: 20),
                // TU CONTENEDOR HORIZONTAL
                Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [

    // HEADER estilo "Reels"
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          Icon(Icons.contact_page, 
              color: Colors.deepPurple, size: 24),
          SizedBox(width: 8),
          Text(
            "Contactos de emergencia",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    ),

    const SizedBox(height: 15),

    Center(
      child: ContactSlider(), // 👈 Nuevo widget
    ),
  ],
),

                const SizedBox(height: 40),

const SectionHeader(
  title: "Infografías",
  icon: Icons.menu_book,
),

const SizedBox(height: 15),

                const HorizontalButtonSlider(),
                
                const SizedBox(height: 40),

                const SectionHeader(
               title: "Instituciones de apoyo",
               icon: Icons.local_hospital,
               ),  
                const SizedBox(height: 15), 
                Column(
  children: [
    _VerticalBox(
  text: 'DIF',
  onTap: () {
    showDetailCard(
      context,
      InstitucionInfo(
        name: 'Sistema DIF',
        phone: '911',
        address: 'Zona Centro',
        description: 'Institución pública...',
        image: 'assets/avatar.png',
      ),
    );
  },

  phoneNumber: '911',

  onPhoneTap: () async {
    final uri = Uri.parse('tel:911');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  },
),
    const SizedBox(height: 20),
    _VerticalBox(
      text: '911',
      onTap: () {
    showDetailCard(
      context,
      InstitucionInfo(
        name: 'Fechter',
        phone: '+88 01828 9457 20',
        address: 'Ciudad de México',
        description: 'Contacto de confianza para emergencias.',
        image: 'assets/avatar.png',
      ),
    );
  },
  phoneNumber: '911',

  onPhoneTap: () async {
    final uri = Uri.parse('tel:911');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  },
    ),
    const SizedBox(height: 20),

    _VerticalBox(
      text: 'Proteción civil',
      onTap: () {
    showDetailCard(
      context,
      InstitucionInfo(
        name: 'Josh Fer',
        phone: '+88 01828 9457 20',
        address: 'Ciudad de México',
        description: 'Contacto de confianza para emergencias.',
        image: 'assets/avatar.png',
      ),
    );
  },
  phoneNumber: '911',

  onPhoneTap: () async {
    final uri = Uri.parse('tel:911');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  },
    ),
  ],
),

                const SizedBox(height: 60), // espacio para el menú inferior
              ],
            ),
          ),
        ),

        
    // ===============================
    // SUB MENÚ INFERIOR (FIJO)
    // ===============================
    Container(
      height: 100,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFE6F0D5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      
      child: Center(
  child: SizedBox(
    width: 100,
    height: 100,
    child: ElevatedButton(
      onPressed: mostrarubicacion,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 98, 98),
        shape: const CircleBorder(),
        elevation: 8,
      ),
      child: const Text(
  "SOS",
  style: TextStyle(
    color: Colors.white,
    fontSize: 29,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  ),
),
    ),
  ),
),

    ),
      ],
    ),

    // ===============================
    // BOTÓN FLOTANTE FIJO
    // ===============================
    Positioned(
      right: 20,
      top: MediaQuery.of(context).size.height / 2 - 20,
      child: GestureDetector(
        onTap: () async {
          await showLoading(context, seconds: 3);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatBotApp(),
            ),
          );
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color:  Color(0xFFFFB562),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    ),
  ],
),


    );
  }
}

class ContactCard extends StatefulWidget {
  const ContactCard({super.key});

  @override
  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  String nombre = 'Luis';
  String edad = '19';
  String parentesco = 'Amigo';
  String telefono = '6751035059';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 251),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Padding(
    padding: const EdgeInsets.only(left: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text( nombre,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E3AA1),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20,
                      color: Color(0xFF5E3AA1),),
                      onPressed: _editCard,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                 Text('Edad: $edad', style: const TextStyle(color: Color(0xFF5E3AA1),fontSize: 18)),
                 Text('Parentezco: $parentesco', style: const TextStyle(color: Color(0xFF5E3AA1),fontSize: 18)),
                 Text(telefono, style: const TextStyle(color: Color(0xFF5E3AA1),fontSize: 18)),

              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
    void _editCard() {
    final nameCtrl = TextEditingController(text: nombre);
    final ageCtrl = TextEditingController(text: edad);
    final relationCtrl = TextEditingController(text: parentesco);
    final phoneCtrl = TextEditingController(text: telefono);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
       builder: (_) => Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: const EdgeInsets.only(top: 150),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: 'Edad')),
            TextField(controller: relationCtrl, decoration: const InputDecoration(labelText: 'Parentezco')),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono')),
            const SizedBox(height: 16),
            Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    TextButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Cancelar'),
    ),
    const SizedBox(width: 8),
    ElevatedButton(
      onPressed: () {
        setState(() {
          nombre = nameCtrl.text;
          edad = ageCtrl.text;
          parentesco = relationCtrl.text;
          telefono = phoneCtrl.text;
        });
        Navigator.pop(context);
      },
      child: const Text('Guardar'),
    ),
  ],
),

          ],
        ),
      ),
       ),
    );
  }

}

class ContactSlider extends StatefulWidget {
  const ContactSlider({super.key});

  @override
  State<ContactSlider> createState() => _ContactSliderState();
}

class _ContactSliderState extends State<ContactSlider> {

  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Widget> contacts = const [
    ContactCard(),
    ContactCard(),
  ];

  void nextPage() {
    if (currentPage < contacts.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 388,
      height: 220,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 233, 245, 212),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [

          // PAGE VIEW
          PageView.builder(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(), // 👈 QUITA EL SCROLL
            itemCount: contacts.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return contacts[index];
            },
          ),

          // BOTÓN IZQUIERDA <
          if (currentPage > 0)
            Positioned(
              left: 0,
              top: 70,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 36),
                onPressed: previousPage,
              ),
            ),

          // BOTÓN DERECHA >
          if (currentPage < contacts.length - 1)
            Positioned(
              right: 0,
              top: 70,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 36),
                onPressed: nextPage,
              ),
            ),
        ],
      ),
    );
  }
}

class _VerticalBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onPhoneTap; // 👈 nuevo
  final String? phoneNumber;      // 👈 nuevo

  const _VerticalBox({
    required this.text,
    required this.onTap,
    this.onPhoneTap,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 386,
        height: 87,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(239, 233, 245, 212),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(width: 20),

            // TEXTO
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple,
                ),
              ),
            ),

            // ICONO TELÉFONO
            if (phoneNumber != null)
              IconButton(
                icon: const Icon(
                  Icons.phone,
                  color: Colors.deepPurple,
                ),
                onPressed: onPhoneTap,
              ),
          ],
        ),
      ),
    );
  }
}


class _HorizontalButton extends StatelessWidget {
  final String text;
  final String image;

  const _HorizontalButton({
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            child: InteractiveViewer(
              child: Image.asset(image),
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 120, // más alto para imagen + texto
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0D5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Imagen pequeña
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Texto debajo
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MODELO (siempre fuera del widget)
class InstitucionInfo {
  final String name;
  final String phone;
  final String address;
  final String description;
  final String image;

  InstitucionInfo({
    required this.name,
    required this.phone,
    required this.address,
    required this.description,
    required this.image,
  });
}

  //mas info
void showDetailCard(BuildContext context, InstitucionInfo user) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar', // 👈 OBLIGATORIO
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),

    pageBuilder: (_, __, ___) {
      return  Align(
    alignment: Alignment.bottomCenter, 
    child: Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Material(
  color: Colors.transparent,
        child: Container(
          width: 388,
          height: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(user.image),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // INFO
          Row(
            children: [
              Expanded(
                child: Text(
                  user.phone,
                  style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.deepPurple),
                onPressed: () async {
                  final uri = Uri.parse('tel:${user.phone}');
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              ),
            ],
          ),

            const SizedBox(height: 8),
            Text(
              user.address,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, color: Colors.deepPurple,),
            ),
            const SizedBox(height: 8),
            Text(
              user.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18, color: Colors.deepPurple,),
            ),
            ],
          ),
        ),
      ),
      ),
      );
    },
    
    transitionBuilder: (_, animation, __, child) {
      return ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        ),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
class MiniCardButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback onTap;

  const MiniCardButton({
    super.key,
    required this.text,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0D5),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 8),

            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// CARD
class InstitucionDetailCard extends StatelessWidget {
  final InstitucionInfo data;
  const InstitucionDetailCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 388,
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            children: [
              const SizedBox(width: 56, height: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  data.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _InfoRow(label: 'Dirección:', value: data.address),
          const SizedBox(height: 8),
          _InfoRow(label: 'Número:', value: data.phone),

          const SizedBox(height: 12),

          Expanded(
            child: Text(
              data.description,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 80, child: Text(label)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class HorizontalButtonSlider extends StatefulWidget {
  const HorizontalButtonSlider({super.key});

  @override
  State<HorizontalButtonSlider> createState() =>
      _HorizontalButtonSliderState();
}

class _HorizontalButtonSliderState
    extends State<HorizontalButtonSlider> {

  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Widget> buttons = const [
  MiniCard(
    text: 'Cultura de la paz',
    image: 'assets/imagenes/info_culturapaz.jpeg',
  ),
  MiniCard(
    text: 'Derechos de los nna',
    image: 'assets/imagenes/info_derechosnna.jpeg',
  ),
  MiniCard(
    text: 'Tipos de violencia',
    image: 'assets/imagenes/info_tiposdeviolencia.jpeg',
  ),
];


  void nextPage() {
    if (currentPage < buttons.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _controller.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [

          PageView.builder(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(child: buttons[index]);
            },
          ),

          if (currentPage > 0)
            Positioned(
              left: 0,
              top: 130,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 36),
                onPressed: previousPage,
              ),
            ),

          if (currentPage < buttons.length - 1)
            Positioned(
              right: 0,
              top: 130,
              child: IconButton(
                icon: const Icon(Icons.chevron_right, size: 36),
                onPressed: nextPage,
              ),
            ),
        ],
      ),
    );
  }
}
class MiniCard extends StatelessWidget {
  final String text;
  final String image;

  const MiniCard({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true, // 👈 se cierra tocando afuera
          barrierColor: Colors.black54, // fondo oscuro
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {}, // 👈 evita que se cierre al tocar la imagen
              child: InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 300,
        height: 300,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F0D5),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
  children: [
    Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          image,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    ),
    const SizedBox(height: 8),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    ),
  ],
),

      ),
    );
  }
}

