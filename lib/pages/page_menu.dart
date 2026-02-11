import 'package:flutter/material.dart';
import 'page_user_data.dart';
import 'page_inicio_de_sesion.dart';
import 'page_carga.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:telephony/telephony.dart';

class MenuUI extends StatelessWidget {
  const MenuUI({super.key});

  Future<void> showLoading(BuildContext context, {int seconds = 3}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingScreen(),
  );

  await Future.delayed(Duration(seconds: seconds));
  Navigator.of(context).pop();
  }

  void showEmergencyPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const EmergencyPopup(),
  );
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // SUB MENÚ SUPERIOR
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        backgroundColor: const Color(0xFFE6F0D5),
        leading: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
             size: 36,
            Icons.verified_user,
            color: Colors.deepPurple,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(

              icon: const Icon(
                size: 36,
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
                Center(
                  child: Container(
                    width: 388,
                    height: 220,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 233, 245, 212),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ContactCard(
                          ),

                          const SizedBox(width: 23),
                          ContactCard(                          
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 80),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),

                      _HorizontalButton(
                        text: 'Cultura de la paz',
                        image: 'assets/imagenes/info_culturapaz.jpeg',
                      ),
                      const SizedBox(width: 16),

                      _HorizontalButton(
                        text: 'Derechos de los nna',
                        image: 'assets/imagenes/info_derechosnna.jpeg',
                      ),
                      const SizedBox(width: 16),

                      _HorizontalButton(
                        text: 'Tipos de violencia',
                        image: 'assets/imagenes/info_tiposdeviolencia.jpeg',
                      ),


                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
                Column(
  children: [
    _VerticalBox(
      text: 'Hola',
      onTap: () {
    showDetailCard(
      context,
      InstitucionInfo(
        name: 'Josh Fechter',
        phone: '+88 01828 9457 20',
        address: 'Ciudad de México',
        description: 'Contacto de confianza para emergencias.',
        image: 'assets/avatar.png',
      ),
    );
  },
    ),
    const SizedBox(height: 20),

    _VerticalBox(
      text: '¿Cómo estás?',
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
    ),
    const SizedBox(height: 20),

    _VerticalBox(
      text: 'Bienvenido, Luis',
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
       child: Transform.translate(
        offset: const Offset(0, -40),
        child: GestureDetector(
      onTap: () {
        showEmergencyPopup(context);
      },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 98, 98),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
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
              builder: (context) => const InicioDeSesion(),
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
  String nombre = 'Josh Fechter';
  String edad = '32';
  String parentesco = 'Hermano';
  String telefono = '+88 01828 9457 20';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFE6D9FF),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text( nombre,
                        style: TextStyle(
                          fontSize: 18,
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
                 Text('Edad: $edad', style: const TextStyle(color: Color(0xFF5E3AA1))),
                 Text('Parentezco: $parentesco', style: const TextStyle(color: Color(0xFF5E3AA1))),
                 Text(telefono, style: const TextStyle(color: Color(0xFF5E3AA1))),

              ],
            ),
          )
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



class _VerticalBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _VerticalBox({
    required this.text,
    required this.onTap,
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
            const SizedBox(width: 10),
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/avatar.png'),
            ),
            const SizedBox(width: 50),
            Text(
              text, // 👈 TEXTO VARIABLE
              style: const TextStyle(
                fontSize: 16,
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
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          );
        },
      );
    },
    child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color:  Color(0xFFFFB562),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
}

class EmergencyPopup extends StatefulWidget {
  const EmergencyPopup({super.key});

  @override
  State<EmergencyPopup> createState() => _EmergencyPopupState();
}

class _EmergencyPopupState extends State<EmergencyPopup>
    with SingleTickerProviderStateMixin {

 Future<String> getLocation() async {
  final permission = await Permission.location.request();
  if (!permission.isGranted) return 'Ubicación no permitida';

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  return 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
} 

  final Telephony telephony = Telephony.instance;


Future<void> sendSMSWithLocation() async {
  bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

  if (permissionsGranted != true) {
    print("Permiso SMS denegado");
    return;
  }

  final location = await getLocation();

  await telephony.sendSms(
    to: '6751107805',
    message: 'hola beto\nMi ubicación es:\n$location',
  );

  print("SMS enviado");
}


  int _countdown = 3;
  Timer? _timer;
  late AnimationController _anim;
  bool _sent = false;


  @override
  void initState() {
    super.initState();

    // Animación de pulso
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 0.9,
      upperBound: 1.05,
    )..repeat(reverse: true);

    // Contador
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
  if (_countdown == 1) {
    timer.cancel();

    setState(() {
      _countdown = 0;
      _sent = true;
    });

      await sendSMSWithLocation();


    // simula envío y cierra el popup
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });

  } else {
    setState(() {
      _countdown--;
    });
  }
});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.redAccent.withOpacity(0.95),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            

            ScaleTransition(
              scale: _anim,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 100),

             Text(
            _sent ? '🚨 Alerta enviada' : 'Enviando alerta en...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),


            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Enviando alerta a tus contactos, mantente a salvo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ),

            const SizedBox(height: 100),

            // AVATARES
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/avatar.png')),
                SizedBox(width: 12),
                CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/avatar.png')),
                SizedBox(width: 12),
                CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/avatar.png')),
              ],
            ),

            const SizedBox(height: 100),

            // BOTÓN CANCELAR
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
