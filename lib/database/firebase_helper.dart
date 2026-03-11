import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  FirebaseHelper._privateConstructor();
  static final FirebaseHelper instance = FirebaseHelper._privateConstructor();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 SUBIR / ACTUALIZAR USUARIO
  Future<void> subirUsuario(String firebaseUid, Map<String, dynamic> usuario) async {
  await _firestore
      .collection('usuarios')
      .doc(firebaseUid)
        .set({
      'nombre': usuario['nombre'],
      'edad': usuario['edad'],
      'direccion': usuario['direccion'],
      'telefono': usuario['telefono'],
      'email': usuario['email'],
      'foto': usuario['foto'],
    }, SetOptions(merge: true));
  }

  // 🔹 SUBIR / ACTUALIZAR CONTACTO
  Future<void> subirContacto(
    String firebaseUid, int contactoId, Map<String, dynamic> contacto) async {

  await _firestore
      .collection('usuarios')
      .doc(firebaseUid)
      .collection('contactos')
      .doc(contactoId.toString())
      .set({
    'nombre': contacto['nombre'],
    'edad': contacto['edad'],
    'telefono': contacto['telefono'],
    'parentesco': contacto['parentesco'],
    'foto': contacto['foto'],
  }, SetOptions(merge: true));
}
  Future<List<Map<String, dynamic>>> getContactosFirebase(String firebaseUserId) async {
  try {
    var query = await _firestore
        .collection('usuarios')
        .doc(firebaseUserId)
        .collection('contactos')
        .get();

    return query.docs.map((doc) {
      return {
        'firebaseId': doc.id,
        'nombre': doc['nombre'],
        'edad': doc['edad'],
        'telefono': doc['telefono'],
        'parentesco': doc['parentesco'],
        'foto': doc['foto'],
      };
    }).toList();
  } catch (e) {
    print("Error descargando contactos: $e");
    return [];
  }
}
Future<Map<String, dynamic>?> getUsuarioFirebase(String firebaseUid) async {
  try {
    final doc = await _firestore
        .collection('usuarios')
        .doc(firebaseUid)
        .get();

    if (!doc.exists) return null;

    final data = doc.data()!;

    return {
      'nombre': data['nombre'],
      'edad': data['edad'],
      'direccion': data['direccion'],
      'telefono': data['telefono'],
      'email': data['email'],
      'foto': data['foto'],
    };
  } catch (e) {
    print("Error descargando usuario: $e");
    return null;
  }
}
}