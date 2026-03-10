import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TerminosUIPage extends StatelessWidget {
  const TerminosUIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF6E3),
       // SUB MENÚ SUPERIOR
      appBar: AppBar(
  toolbarHeight: 110,
  elevation: 0,
  leadingWidth: 80,
  backgroundColor: const Color(0xFFE6F0D5),

  titleSpacing: 40, // 👈 espacio entre leading y title

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
    'Términos y Condiciones',
    style: TextStyle(
      color: Colors.deepPurple,
      fontWeight: FontWeight.w600,
    ),
  ),
),

body: Stack(
  children: [ 
ListView(
  padding: const EdgeInsets.all(20),
  children: [
    const SizedBox(height: 40),
    _buildBloque(
      "Bienvenido/a a AlertMe.",
      "Al descargar, instalar, registrarte o utilizar Alertme, aceptas de manera expresa y voluntaria los presentes Términos y Condiciones de Uso. Si no estás de acuerdo con ellos, te recomendamos no utilizar la Aplicación.",
    ),

    _buildBloque(
  "1. OBJETIVO DE LA APLICACIÓN",
  '''
Alertme tiene como finalidad contribuir a la prevención, orientación y reporte de situaciones de violencia o agresión, mediante:

• El envío de mensajes de alerta a los contactos registrados por el usuario al presionar un botón de emergencia.

• El acceso a números telefónicos de instituciones locales y organismos de apoyo especializados en casos de violencia.

Alertme no sustituye los servicios de emergencia, autoridades policiales, asesoría legal ni atención médica profesional.
  ''',
),

    _buildBloque(
  "2. USUARIOS",
  '''
Alertme está dirigida a personas que desen contar con una herramienta de apoyo y prevención ante situaciones de riesgo. Al utilizarla, declaras que:

• Proporcionaras información veraz, actualizada y completa.

• En caso de registrar datos de terceros (contactos), cuentas con su consentimiento previo.
  ''',
),
_buildBloque(
  "3. REGISTRO Y DATOS DEL USUARIO",
  '''
Para el uso de ciertas funcionalidades, el usuario deberá proporcionar:

• Información básica para el inicio de sesión, como correo electrónico y la contraseña con la que realizó el registro.

• Información básica para el registro de usuario, como nombre, edad, dirección, número de teléfono, correo electrónico y una contraseña para el registro.

• Información básica para el registro de los contactos, como nombre, edad y número de teléfono.

El padre, madre o tutor legal del usuario será responsable del uso y resguardo de la cuenta, así como de las acciones realizadas desde ella.

Al autorizar el registro del menor, el tutor acepta estas responsabilidades.
  ''',
),
_buildBloque(
  "4. PERMISOS DE LA APLICACIÓN",
  '''
Para el correcto funcionamiento de Alertme, el usuario autoriza de forma expresa el acceso a:

• Ubicación del dispositivo, con el fin de compartirla en los mensajes de alerta enviados a los contactos registrados.

• Servicio de SMS o mensajería, para el envío automático de mensajes de emergencia.

La negativa a otorgar estos permisos puede limitar o impedir el funcionamiento de algunas características clave de la aplicación.
  ''',
),
_buildBloque(
  "5. USO DEL BOTÓN DE ALERTA",
  '''
El botón de alerta está diseñado exclusivamente para situaciones reales de riesgo o emergencia. El usuario se compromete a:

• No hacer uso indebido, falso o malintencionado del botón.

• Entender que el envío de mensajes depende de factores externos como la conectividad, la señal móvil y la disponibilidad del servicio de mensajería.

• Alertme no garantiza que los contactos respondan ni que la ayuda llegue de forma inmediata.
  ''',
),
_buildBloque(
  "6. CHATBOT E INFORMACIÓN PROPORCIONADA",
  '''
El chatbot de Alertme:

• Ofrece orientación general e informativa.

• No constituye asesoría profesional, legal, psicológica ni médica.

• No reemplaza la atención de especialistas ni de autoridades competentes.

• Las decisiones que el usuario tome a partir de la información proporcionada son de su exclusiva responsabilidad.
  ''',
),
_buildBloque(
  "7. CONTENIDO INFORMATIVO",
  '''
Las infografías y materiales informativos tienen fines educativos y de concientización.

La información fue recolectada de fuentes oficiales y confiables, tales como:

• La página oficial del Gobierno de México

• UNESCO

• Sitios especializados en psicología y bienestar, como Psicología Online 

Aunque se procura que la información sea actualizada y confiable, no se garantiza su total exactitud o vigencia.
  ''',
),
_buildBloque(
  "8. RESPONSABILIDAD Y LIMITACIÓN DE GARANTÍAS",
  '''
El uso de Alertme se realiza bajo tu propio riesgo. AlertMe no será responsable por:

• Daños directos o indirectos derivados del uso o la imposibilidad de uso de la Aplicación.

• Fallas técnicas, interrupciones del servicio o errores en el envío de mensajes.

• Consecuencias derivadas de la información proporcionada por el chatbot o del contenido informativo.
  ''',
),
_buildBloque(
  "9. PROTECCIÓN DE DATOS PERSONALES",
  '''
El tratamiento de los datos personales se realizará conforme a lo dispuesto por la Ley Federal de Protección de Datos Personales en Posesión de los Particulares y demás disposiciones aplicables en México.

Los datos personales proporcionados por el usuario serán utilizados únicamente para las finalidades descritas en estos Términos y condiciones.

Alertme implementa medidas de seguridad administrativas, técnicas y físicas para proteger la información contra daño, pérdida, alteración, destrucción o acceso no autorizado. Entre dichas medidas se incluye el uso de mecanismos de cifrado (encriptación) para el resguardo de la información, con el fin de evitar que terceros no autorizados puedan acceder a los datos.
  ''',
),

_buildBloque(
  "10. MODIFICACIONES",
  '''
Nos reservamos el derecho de modificar estos Términos en cualquier momento, conforme a lo permitido por la Ley Federal de Protección de Datos Personales en Posesión de los Particulares.

En caso de realizarse cambios relevantes, estos serán notificados dentro de la Aplicación y el usuario deberá aceptar expresamente los nuevos Términos y Condiciones para continuar utilizando el servicio.
  ''',
),
_buildBloque(
  "11. LEGISLACIÓN APLICABLE Y JURISDICCIÓN",
  '''
Estos Términos se rigen por las leyes de los Estados Unidos Mexicanos, incluyendo, de manera enunciativa más no limitativa, el Código Civil Federal, el Código de Comercio, la Ley Federal de Protección de Datos Personales en Posesión de los Particulares y demás disposiciones aplicables. Cualquier controversia será sometida a los tribunales competentes en Durango, México.
  ''',
),
    const SizedBox(height: 40),
  ],
),
Positioned(
      top: 20, // distancia desde arriba
      left: 10, // distancia desde la izquierda
      child: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        mini: true, // más pequeño
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    ),
  ],
),
    );
  }
}
Widget _buildBloque(String titulo, String contenido) {
  return Container(
    margin: const EdgeInsets.only(bottom: 20),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 10),
        Text(
  contenido,
  style: const TextStyle(
    fontSize: 14,
    color: Colors.deepPurple, // 👈 todo morado
  ),
),
      ],
    ),
  );
}
