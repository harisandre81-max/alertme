import 'package:flutter/material.dart';
import 'page_user_data.dart';
import 'chatbot.dart';
import 'page_carga.dart';
import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:alertme/database/database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

//================funcion para odenar los contactos por prioridad================
  int obtenerPrioridad(String parentesco) {
  switch (parentesco) {
    case 'Padre':
    case 'Madre':
      return 1;
    case 'Tutor':
      return 2;
    case 'Profesor':
      return 3;
    default:
      return 4;
    }
  }

class MenuUI extends StatefulWidget {
  final int usuarioId;

  const MenuUI({
    super.key,
    required this.usuarioId,
  });

  @override
  State<MenuUI> createState() => _MenuUIState();
}

//===================================================
//==============EMERGENCY POPU=======================
//===================================================
class EmergencyPopup extends StatefulWidget {

  final VoidCallback onFinished; // 👈 función que se ejecutará al terminar

  const EmergencyPopup({
    super.key,
    required this.onFinished,
  });

  @override
  State<EmergencyPopup> createState() => _EmergencyPopupState();
}
//===============WIDGET PARA EL POPU==================
class _EmergencyPopupState extends State<EmergencyPopup> {
  int seconds = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        _timer?.cancel();
        widget.onFinished();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 229, 233),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        "🚨 Enviando alerta...",
        style: TextStyle(color: Colors.red),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Se enviará tu ubicación en:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            "$seconds",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "Pulsa cancelar si fue un error.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _timer?.cancel();
            Navigator.pop(context);
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );
  }
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

//==================Menu state=================
class _MenuUIState extends State<MenuUI> {
  static const platform = MethodChannel('sos_channel');

  @override
  void initState() {
    super.initState();

    platform.setMethodCallHandler((call) async {
      if (call.method == "triggerSOS") {
        print("🚨 SOS ACTIVADO");

        // Aquí puedes poner lo que quieras que haga
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🚨 SOS ACTIVADO")),
        );
      }
    });
  }

  void _activarSOSDesdeBoton() async {
    await mostrarubicacion(widget.usuarioId);
  }
  
//==================PANTALLA DE CARGA============
  Future<void> showLoading(BuildContext context, {int seconds = 3}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoadingScreen(),
  );

  await Future.delayed(Duration(seconds: seconds));
  Navigator.of(context).pop();
  }


//==================FUNCION PARA MOSTRAR LA UBICACION DEL USUARIO============
final Location location = Location();

Future<void> mostrarubicacion(int usuarioId) async {
  if (!await checkLocation()) return;
  LocationData datos = await location.getLocation();
  String ubicacion =
  "https://maps.google.com/?q=${datos.latitude},${datos.longitude}";

  // 🔥 Obtener contactos
  final contactosOriginal =
      await DatabaseHelper.instance.getContactos(usuarioId);

  if (contactosOriginal.isEmpty) {
    print("No hay contactos registrados.");
    return;
  }

  final List<Map<String, dynamic>> contactos =
      List<Map<String, dynamic>>.from(contactosOriginal);

  contactos.sort((a, b) {
    int prioridadA = obtenerPrioridad(a['parentesco']);
    int prioridadB = obtenerPrioridad(b['parentesco']);
    return prioridadA.compareTo(prioridadB);
  });
  
  String mensaje =
"Ayuda, estoy en peligro. Mi ubicación es: $ubicacion";

  for (int i = 0; i < contactos.length; i++) {
    String telefono = contactos[i]['telefono'];

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: telefono,
      queryParameters: {
        'body': mensaje,
      },
    );

    await launchUrl(smsUri, mode: LaunchMode.externalApplication);

    // 👇 Esperar a que el usuario regrese y confirme
    if (i < contactos.length - 1) {
      bool continuar = await _mostrarConfirmacionSiguiente(context);

      if (!continuar) break;
    }
  }
}

//==================funcion para checar la localizacion==========================
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
//================funcion para obtener la ubi===================
 Future<LocationData?> ubicacion() async{
  if(!await checkLocation()) return null;
  return await location.getLocation();

 }

//=================funcion para abir la app de mensajes para cada contacto============
Future<bool> _mostrarConfirmacionSiguiente(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 255, 229, 233),
          title: const Text(
            "Mensaje enviado",
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: const Text(
            "¿Deseas enviar la alerta al siguiente contacto?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Sí"),
            ),
          ],
        ),
      ) ??
      false;
}

//==================UI================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 252, 247),

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
                    builder: (_) => UserProfilePage(usuarioId: widget.usuarioId),
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
    // CONTENIDO NORMAL (CON SCROLL)----CONTACTOS WIDGET
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
//==================DATOS DE LOS CONTACTOS DE EMERGENCIA=========
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
                      child: ContactSlider(usuarioId: widget.usuarioId), // 👈 Nuevo widget
                    ),
                  ],
                ),
//==================INFOGRAFIAS=========
                const SizedBox(height: 40),
                const SectionHeader(
                  title: "Infografías",
                  icon: Icons.menu_book,
                ),

                const SizedBox(height: 15),
                  const HorizontalButtonSlider(),//INFOGRAFIAS WIDGET
                const SizedBox(height: 40),

//=====================================================
//==================DATOS DE LAS INSTITUCIONES=========
//=====================================================
                const SectionHeader(
                title: "Instituciones de apoyo",
                icon: Icons.local_hospital,
                ),  
                const SizedBox(height: 15), 
                Column(
                      children: [
//========================Aqui va la informacion de las instituciones================================
                        _VerticalBox(
                      text: 'DIF',
                      image: 'assets/img_institu/dif.png',
                      onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: 'Sistema DIF',
                            phone: '6758670579',
                            address: 'Zona Centro',
                            description: 'Institución pública...',
                            image: 'assets/img_institu/dif.png',
                          ),
                        );
                      },
                      phoneNumber: '911',
                        onPhoneTap: () async {
                          final uri = Uri.parse('tel:911');
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                    ),
                    const SizedBox(height: 20),//espacio
//========================Aqui va la informacion de las instituciones================================
                    _VerticalBox(
                      text: '911',
                      image: 'assets/img_institu/911-logo.png',
                      onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: '911',
                            phone: '+88 01828 9457 20',
                            address: 'Ciudad de México',
                            description: 'Contacto de confianza para emergencias.',
                            image: 'assets/img_institu/911-logo.png',
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
//========================Aqui va la informacion de las instituciones================================
                        _VerticalBox(
                          text: 'Proteción civil',
                          image: 'assets/img_institu/proteccion_civil.png',
                          onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: 'Proteción civil',
                            phone: '+88 01828 9457 20',
                            address: 'Ciudad de México',
                            description: 'Contacto de confianza para emergencias.',
                            image: 'assets/img_institu/proteccion_civil.png',
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
//========================Aqui va la informacion de las instituciones================================
                        _VerticalBox(
                          text: 'Instituto de la mujer',
                          image: 'assets/img_institu/proteccion_civil.png',
                          onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: 'Instituto de la mujer',
                            phone: '+88 01828 9457 20',
                            address: 'Nombre de Dios',
                            description: 'Contacto de confianza para emergencias.',
                            image: 'assets/img_institu/proteccion_civil.png',
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
//========================Aqui va la informacion de las instituciones================================
                        _VerticalBox(
                          text: 'Seguridad publica',
                          image: 'assets/img_institu/proteccion_civil.png',
                          onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: 'Seguridad publica',
                            phone: '+88 01828 9457 20',
                            address: 'Ciudad de México',
                            description: 'Contacto de confianza para emergencias.',
                            image: 'assets/img_institu/proteccion_civil.png',
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
//========================Aqui va la informacion de las instituciones================================
                        _VerticalBox(
                          text: 'Centro de Justicia para los nna',
                          image: 'assets/img_institu/proteccion_civil.png',
                          onTap: () {
                        showDetailCard(
                          context,
                          InstitucionInfo(
                            name: 'Centro de Justicia para Niñas, Niños y Adolescentes Durango',
                            phone: '618 137 3562',
                            address: 'Boulevard José María Patoni Manzana 105 • Predio Rústico La Tinaja y Los Lugos , Durango, Mexico, 34217',
                            description: 'Contacto de confianza para emergencias.',
                            image: 'assets/img_institu/proteccion_civil.png',
                          ),
                        );
                      },
                         phoneNumber: '618 137 3562',
                          onPhoneTap: () async {
                            final uri = Uri.parse('tel:618 137 3562');
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          },
                    ),
//=================================================================================================================
//========================Fin del apartado para la informacion de las instituciones================================
//=================================================================================================================
                  ],
                ),

                const SizedBox(height: 100), // espacio para el menú inferior
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
          // ===============================
          // BOTÓN SOS
          // ===============================
          child: Center(
          child: SizedBox(
            width: 120,
            height: 100,
            child: ElevatedButton(
              onPressed: () async {
                final contactos = await DatabaseHelper.instance
                .getContactos(widget.usuarioId);
                if (contactos.isEmpty) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 255, 229, 233), 
                    title: Row(
                      children: const [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text("Contacto necesario"),
                      ],
                    ),
                    content: const Text(
                      "Para usar el botón SOS necesitas registrar al menos un contacto de emergencia.",
                    ),
                    actions: [
                      TextButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.schedule),
                        label: const Text("Más tarde"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            '/contact1',
                            arguments: widget.usuarioId,
                          );
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text("Registrar ahora"),
                      ),
                              ],
                            ),
                          );
                          return;
                        }

                        // ✅ Si sí tiene contactos
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => EmergencyPopup(
                            onFinished: () async {
                              Navigator.pop(context); // cerrar popup
                              await mostrarubicacion(widget.usuarioId); // enviar ubicación después
                            },
                          ),
                        );
                      },
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
            top: MediaQuery.of(context).size.height / 2 + 110,
            child: GestureDetector(
              onTap: () async {
                await showLoading(context, seconds: 3);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ChatScreen(usuarioId: widget.usuarioId),
                  )     ,
                  );
                },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 212, 255), // morado que ya usas
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
                      Icons.chat_bubble_rounded,
                      color: Colors.white,
                      size: 28,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//===================================ZONA DE WIDGETS 👇👇=============


//=============Contacto card=======================
class ContactCard extends StatelessWidget {
  final Map<String, dynamic> contacto;

  const ContactCard({super.key, required this.contacto});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final avatarRadius = screenWidth * 0.12;
    final titleSize = screenWidth * 0.045; 
    final textSize = screenWidth * 0.04;

    final nombre = contacto['nombre'];
    final edad = contacto['edad'].toString();
    final parentesco = contacto['parentesco'];
    final telefono = contacto['telefono'];
    final foto = contacto['foto'];

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 251),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(width: screenWidth * 0.05),
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: const Color(0xFF5E3AA1),
            backgroundImage: foto != null && foto.toString().isNotEmpty
                ? (foto.toString().startsWith('assets/')
                    ? AssetImage(foto)
                    : FileImage(File(foto)))
                : const AssetImage('assets/avatar.png') as ImageProvider,
          ),

          SizedBox(width: screenWidth * 0.05),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Nombre + botón editar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          nombre,
                          style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5E3AA1),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Color(0xFF5E3AA1),
                      ),
                      onPressed: () async {
                        bool? updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditContactPage(
                              contactId: contacto['id'],
                              contactData: contacto,
                            ),
                          ),
                        );

                        if (updated == true) {
                          final sliderState = context
                              .findAncestorStateOfType<_ContactSliderState>();
                          sliderState?._loadContacts();
                        }
                      },
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01),

                Text(
                  'Edad: $edad',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w500, 
                    color: const Color(0xFF5E3AA1),
                  ),
                ),
                Text(
                  'Parentesco: $parentesco',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w500, 
                    color: const Color(0xFF5E3AA1),
                  ),
                ),
                Text(
                  'Teléfono: $telefono',
                  style: TextStyle(
                    fontSize: textSize,
                    fontWeight: FontWeight.w500, 
                    color: const Color(0xFF5E3AA1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//=============Movimiento del widget contacto con btn < y >, asi como la funcion para agregar contactos=======================
class ContactSlider extends StatefulWidget {
  final int usuarioId;
  const ContactSlider({super.key, required this.usuarioId});

  @override
  State<ContactSlider> createState() => _ContactSliderState();
}

class _ContactSliderState extends State<ContactSlider> {
  final PageController _controller = PageController();
  int currentPage = 0;
  List<Map<String, dynamic>> contacts = [];
  
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
  final datosOriginal =
      await DatabaseHelper.instance.getContactos(widget.usuarioId);

  // 🔥 Crear copia modificable
  final List<Map<String, dynamic>> datos =
      List<Map<String, dynamic>>.from(datosOriginal);

  // 🔥 Ordenar por prioridad
  datos.sort((a, b) {
    int prioridadA = obtenerPrioridad(a['parentesco']);
    int prioridadB = obtenerPrioridad(b['parentesco']);
    return prioridadA.compareTo(prioridadB);
  });

  setState(() {
    contacts = datos;
  });
}
  void nextPage() {
    if (currentPage < (contacts.length < 3 
        ? contacts.length 
        : contacts.length - 1)) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }
  //=============redireccion para registrar los contactos=============
      @override
      Widget build(BuildContext context) {
        int totalPages = contacts.length < 3
        ? contacts.length + 1
        : contacts.length;

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
              PageView.builder(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalPages,
              onPageChanged: (index) {
                setState(() => currentPage = index);
              },
              itemBuilder: (context, index) {
              if (index < contacts.length) {
                return ContactCard(contacto: contacts[index]);
              } else {
                return GestureDetector(
              onTap: () {
                String route = '';
                if (contacts.length == 0) route = '/contact1';
                if (contacts.length == 1) route = '/contact2';
                if (contacts.length == 2) route = '/contact3';

                Navigator.pushNamed(
                  context,
                  route,
                  arguments: widget.usuarioId,
                ).then((_) => _loadContacts());
              },
              child: Container(
                width: 300,
                height: 150,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 254, 251),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Agregar otro contacto",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5E3AA1),
                    ),
                  ),
                  SizedBox(height: 8),
                  Icon(
                    Icons.add,
                    size: 50,
                    color: Color(0xFF5E3AA1),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    },
  ),
          //BOTONES DE CARD CONTACT < Y >
          if (currentPage > 0)
            Positioned(
              left: -20,
              top: 70,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 36),
                onPressed: previousPage,
              ),
            ),

          if (currentPage < totalPages - 1)
            Positioned(
              right: -20,
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

//=============Widget para editar el contacto=============
class EditContactPage extends StatefulWidget {
  final int contactId; // id del contacto en la base de datos
  final Map<String, dynamic> contactData; // datos actuales

  const EditContactPage({
    super.key,
    required this.contactId,
    required this.contactData,
  });

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController nomController;
  late TextEditingController telController;
  late TextEditingController ageController;
  late TextEditingController parentController;
  String? parentescoSeleccionado;

  final List<String> opcionesParentesco = [
    'Padre',
    'Madre',
    'Tutor',
    'Profesor',
  ];
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.contactData['nombre']);
    ageController = TextEditingController(
    text: widget.contactData['edad'].toString(),
    );
    telController = TextEditingController(text: widget.contactData['telefono']);
    parentController = TextEditingController(text: widget.contactData['parentesco']);
    parentescoSeleccionado = widget.contactData['parentesco'];

    // si tiene foto guardada, cargamos el archivo
    if (widget.contactData['foto'] != null &&
        widget.contactData['foto'] != 'assets/avatar.png') {
      _profileImage = File(widget.contactData['foto']);
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    telController.dispose();
    ageController.dispose();
    parentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _updateContact() async {
  final fotoPath = _profileImage?.path ?? 'assets/avatar.png';

  await DatabaseHelper.instance.updateContact(widget.contactId, {
    'nombre': nomController.text,
    'edad': int.parse(ageController.text), // 👈 IMPORTANTE
    'parentesco': parentController.text,
    'telefono': telController.text,
    'foto': fotoPath,
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Contacto actualizado correctamente')),
  );

  // ✅ Devolver un valor para que la pantalla anterior sepa que hubo cambios
  Navigator.pop(context, true);
}


  @override
  Widget build(BuildContext context) {
    InputDecoration customInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: Colors.deepPurple,
    ),
    filled: true,
    fillColor: Colors.white,

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.deepPurple,
        width: 1.5,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.deepPurple,
        width: 2,
      ),
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 255, 252, 247),
      // SUB MENÚ SUPERIOR
      appBar: AppBar(
        toolbarHeight: 110,
        elevation: 0,
        leadingWidth: 80,
        backgroundColor: const Color(0xFFE6F0D5),
        titleSpacing: 80, // 👈 espacio entre leading y title
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
          'Editar contacto',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ), 
      body: SingleChildScrollView(
       padding: const EdgeInsets.all(20),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
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
            // FOTO
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.orange.withOpacity(0.5),
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/avatar.png') as ImageProvider,
                  ),
                  GestureDetector(
                    onTap: _pickImage,
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
            TextFormField(
              controller: nomController,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: customInputDecoration('Nombre'),
            ),

            const SizedBox(height: 20),

            // EDAD
            TextFormField(
              controller: ageController,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: customInputDecoration('Edad'),
            ),

            const SizedBox(height: 20),

            // PARENTESCO
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔹 ETIQUETA
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
  style: const TextStyle(
    color: Colors.deepPurple,
    fontSize: 18, // 👈 AUMENTA AQUÍ
    fontWeight: FontWeight.w500,
  ),
  decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 18, // 👈 hace el campo más alto
    ),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.deepPurple,
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.deepPurple,
        width: 2,
      ),
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  items: opcionesParentesco.map((opcion) {
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
      parentController.text = value ?? '';
    });
  },
),
              ],
            ),

            const SizedBox(height: 20),

            // TELÉFONO
            TextFormField(
              controller: telController,
              style: const TextStyle(
                color: Colors.deepPurple,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: customInputDecoration('Teléfono'),
            ),


            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _updateContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.save, size: 24, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//=============Widget de las instituciones=======================
class _VerticalBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final VoidCallback? onPhoneTap; // 👈 nuevo
  final String? phoneNumber;      // 👈 nuevo
  final String image; 

  const _VerticalBox({
    required this.text,
    required this.onTap,
    this.onPhoneTap,
    required this.image,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: const Color.fromARGB(239, 233, 245, 212),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
             CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 40),

            // TEXTO
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
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

//=============Widget de mas info de las instituciones=======================
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
      color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 252, 247),
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
                radius: 40,
                backgroundImage: AssetImage(user.image),
              ),
              const SizedBox(width: 40),
              const SizedBox(height: 26),
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
            mainAxisSize: MainAxisSize.min,
            children: [
                Text('Telefono:   ',style: const TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple,
                  ),),
                Text(
                  user.phone,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.deepPurple,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
            Text('Direccion:',style: const TextStyle(
                fontSize: 20,
                color: Colors.deepPurple,
              ),),
            const SizedBox(width: 10),
            Text(
              user.address,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 20, color: Colors.deepPurple,),
            ),
            ],
            ),
            const SizedBox(height: 8),
            Text(
              user.description,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 20, color: Colors.deepPurple,),
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


//=============Mini card widget, para mostrar las infografias=======================
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

//=============Mini card button, funcionalidad para ver las imagenes=======================
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

//==========Botones para ver las infografias en carrusel=======
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
//=============Mini card button, funcionalidad para ver las imagenes=======================
class InstitucionDetailCard extends StatelessWidget {
  final InstitucionInfo data;
  const InstitucionDetailCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.3,
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

//==========Funcionalidad para que la imagen superpuesta se cierre
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